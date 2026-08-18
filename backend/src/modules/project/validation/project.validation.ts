import { z } from 'zod';

const objectIdRegex = /^[0-9a-fA-F]{24}$/;

export const createProjectSchema = z.object({
  body: z.object({
    name: z.string().min(2).max(100),
    description: z.string().optional(),
  }),
});

export const updateProjectSchema = z.object({
  params: z.object({
    id: z.string().regex(objectIdRegex, 'Invalid MongoDB ID'),
  }),
  body: z.object({
    name: z.string().min(2).max(100).optional(),
    description: z.string().optional(),
  }),
});

export const getProjectSchema = z.object({
  params: z.object({
    id: z.string().regex(objectIdRegex, 'Invalid MongoDB ID'),
  }),
});
