import { logger } from '../../../config/logger';
import crypto from 'crypto';

export interface IEmbeddingConfig {
  apiKey: string;
  modelName?: string;
  timeoutMs?: number;
  maxRetries?: number;
}

export class EmbeddingClient {
  private readonly baseUrl = 'https://api.mistral.ai/v1';

  constructor(private readonly config: IEmbeddingConfig) {
    this.config.modelName = this.config.modelName || 'mistral-embed';
    this.config.timeoutMs = this.config.timeoutMs || 10000; // 10s default
    this.config.maxRetries = this.config.maxRetries ?? 3;
  }

  private async sleep(ms: number) {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }

  /**
   * Generates a 1024-dimension float array embedding from Mistral AI.
   * Includes exponential backoff retries and timeout handling.
   */
  async generateEmbedding(input: string): Promise<number[]> {
    const url = `${this.baseUrl}/embeddings`;
    const headers = {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${this.config.apiKey}`,
    };

    const body = {
      model: this.config.modelName,
      input: [input],
    };

    let attempt = 0;
    const maxAttempts = this.config.maxRetries! + 1;
    const requestId = crypto.randomUUID();

    while (attempt < maxAttempts) {
      attempt++;
      const startTime = Date.now();
      const abortController = new AbortController();
      const timeoutId = setTimeout(() => abortController.abort(), this.config.timeoutMs);

      try {
        const response = await fetch(url, {
          method: 'POST',
          headers,
          body: JSON.stringify(body),
          signal: abortController.signal,
        });

        clearTimeout(timeoutId);
        const duration = Date.now() - startTime;

        if (!response.ok) {
          const errorText = await response.text();
          
          if (response.status === 429) {
            logger.warn({ attempt, requestId, duration, status: response.status }, 'Embedding API Rate Limited');
            if (attempt < maxAttempts) {
              await this.sleep(attempt * 2000); // Exponential-ish backoff
              continue;
            }
          }
          
          if (response.status >= 500 && attempt < maxAttempts) {
            logger.warn({ attempt, requestId, duration, status: response.status }, 'Embedding API 5xx Error, retrying');
            await this.sleep(attempt * 1000);
            continue;
          }

          throw new Error(`Embedding API Error (${response.status}): ${errorText}`);
        }

        const json = await response.json();
        const tokens = json.usage ? json.usage.total_tokens : undefined;

        logger.info({ requestId, duration, tokens, model: this.config.modelName, attempt }, 'Embedding API Success');
        
        if (!json.data || json.data.length === 0 || !json.data[0].embedding) {
          throw new Error('Embedding API returned malformed data.');
        }

        return json.data[0].embedding;
      } catch (error) {
        clearTimeout(timeoutId);
        const duration = Date.now() - startTime;
        
        if (error instanceof Error && error.name === 'AbortError') {
          logger.warn({ attempt, requestId, duration }, 'Embedding API Request Timeout');
          if (attempt < maxAttempts) {
            await this.sleep(attempt * 1000);
            continue;
          }
        }
        
        logger.error({ error, model: this.config.modelName, requestId, duration, attempt }, 'Embedding API failed');
        throw error;
      }
    }

    throw new Error('Embedding API failed after max retries.');
  }
}
