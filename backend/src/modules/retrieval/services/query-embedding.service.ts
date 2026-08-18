import { EmbeddingClient } from '../../intelligence/clients/embedding.client';
import { embeddingValidator } from '../../intelligence/validators/embedding.validator';
import { logger } from '../../../config/logger';

export class QueryEmbeddingService {
  constructor(private readonly embeddingClient: EmbeddingClient) {}

  /**
   * Accepts a natural language query, validates it, and generates a vector embedding.
   */
  async generateQueryVector(query: string): Promise<number[]> {
    logger.info('QueryEmbeddingService: Generating vector for query');
    
    this.validateQuery(query);

    try {
      const vector = await this.embeddingClient.generateEmbedding(query);
      
      // We expect Mistral Embed to return exactly 1024 dimensions.
      embeddingValidator.validate(vector, 1024);
      
      return vector;
    } catch (error) {
      logger.error({ error }, 'QueryEmbeddingService: Failed to generate query embedding');
      throw new Error(`Failed to embed query: ${(error as Error).message}`);
    }
  }

  /**
   * Validates the natural language query constraints before passing to Mistral.
   */
  private validateQuery(query: string): void {
    if (!query || query.trim().length === 0) {
      throw new Error('QueryValidationError: Query cannot be empty.');
    }

    if (query.length < 3) {
      throw new Error('QueryValidationError: Query is too short (minimum 3 characters).');
    }

    // Protect against massive context dumps designed to exhaust limits
    if (query.length > 2000) {
      throw new Error('QueryValidationError: Query exceeds maximum allowed length of 2000 characters.');
    }
  }
}
