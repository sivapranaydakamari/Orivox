export interface IAnswerResponse {
  answer: string;
  citations: string[];
  confidence: number;
  sources: string[];
  warnings?: string[];
  promptVersion?: string;
  modelName?: string;
  modelVersion?: string;
}
