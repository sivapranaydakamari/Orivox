import { IRetrievalEvidence } from '../models/retrieval-evidence.model';

export interface IRerankerService {
  /**
   * Re-scores and re-orders a list of initially retrieved evidence based on a 
   * deeper semantic understanding of the query and context.
   * @param query The original query string.
   * @param evidence The list of evidence to re-rank.
   */
  rerank(query: string, evidence: IRetrievalEvidence[]): Promise<IRetrievalEvidence[]>;
}
