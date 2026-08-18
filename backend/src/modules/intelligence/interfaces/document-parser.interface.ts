import { DocumentSourceType, IDocument } from '../../document/model/document.model';
import { IParsedDocument } from '../models/parsed-document.model';

export interface IDocumentParser {
  /**
   * Identifies whether this parser supports the given document type.
   */
  supports(sourceType: DocumentSourceType): boolean;

  /**
   * Converts a raw MongoDB Document into a normalized ParsedDocument.
   */
  parse(document: IDocument): IParsedDocument;
}
