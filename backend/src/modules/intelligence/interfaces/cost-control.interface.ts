import { Types } from 'mongoose';

export enum CostScope {
  USER = 'USER',
  ORGANIZATION = 'ORGANIZATION',
  GLOBAL = 'GLOBAL',
}

export interface ICostController {
  /**
   * Checks if the entity has sufficient budget to proceed.
   * Throws an exception or returns false if budget is exceeded.
   */
  checkLimit(entityId: Types.ObjectId | string, scope: CostScope, estimatedTokens: number): Promise<boolean>;

  /**
   * Records token consumption after an LLM call.
   */
  recordUsage(entityId: Types.ObjectId | string, scope: CostScope, totalTokens: number, promptTokens?: number, completionTokens?: number): Promise<void>;
}
