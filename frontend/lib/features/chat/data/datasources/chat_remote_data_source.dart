import 'package:dio/dio.dart';
import '../../domain/entities/chat_models.dart';

class ChatRemoteDataSource {
  final Dio _dio;

  ChatRemoteDataSource(this._dio);

  Future<ChatMessage> askQuestion(String projectId, String question, {String? scope}) async {
    final body = <String, dynamic>{
      'projectId': projectId,
      'question': question,
    };
    if (scope != null) {
      body['scope'] = scope;
    }
    final response = await _dio.post('/ask', data: body);

    final data = response.data['data'] as Map<String, dynamic>;
    
    final metadata = ChatResponseMetadata(
      confidence: (data['confidence'] as num?)?.toDouble() ?? 0.0,
      sources: (data['sources'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      warnings: (data['warnings'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      promptVersion: data['promptVersion']?.toString(),
      modelName: data['modelName']?.toString(),
      modelVersion: data['modelVersion']?.toString(),
    );

    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Temporary ID for frontend
      role: ChatRole.assistant,
      content: data['answer'] ?? '',
      timestamp: DateTime.now(),
      metadata: metadata,
    );
  }
}
