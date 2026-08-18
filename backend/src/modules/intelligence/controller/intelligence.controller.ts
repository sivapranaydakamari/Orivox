import { Request, Response } from 'express';
import { ApiResponse } from '../../../shared/utils/apiResponse';
import { asyncHandler } from '../../../shared/utils/asyncHandler';
import { auditService } from '../../audit/service/audit.service';
import { AskDto } from '../dto/ask.dto';

// Need to lazy-instantiate or inject these services normally, but we will instantiate them here for now
import { QueryEmbeddingService } from '../../retrieval/services/query-embedding.service';
import { RetrievalPipeline } from '../../retrieval/services/retrieval-pipeline.service';
import { AnswerGenerationService } from '../services/answer-generation.service';
import { EmbeddingClient } from '../clients/embedding.client';
import { MistralClient } from '../clients/mistral.client';
import { env } from '../../../config/env';

import { VectorSearchService } from '../../retrieval/services/vector-search.service';
import { RetrievalRanker } from '../../retrieval/services/retrieval-ranker.service';

// Factory to initialize services for the controller
const embeddingClient = new EmbeddingClient({ apiKey: env.MISTRAL_API_KEY });
const mistralClient = new MistralClient({ apiKey: env.MISTRAL_API_KEY });
const queryEmbeddingService = new QueryEmbeddingService(embeddingClient);
const vectorSearchService = new VectorSearchService();
const retrievalRanker = new RetrievalRanker();
const retrievalPipeline = new RetrievalPipeline(queryEmbeddingService, vectorSearchService, retrievalRanker);
const answerGenerationService = new AnswerGenerationService(mistralClient);

export class IntelligenceController {
  ask = asyncHandler(async (req: Request, res: Response) => {
    const { projectId, question } = req.body as AskDto;
    const organizationId = req.user!.organizationId;

    // Log action
    await auditService.logAction(organizationId, 'ASK_AI', 'PROJECT', projectId, req.user!.id, projectId);

    // 1. Generate query embedding & Retrieve evidence
    const evidence = await retrievalPipeline.retrieve(question, { organizationId, projectId });

    // 2. Generate answer based on evidence
    const answer = await answerGenerationService.generateAnswer(question, evidence, organizationId, projectId);

    ApiResponse.success(res, answer, 'Answer generated successfully');
  });
}

export const intelligenceController = new IntelligenceController();
