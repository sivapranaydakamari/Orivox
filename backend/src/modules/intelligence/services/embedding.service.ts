import { Types } from 'mongoose';
import { KnowledgeRecord, EmbeddingStatus } from '../../knowledge/model/knowledgeRecord.model';
import { EmbeddingClient } from '../clients/embedding.client';
import { embeddingBuilder } from '../builders/embedding.builder';
import { embeddingValidator } from '../validators/embedding.validator';
import { logger } from '../../../config/logger';

export class EmbeddingService {
  constructor(private readonly client: EmbeddingClient) {}

  /**
   * Orchestrates the embedding process for a KnowledgeRecord.
   */
  async embedKnowledgeRecord(recordId: string | Types.ObjectId): Promise<void> {
    logger.info({ recordId }, 'EmbeddingService: Starting embedding process');

    // 1. Lock state to EMBEDDING atomically
    const record = await KnowledgeRecord.findOneAndUpdate(
      { 
        _id: recordId, 
        embeddingStatus: { $in: [EmbeddingStatus.PENDING, EmbeddingStatus.FAILED] } 
      },
      { $set: { embeddingStatus: EmbeddingStatus.EMBEDDING } },
      { new: true }
    );

    if (!record) {
      logger.warn({ recordId }, 'KnowledgeRecord is not PENDING or FAILED, or another worker is already processing it. Skipping.');
      return;
    }

    try {

      // 2. Build Semantic Input
      const semanticText = embeddingBuilder.buildInputString(record);

      // 3. Request Vector from API
      const vector = await this.client.generateEmbedding(semanticText);

      // 4. Validate Vector (ensure 1024 dimensions, no NaNs)
      embeddingValidator.validate(vector, 1024);

      // 5. Update MongoDB
      record.embedding = vector;
      record.embeddingStatus = EmbeddingStatus.EMBEDDED;
      record.embeddingModel = 'mistral-embed';
      record.embeddingVersion = 1;
      record.embeddingCreatedAt = new Date();
      await record.save();

      logger.info({ recordId }, 'EmbeddingService: Successfully embedded KnowledgeRecord');
    } catch (error) {
      logger.error({ error, recordId }, 'EmbeddingService: Embedding failed');

      // Revert/Mark as Failed
      record.embeddingStatus = EmbeddingStatus.FAILED;
      await record.save();

      throw error;
    }
  }
}
