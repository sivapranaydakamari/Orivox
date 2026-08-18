// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ParsedSourceImpl _$$ParsedSourceImplFromJson(Map<String, dynamic> json) =>
    _$ParsedSourceImpl(
      sourceType: json['sourceType'] as String,
      repository: json['repository'] as String,
      id: json['id'] as String,
      similarityScore: (json['similarityScore'] as num).toDouble(),
      rawCitation: json['rawCitation'] as String,
    );

Map<String, dynamic> _$$ParsedSourceImplToJson(_$ParsedSourceImpl instance) =>
    <String, dynamic>{
      'sourceType': instance.sourceType,
      'repository': instance.repository,
      'id': instance.id,
      'similarityScore': instance.similarityScore,
      'rawCitation': instance.rawCitation,
    };

_$ChatResponseMetadataImpl _$$ChatResponseMetadataImplFromJson(
  Map<String, dynamic> json,
) => _$ChatResponseMetadataImpl(
  confidence: (json['confidence'] as num).toDouble(),
  sources:
      (json['sources'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  warnings:
      (json['warnings'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  promptVersion: json['promptVersion'] as String?,
  modelName: json['modelName'] as String?,
  modelVersion: json['modelVersion'] as String?,
);

Map<String, dynamic> _$$ChatResponseMetadataImplToJson(
  _$ChatResponseMetadataImpl instance,
) => <String, dynamic>{
  'confidence': instance.confidence,
  'sources': instance.sources,
  'warnings': instance.warnings,
  'promptVersion': instance.promptVersion,
  'modelName': instance.modelName,
  'modelVersion': instance.modelVersion,
};

_$ChatMessageImpl _$$ChatMessageImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageImpl(
      id: json['id'] as String,
      role: $enumDecode(_$ChatRoleEnumMap, json['role']),
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      metadata:
          json['metadata'] == null
              ? null
              : ChatResponseMetadata.fromJson(
                json['metadata'] as Map<String, dynamic>,
              ),
      isError: json['isError'] as bool? ?? false,
    );

Map<String, dynamic> _$$ChatMessageImplToJson(_$ChatMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': _$ChatRoleEnumMap[instance.role]!,
      'content': instance.content,
      'timestamp': instance.timestamp.toIso8601String(),
      'metadata': instance.metadata,
      'isError': instance.isError,
    };

const _$ChatRoleEnumMap = {
  ChatRole.user: 'user',
  ChatRole.assistant: 'assistant',
};

_$ConversationImpl _$$ConversationImplFromJson(Map<String, dynamic> json) =>
    _$ConversationImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      messages:
          (json['messages'] as List<dynamic>?)
              ?.map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ConversationImplToJson(_$ConversationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'messages': instance.messages,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
