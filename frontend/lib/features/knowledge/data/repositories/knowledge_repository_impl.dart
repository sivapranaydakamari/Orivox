import '../../domain/entities/document.dart';
import '../../domain/entities/knowledge_record.dart';
import '../datasources/knowledge_remote_data_source.dart';

class KnowledgeRepositoryImpl {
  final KnowledgeRemoteDataSource _remoteDataSource;

  KnowledgeRepositoryImpl(this._remoteDataSource);

  Future<List<AppDocument>> getDocuments(String? projectId) => _remoteDataSource.getDocuments(projectId);

  Future<AppDocument> getDocumentById(String id) => _remoteDataSource.getDocumentById(id);

  Future<List<KnowledgeRecord>> getKnowledgeRecords(String? projectId) => _remoteDataSource.getKnowledgeRecords(projectId);

  Future<KnowledgeRecord> getKnowledgeRecordById(String id) => _remoteDataSource.getKnowledgeRecordById(id);

  Future<AppDocument> createDocument(String title, String content, String projectId) =>
      _remoteDataSource.createDocument(title, content, projectId);
}
