import { Types } from 'mongoose';
import { IRetrievalEvidence } from '../models/retrieval-evidence.model';

export interface IHybridSearchService {
  /**
   * Performs a combined vector (semantic) and keyword (lexical) search.
   * @param query The natural language query string.
   * @param queryVector The embedded vector of the query.
   * @param projectId The project scope to search within.
   * @param limit The maximum number of results to return.
   */
  search(query: string, queryVector: number[], projectId: Types.ObjectId | string, limit?: number): Promise<IRetrievalEvidence[]>;
}
