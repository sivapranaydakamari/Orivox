import { BaseRepository } from '../../../shared/repository/base.repository';
import { IDocument, DocumentModel } from '../model/document.model';

export class DocumentRepository extends BaseRepository<IDocument> {
  constructor() {
    super(DocumentModel);
  }
}

export const documentRepository = new DocumentRepository();
