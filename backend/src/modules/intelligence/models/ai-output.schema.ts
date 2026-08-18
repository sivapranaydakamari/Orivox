export interface IExtractionResult {
  summary: string;
  technicalDecisions: string[];
  businessContext: string;
  risks: string[];
  breakingChanges: string[];
  dependencies: string[];
  componentsAffected: string[];
  apisMentioned: string[];
  confidenceScore: number;
}
