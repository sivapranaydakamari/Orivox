import '../../domain/entities/chat_models.dart';
import '../datasources/chat_local_data_source.dart';
import '../datasources/chat_remote_data_source.dart';

class ChatRepositoryImpl {
  final ChatRemoteDataSource _remoteDataSource;
  final ChatLocalDataSource _localDataSource;

  ChatRepositoryImpl(this._remoteDataSource, this._localDataSource);

  Future<ChatMessage> askQuestion(String projectId, String question, {String? scope}) {
    return _remoteDataSource.askQuestion(projectId, question, scope: scope);
  }

  Future<List<Conversation>> getConversations() {
    return _localDataSource.getConversations();
  }

  Future<void> saveConversations(List<Conversation> conversations) {
    return _localDataSource.saveConversations(conversations);
  }

  Future<void> clearConversations() {
    return _localDataSource.clearConversations();
  }
}
