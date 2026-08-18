import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../data/datasources/chat_remote_data_source.dart';
import '../../data/datasources/chat_local_data_source.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/entities/chat_models.dart';

final chatRemoteDataSourceProvider = Provider<ChatRemoteDataSource>((ref) {
  return ChatRemoteDataSource(ref.watch(dioProvider));
});

final chatLocalDataSourceProvider = Provider<ChatLocalDataSource>((ref) {
  return ChatLocalDataSource(ref.watch(secureStorageProvider));
});

final chatRepositoryProvider = Provider<ChatRepositoryImpl>((ref) {
  return ChatRepositoryImpl(
    ref.watch(chatRemoteDataSourceProvider),
    ref.watch(chatLocalDataSourceProvider),
  );
});

class ConversationsNotifier extends StateNotifier<AsyncValue<List<Conversation>>> {
  final ChatRepositoryImpl _repository;

  ConversationsNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    try {
      final conversations = await _repository.getConversations();
      // Sort by updatedAt descending
      conversations.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      state = AsyncValue.data(conversations);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<Conversation> createConversation(String title) async {
    final newConv = Conversation(
      id: const Uuid().v4(),
      title: title,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final current = state.value ?? [];
    final updated = [newConv, ...current];
    state = AsyncValue.data(updated);
    await _repository.saveConversations(updated);
    return newConv;
  }

  Future<void> updateConversation(Conversation conversation) async {
    final current = state.value ?? [];
    final updated = current.map((c) => c.id == conversation.id ? conversation : c).toList();
    updated.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    state = AsyncValue.data(updated);
    await _repository.saveConversations(updated);
  }

  Future<void> renameConversation(String id, String newTitle) async {
    final current = state.value ?? [];
    final index = current.indexWhere((c) => c.id == id);
    if (index != -1) {
      final updatedConv = current[index].copyWith(
        title: newTitle,
        updatedAt: DateTime.now(),
      );
      await updateConversation(updatedConv);
    }
  }

  Future<void> deleteConversation(String id) async {
    final current = state.value ?? [];
    final updated = current.where((c) => c.id != id).toList();
    state = AsyncValue.data(updated);
    await _repository.saveConversations(updated);
  }

  Future<void> clearAll() async {
    state = const AsyncValue.data([]);
    await _repository.clearConversations();
  }
}

final conversationsProvider = StateNotifierProvider<ConversationsNotifier, AsyncValue<List<Conversation>>>((ref) {
  return ConversationsNotifier(ref.watch(chatRepositoryProvider));
});

// A provider that handles an active chat session.
class ChatControllerNotifier extends StateNotifier<AsyncValue<Conversation?>> {
  final ChatRepositoryImpl _repository;
  final ConversationsNotifier _conversationsNotifier;
  final String _projectId;

  ChatControllerNotifier(this._repository, this._conversationsNotifier, this._projectId, Conversation? initialConv) 
      : super(AsyncValue.data(initialConv));

  Future<void> askQuestion(String question) async {
    if (!mounted) return;
    // 1. Get or create conversation
    Conversation conv = state.value ?? await _conversationsNotifier.createConversation(question.length > 30 ? '${question.substring(0, 30)}...' : question);
    
    // 2. Add user message
    final userMsg = ChatMessage(
      id: const Uuid().v4(),
      role: ChatRole.user,
      content: question,
      timestamp: DateTime.now(),
    );
    
    conv = conv.copyWith(
      messages: [...conv.messages, userMsg],
      updatedAt: DateTime.now(),
    );
    
    if (mounted) {
      state = AsyncValue.data(conv);
    }
    await _conversationsNotifier.updateConversation(conv);

    // 3. Make backend call
    try {
      final responseMsg = await _repository.askQuestion(_projectId, question);
      
      // 4. Update with assistant message
      conv = conv.copyWith(
        messages: [...conv.messages, responseMsg],
        updatedAt: DateTime.now(),
      );
      
      if (mounted) {
        state = AsyncValue.data(conv);
      }
      await _conversationsNotifier.updateConversation(conv);
    } catch (e) {
      // 4b. Add error message
      final errorMsg = ChatMessage(
        id: const Uuid().v4(),
        role: ChatRole.assistant,
        content: 'Failed to generate answer: $e',
        timestamp: DateTime.now(),
        isError: true,
      );
      conv = conv.copyWith(
        messages: [...conv.messages, errorMsg],
        updatedAt: DateTime.now(),
      );
      if (mounted) {
        state = AsyncValue.data(conv);
      }
      await _conversationsNotifier.updateConversation(conv);
    }
  }
}

final activeChatProvider = StateNotifierProvider.family<ChatControllerNotifier, AsyncValue<Conversation?>, String>((ref, arg) {
  // arg is "projectId:conversationId" OR "projectId"
  final parts = arg.split(':');
  final projectId = parts[0];
  final conversationId = parts.length > 1 ? parts[1] : null;
  
  final convs = ref.read(conversationsProvider).value ?? [];
  final initialConv = conversationId != null ? convs.where((c) => c.id == conversationId).firstOrNull : null;

  return ChatControllerNotifier(
    ref.watch(chatRepositoryProvider),
    ref.watch(conversationsProvider.notifier),
    projectId,
    initialConv,
  );
});
