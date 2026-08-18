import { z } from 'zod';
import { DocumentStatus } from '../model/document.model';

const objectIdRegex = /^[0-9a-fA-F]{24}$/;

export const getDocumentSchema = z.object({
  params: z.object({
    id: z.string().regex(objectIdRegex, 'Invalid MongoDB ID'),
  }),
});

export const getDocumentsQuerySchema = z.object({
  query: z.object({
    projectId: z.string().regex(objectIdRegex, 'Invalid Project ID').optional(),
    repositoryId: z.string().regex(objectIdRegex, 'Invalid Repository ID').optional(),
    status: z.nativeEnum(DocumentStatus).optional(),
  }),
});
