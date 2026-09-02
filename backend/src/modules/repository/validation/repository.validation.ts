import { z } from 'zod';

const objectIdRegex = /^[0-9a-fA-F]{24}$/;
// Match from the mongoose schema: /^(https?:\/\/)?(www\.)?github\.com\/[a-zA-Z0-9_.-]+\/[a-zA-Z0-9_.-]+$/
const githubUrlRegex = /^(https?:\/\/)?(www\.)?github\.com\/[a-zA-Z0-9_.-]+\/[a-zA-Z0-9_.-]+$/;

export const createRepositorySchema = z.object({
  body: z.object({
    projectId: z.string().regex(objectIdRegex, 'Invalid Project ID'),
    repositoryUrl: z.string().regex(githubUrlRegex, 'Invalid GitHub Repository URL').optional().nullable(),
    repositoryName: z.string().min(1).max(100),
    provider: z.string().optional(),
    githubInstallationId: z.string().optional().nullable(),
    githubRepositoryId: z.number().optional().nullable(),
    githubRepositoryFullName: z.string().optional().nullable(),
    sourceConfiguration: z.object({
      code: z.boolean(),
      docs: z.boolean(),
      prs: z.boolean(),
    }).optional().nullable(),
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
