import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_models.freezed.dart';
part 'chat_models.g.dart';

enum ChatRole {
  user,
  assistant,
}

@freezed
class ParsedSource with _$ParsedSource {
  const factory ParsedSource({
    required String sourceType,
    required String repository,
    required String id,
    required double similarityScore,
    required String rawCitation,
  }) = _ParsedSource;

  factory ParsedSource.fromJson(Map<String, dynamic> json) => _$ParsedSourceFromJson(json);
}

@freezed
class ChatResponseMetadata with _$ChatResponseMetadata {
  const factory ChatResponseMetadata({
    required double confidence,
    @Default([]) List<String> sources, // Raw string sources from backend
    @Default([]) List<String> warnings,
    String? promptVersion,
    String? modelName,
    String? modelVersion,
  }) = _ChatResponseMetadata;

  factory ChatResponseMetadata.fromJson(Map<String, dynamic> json) => _$ChatResponseMetadataFromJson(json);
}

@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required ChatRole role,
    required String content,
    required DateTime timestamp,
    ChatResponseMetadata? metadata,
    @Default(false) bool isError,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
}

@freezed
class Conversation with _$Conversation {
  const factory Conversation({
    required String id,
    required String title,
    @Default([]) List<ChatMessage> messages,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Conversation;

  factory Conversation.fromJson(Map<String, dynamic> json) => _$ConversationFromJson(json);
}
