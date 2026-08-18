import { Types } from 'mongoose';
import { documentRepository } from '../../document/repository/document.repository';
import { DocumentStatus } from '../../document/model/document.model';
import { KnowledgeRecord, SourceType, IKnowledgeRecord } from '../../knowledge/model/knowledgeRecord.model';
import { GitHubPrParser } from '../parsers/github-pr.parser';
import { promptBuilder } from '../services/prompt-builder.service';
import { MistralClient } from '../clients/mistral.client';
import { responseValidator } from '../validators/response.validator';
import { logger } from '../../../config/logger';

export class AIExtractionService {
  constructor(
    private readonly mistralClient: MistralClient,
    private readonly parser = new GitHubPrParser()
  ) {}

  /**
   * Orchestrates the AI Extraction flow for a given document.
   */
  async extractDocument(documentId: string | Types.ObjectId): Promise<IKnowledgeRecord | null> {
    logger.info({ documentId }, 'AIExtractionService: Starting extraction');

    // 1. Atomic fetch and update to EXTRACTING (fixes race conditions and allows retrying FAILED documents)
    const document = await documentRepository.findOneAndUpdate(
      { 
        _id: documentId, 
        status: { $in: [DocumentStatus.PENDING, DocumentStatus.FAILED] } 
      },
      { status: DocumentStatus.EXTRACTING }
    );

    if (!document) {
      logger.warn({ documentId }, 'Document is not PENDING or FAILED, or another worker is already processing it. Skipping extraction.');
      return null;
    }

    try {

      // 2. Parse Document
      const parsedDoc = this.parser.parse(document);

      // 3. Build Prompts
      const systemPrompt = promptBuilder.buildSystemPrompt();
      const userPrompt = promptBuilder.buildUserPrompt(parsedDoc);

      // 4. Call Mistral AI
      const rawJsonResponse = await this.mistralClient.extractKnowledge(systemPrompt, userPrompt);

      // 5. Validate Response via Zod
      const extractedData = responseValidator.validate(rawJsonResponse);

      // 6. Create Knowledge Record
      const record = await KnowledgeRecord.create({
        organizationId: document.organizationId,
        projectId: document.projectId,
        sourceType: document.sourceType as unknown as SourceType,
        sourceReferenceId: document.externalId || document._id.toString(),
        title: parsedDoc.title,
        summary: extractedData.summary,
        technicalDecisions: extractedData.technicalDecisions,
        businessContext: extractedData.businessContext,
        risks: extractedData.risks,
        breakingChanges: extractedData.breakingChanges,
        dependencies: extractedData.dependencies,
        affectedComponents: extractedData.componentsAffected,
        referencedApis: extractedData.apisMentioned,
        confidence: extractedData.confidenceScore,
        knowledgeVersion: 1,
        documentId: document._id,
        metadata: {
          promptVersion: '1.0',
          parserVersion: '1.0',
          modelName: 'mistral-large-latest',
          modelVersion: 'latest',
          extractedAt: new Date(),
        },
      });

      // 7. Update Document Status
      await documentRepository.update(document._id.toString(), { status: DocumentStatus.EXTRACTED });

      logger.info({ documentId, recordId: record._id }, 'AIExtractionService: Successfully extracted and created KnowledgeRecord');
      return record;
    } catch (error) {
      logger.error({ error, documentId }, 'AIExtractionService: Extraction failed');

      // Revert/Mark as Failed
      await documentRepository.update(documentId.toString(), { status: DocumentStatus.FAILED });

      throw error;
    }
  }
}
