import { z } from 'zod';

export const createOrganizationSchema = z.object({
  body: z.object({
    name: z.string().min(2).max(100),
    slug: z.string().regex(/^[a-z0-9-]+$/).min(2).max(100),
  }),
});

export const updateOrganizationSchema = z.object({
  params: z.object({
    id: z.string().regex(/^[0-9a-fA-F]{24}$/, 'Invalid MongoDB ID'),
  }),
  body: z.object({
    name: z.string().min(2).max(100).optional(),
  }),
});

export const getOrganizationSchema = z.object({
  params: z.object({
    id: z.string().regex(/^[0-9a-fA-F]{24}$/, 'Invalid MongoDB ID'),
  }),
});
