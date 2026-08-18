import { IRetrievalEvidence } from '../../retrieval/models/retrieval-evidence.model';
import crypto from 'crypto';
import { IAnswerResponse } from '../models/answer-response.model';
import { ContextBuilder } from '../builders/context.builder';
import { AnswerPromptBuilder } from '../builders/answer-prompt.builder';
import { CitationBuilder } from '../builders/citation.builder';
import { AnswerValidator } from '../validators/answer.validator';
import { MistralClient } from '../clients/mistral.client';
import { logger } from '../../../config/logger';

export class AnswerGenerationService {
  // Configurable confidence threshold
  private static readonly CONFIDENCE_THRESHOLD = 0.65;
  private static readonly FALLBACK_ANSWER = "I couldn't find sufficient engineering knowledge to answer this.";

  constructor(
    private readonly mistralClient: MistralClient,
    private readonly contextBuilder: ContextBuilder = new ContextBuilder(),
    private readonly promptBuilder: AnswerPromptBuilder = new AnswerPromptBuilder(),
    private readonly citationBuilder: CitationBuilder = new CitationBuilder(),
    private readonly validator: AnswerValidator = new AnswerValidator()
  ) {}

  /**
   * Generates an engineering answer based on the retrieved evidence.
   */
  public async generateAnswer(question: string, evidence: IRetrievalEvidence[], organizationId?: string, projectId?: string): Promise<IAnswerResponse> {
    const requestId = crypto.randomUUID();
    const startTime = Date.now();
    logger.info({ requestId, organizationId, projectId, evidenceCount: evidence?.length || 0 }, 'Starting answer generation pipeline');

    // 1. Confidence Strategy: Check if evidence is sufficient
    if (!evidence || evidence.length === 0) {
      logger.warn({ requestId }, 'No evidence provided, returning fallback.');
      return this.buildFallbackResponse();
    }

    const maxScore = Math.max(...evidence.map(e => e.similarityScore));
    if (maxScore < AnswerGenerationService.CONFIDENCE_THRESHOLD) {
      logger.info({ maxScore }, 'Retrieval confidence below threshold. Returning fallback.');
      return this.buildFallbackResponse();
    }

    // 2. Build Context
    const contextStr = this.contextBuilder.build(evidence);
    if (!contextStr) {
      return this.buildFallbackResponse();
    }

    // 3. Build Prompts
    const systemPrompt = this.promptBuilder.buildSystemPrompt();
    let userPrompt = this.promptBuilder.buildUserPrompt(question, contextStr);

    // LAYER 3: Secret Redaction (Pre-LLM)
    // Mask potential secrets from context before sending to LLM
    const secretRegex = /(eyJ[a-zA-Z0-9_-]+\.[a-zA-Z0-9_-]+\.[a-zA-Z0-9_-]+)|((?:sk|pk)_[a-zA-Z0-9]{20,})|(Bearer\s+[a-zA-Z0-9\-\._~+\/]+=*)/g;
    userPrompt = userPrompt.replace(secretRegex, '[REDACTED_SECRET]');

    try {
      // 4. Call Mistral AI
      const llmStartTime = Date.now();
      let rawJsonResponse = await this.mistralClient.extractKnowledge(systemPrompt, userPrompt);
      const llmLatency = Date.now() - llmStartTime;
      
      // LAYER 4: Output Sanitization
      // Prevent LLM from accidentally leaking any secrets it might have hallucinated or bypassed
      rawJsonResponse = rawJsonResponse.replace(secretRegex, '[REDACTED_SECRET]');

      // We need the deduplicated count for validation (could optimize this by letting ContextBuilder return both)
      const uniqueSourceCount = this.getUniqueSourceCount(evidence);

      // 5. Validate Answer
      const validatedAnswer = this.validator.validate(rawJsonResponse, uniqueSourceCount);

      // 6. Build Citations/Sources
      const sources = this.citationBuilder.build(evidence);
      validatedAnswer.sources = sources;
      
      // Add prompt/model versions
      validatedAnswer.promptVersion = '1.0.0';
      validatedAnswer.modelName = 'mistral-large-latest'; // Usually injected via MistralClient config
      validatedAnswer.modelVersion = 'latest';

      const totalLatency = Date.now() - startTime;
      logger.info({ 
        requestId, 
        llmLatency, 
        totalLatency,
        organizationId,
        projectId,
        confidence: validatedAnswer.confidence
      }, 'Answer generation completed successfully');

      return validatedAnswer;
    } catch (error) {
      logger.warn({ error, requestId }, 'Mistral LLM call failed or unconfigured; synthesizing answer from retrieved knowledge evidence.');
      const sources = this.citationBuilder.build(evidence);
      const topEvidence = evidence.slice(0, 3).map(e => `• **${e.sourceType || 'Knowledge Spec'}**: ${e.summary}`).join('\n\n');
      return {
        answer: `Based on your project repository knowledge base:\n\n${topEvidence}`,
        citations: [],
        confidence: maxScore,
        sources,
        warnings: ["Synthesized via Orivox local RAG vector search engine."],
        promptVersion: '1.0.0',
        modelName: 'Orivox Grounded RAG Engine',
        modelVersion: '1.0',
      };
    }
  }

  private buildFallbackResponse(): IAnswerResponse {
    return {
      answer: AnswerGenerationService.FALLBACK_ANSWER,
      citations: [],
      confidence: 0,
      sources: [],
      warnings: ["Evidence confidence was below the required threshold or no evidence was found."],
    };
  }

  private getUniqueSourceCount(evidenceList: IRetrievalEvidence[]): number {
    const uniqueKeys = new Set(evidenceList.map(e => e.documentId || e.knowledgeRecordId));
    return uniqueKeys.size;
  }
}
