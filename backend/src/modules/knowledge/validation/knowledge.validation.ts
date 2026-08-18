import { z } from 'zod';
import { SourceType, ConfidenceLevel, EmbeddingStatus } from '../model/knowledgeRecord.model';

const objectIdRegex = /^[0-9a-fA-F]{24}$/;

export const getKnowledgeRecordSchema = z.object({
  params: z.object({
    id: z.string().regex(objectIdRegex, 'Invalid MongoDB ID'),
  }),
});

export const getKnowledgeQuerySchema = z.object({
  query: z.object({
    projectId: z.string().regex(objectIdRegex, 'Invalid Project ID').optional(),
    repositoryId: z.string().regex(objectIdRegex, 'Invalid Repository ID').optional(),
    sourceType: z.nativeEnum(SourceType).optional(),
    confidence: z.nativeEnum(ConfidenceLevel).optional(),
    status: z.nativeEnum(EmbeddingStatus).optional(),
  }),
});
