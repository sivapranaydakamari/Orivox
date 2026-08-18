import { z } from 'zod';

export const loginSchema = z.object({
  body: z.object({
    email: z.string().email(),
    password: z.string().min(8).optional(),
  }),
});

export const registerSchema = z.object({
  body: z.object({
    email: z.string().email(),
    name: z.string().min(2).max(100),
    password: z.string().min(8).optional(),
  }),
});

export const resetPasswordSchema = z.object({
  body: z.object({
    resetToken: z.string(),
    newPassword: z.string().min(8),
  }),
});

export const refreshSchema = z.object({
  body: z.object({
    refreshToken: z.string(),
  }),
});

export const logoutSchema = z.object({
  body: z.object({
    refreshToken: z.string(),
  }),
});
