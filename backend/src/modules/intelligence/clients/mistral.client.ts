import { logger } from '../../../config/logger';
import crypto from 'crypto';

export interface IMistralConfig {
  apiKey: string;
  modelName?: string;
  temperature?: number;
  maxTokens?: number;
  timeoutMs?: number;
  maxRetries?: number;
}

export class MistralClient {
  private readonly baseUrl = 'https://api.mistral.ai/v1';

  constructor(private readonly config: IMistralConfig) {
    this.config.modelName = this.config.modelName || 'mistral-large-latest';
    this.config.temperature = this.config.temperature ?? 0.2;
    this.config.maxTokens = this.config.maxTokens || 4000;
    this.config.timeoutMs = this.config.timeoutMs || 30000; // 30s default
    this.config.maxRetries = this.config.maxRetries ?? 3;
  }

  private async sleep(ms: number) {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }

  /**
   * Extracts knowledge by sending system and user prompts to Mistral AI.
   * Forces JSON output.
   */
  async extractKnowledge(systemPrompt: string, userPrompt: string): Promise<string> {
    const url = `${this.baseUrl}/chat/completions`;
    const headers = {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${this.config.apiKey}`,
    };

    const body = {
      model: this.config.modelName,
      temperature: this.config.temperature,
      max_tokens: this.config.maxTokens,
      response_format: { type: 'json_object' },
      messages: [
        { role: 'system', content: systemPrompt },
        { role: 'user', content: userPrompt },
      ],
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
            logger.warn({ attempt, requestId, duration, status: response.status }, 'Mistral API Rate Limited');
            if (attempt < maxAttempts) {
              await this.sleep(attempt * 2000);
              continue;
            }
          }
          
          if (response.status >= 500 && attempt < maxAttempts) {
            logger.warn({ attempt, requestId, duration, status: response.status }, 'Mistral API 5xx Error, retrying');
            await this.sleep(attempt * 1000);
            continue;
          }

          throw new Error(`Mistral API Error (${response.status}): ${errorText}`);
        }

        const json = await response.json();
        const usage = json.usage || {};

        logger.info({ 
          requestId, 
          duration, 
          model: this.config.modelName, 
          attempt,
          tokens: usage.total_tokens,
          promptTokens: usage.prompt_tokens,
          completionTokens: usage.completion_tokens 
        }, 'Mistral API Success');
        
        if (!json.choices || json.choices.length === 0) {
          throw new Error('Mistral API returned no choices.');
        }

        return json.choices[0].message.content;
      } catch (error) {
        clearTimeout(timeoutId);
        const duration = Date.now() - startTime;
        
        if (error instanceof Error && error.name === 'AbortError') {
          logger.warn({ attempt, requestId, duration }, 'Mistral API Request Timeout');
          if (attempt < maxAttempts) {
            await this.sleep(attempt * 1000);
            continue;
          }
        }
        
        logger.error({ error, model: this.config.modelName, requestId, duration, attempt }, 'Mistral API extraction failed');
        throw error;
      }
    }

    throw new Error('Mistral API failed after max retries.');
  }
}
