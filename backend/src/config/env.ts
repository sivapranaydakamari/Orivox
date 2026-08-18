import { z } from 'zod';
import dotenv from 'dotenv';

// Load .env based on NODE_ENV if needed, though usually docker/pm2 sets this.
// For local fallback:
const envFile = process.env.NODE_ENV ? `.env.${process.env.NODE_ENV}` : '.env.development';
dotenv.config({ path: envFile });

const envSchema = z.object({
  PORT: z.string().default('3000'),
  NODE_ENV: z.enum(['development', 'production', 'test']).default('development'),
  MONGO_URI: z.string().default('mongodb://localhost:27017/engineering-knowledge'),
  MISTRAL_API_KEY: z.string(),
  REDIS_URL: z.string().default('redis://localhost:6379'),
  JWT_SECRET: z.string().default('fallback_secret_do_not_use_in_prod'),
  JWT_REFRESH_SECRET: z.string().default('fallback_refresh_secret'),
});

const parsedEnv = envSchema.safeParse(process.env);

if (!parsedEnv.success) {
  console.error('Invalid environment variables', parsedEnv.error.format()); // eslint-disable-line no-console
  process.exit(1);
}

export const env = parsedEnv.data;
