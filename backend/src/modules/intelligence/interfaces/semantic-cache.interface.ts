import { IAnswerResponse } from '../models/answer-response.model';
import { Types } from 'mongoose';

export interface ISemanticCacheOptions {
  expirationSeconds?: number;
}

export interface ISemanticCache {
  /**
   * Retrieves a cached answer if a semantically equivalent query has been asked recently.
   * @param query The user's question.
   * @param organizationId The organization scope to ensure tenant isolation.
   * @param projectId The project scope to ensure tenant isolation.
   */
  get(query: string, organizationId: Types.ObjectId | string, projectId: Types.ObjectId | string): Promise<IAnswerResponse | null>;

  /**
   * Caches an answer for a given query.
   * @param query The user's question.
   * @param answer The generated response.
   * @param organizationId The organization scope.
   * @param projectId The project scope.
   * @param options Optional configuration for caching (e.g., TTL).
   */
  set(query: string, answer: IAnswerResponse, organizationId: Types.ObjectId | string, projectId: Types.ObjectId | string, options?: ISemanticCacheOptions): Promise<void>;
}
