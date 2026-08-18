export interface IQueryExpansionService {
  /**
   * Expands the user's original query into multiple variations (e.g., synonyms, 
   * domain-specific terminology) to improve retrieval recall.
   * @param originalQuery The raw query from the user.
   * @returns An array of query strings (including the original).
   */
  expand(originalQuery: string): Promise<string[]>;
}
