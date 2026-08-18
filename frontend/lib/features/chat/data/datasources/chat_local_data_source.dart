import 'dart:convert';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/chat_models.dart';

class ChatLocalDataSource {
  final SecureStorageService _secureStorageService;
  static const String _storageKey = 'conversations_history';

  ChatLocalDataSource(this._secureStorageService);

  Future<List<Conversation>> getConversations() async {
    final dataString = await _secureStorageService.read(_storageKey);
    if (dataString == null || dataString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> jsonList = jsonDecode(dataString);
      return jsonList.map((json) => Conversation.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveConversations(List<Conversation> conversations) async {
    final jsonList = conversations.map((c) => c.toJson()).toList();
    final dataString = jsonEncode(jsonList);
    await _secureStorageService.write(_storageKey, dataString);
  }

  Future<void> clearConversations() async {
    await _secureStorageService.delete(_storageKey);
  }
}
