import 'package:dio/dio.dart';
import '../../domain/entities/document.dart';
import '../../domain/entities/knowledge_record.dart';

class KnowledgeRemoteDataSource {
  final Dio _dio;

  KnowledgeRemoteDataSource(this._dio);

  Future<List<AppDocument>> getDocuments(String? projectId) async {
    final Map<String, dynamic> queryParameters = {};
    if (projectId != null && projectId.isNotEmpty) {
      queryParameters['projectId'] = projectId;
    }

    final response = await _dio.get('/documents', queryParameters: queryParameters);
    final data = response.data['data'] as List;
    return data.map((json) => AppDocument.fromJson(json)).toList();
  }

  Future<AppDocument> getDocumentById(String id) async {
    final response = await _dio.get('/documents/$id');
    return AppDocument.fromJson(response.data['data']);
  }

  Future<List<KnowledgeRecord>> getKnowledgeRecords(String? projectId) async {
    final Map<String, dynamic> queryParameters = {};
    if (projectId != null && projectId.isNotEmpty) {
      queryParameters['projectId'] = projectId;
    }

    final response = await _dio.get('/knowledge', queryParameters: queryParameters);
    final data = response.data['data'] as List;
    return data.map((json) => KnowledgeRecord.fromJson(json)).toList();
  }

  Future<KnowledgeRecord> getKnowledgeRecordById(String id) async {
    final response = await _dio.get('/knowledge/$id');
    return KnowledgeRecord.fromJson(response.data['data']);
  }

  Future<AppDocument> createDocument(String title, String content, String projectId) async {
    final response = await _dio.post('/documents', data: {
      'title': title,
      'content': content,
      'projectId': projectId,
    });
    return AppDocument.fromJson(response.data['data']);
  }
}
