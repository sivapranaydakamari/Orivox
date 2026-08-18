import { z } from 'zod';

const objectIdRegex = /^[0-9a-fA-F]{24}$/;
// Match from the mongoose schema: /^(https?:\/\/)?(www\.)?github\.com\/[a-zA-Z0-9_.-]+\/[a-zA-Z0-9_.-]+$/
const githubUrlRegex = /^(https?:\/\/)?(www\.)?github\.com\/[a-zA-Z0-9_.-]+\/[a-zA-Z0-9_.-]+$/;

export const createRepositorySchema = z.object({
  body: z.object({
    projectId: z.string().regex(objectIdRegex, 'Invalid Project ID'),
    repositoryUrl: z.string().regex(githubUrlRegex, 'Invalid GitHub Repository URL'),
    repositoryName: z.string().min(1).max(100),
    provider: z.string().optional(),
  }),
});

export const updateRepositorySchema = z.object({
  params: z.object({
    id: z.string().regex(objectIdRegex, 'Invalid MongoDB ID'),
  }),
  body: z.object({
    isActive: z.boolean().optional(),
  }),
});

export const getRepositorySchema = z.object({
  params: z.object({
    id: z.string().regex(objectIdRegex, 'Invalid MongoDB ID'),
  }),
});
