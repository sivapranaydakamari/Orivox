import { DocumentSourceType } from '../../document/model/document.model';

export interface IParsedDocument {
  title: string;
  summary: string;
  sourceType: DocumentSourceType;
  author: string;
  content: string;
  changedFiles: string[];
  metadata: Record<string, unknown>;
  references: string[];
}
