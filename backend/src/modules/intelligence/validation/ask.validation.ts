import { z } from 'zod';

const objectIdRegex = /^[0-9a-fA-F]{24}$/;

export const askSchema = z.object({
  body: z.object({
    scope: z.enum(['CURRENT_PROJECT', 'ALL_PROJECTS']).optional(),
    projectId: z.string().regex(objectIdRegex, 'Invalid Project ID').optional(),
    question: z.string().min(3, 'Question is too short').max(1000, 'Question is too long'),
  }),
});
