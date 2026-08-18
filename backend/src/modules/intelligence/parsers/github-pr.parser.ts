import { DocumentSourceType, IDocument } from '../../document/model/document.model';
import { IDocumentParser } from '../interfaces/document-parser.interface';
import { IParsedDocument } from '../models/parsed-document.model';

export class GitHubPrParser implements IDocumentParser {
  supports(sourceType: DocumentSourceType): boolean {
    return sourceType === DocumentSourceType.GITHUB;
  }

  parse(document: IDocument): IParsedDocument {
    // In a real scenario with full PR data, you would parse the rawContent 
    // or metadata for specific fields like comments or changed files.
    
    const meta = document.metadata || {};

    return {
      title: document.title,
      summary: '', // To be filled by AI if needed
      sourceType: DocumentSourceType.GITHUB,
      author: (meta.author as string) || 'Unknown',
      content: document.rawContent,
      changedFiles: [], // Would extract from GitHub PR files API
      metadata: {
        prNumber: meta.prNumber,
        state: meta.state,
        url: meta.url,
        createdAt: document.createdAt,
      },
      references: [], // Extract `#123` issue references from content
    };
  }
}
