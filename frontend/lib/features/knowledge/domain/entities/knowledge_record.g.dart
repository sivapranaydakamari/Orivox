// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knowledge_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KnowledgeRecordImpl _$$KnowledgeRecordImplFromJson(
  Map<String, dynamic> json,
) => _$KnowledgeRecordImpl(
  id: json['_id'] as String,
  title: json['title'] as String,
  summary: json['summary'] as String,
  sourceType: json['sourceType'] as String,
  embeddingStatus: json['embeddingStatus'] as String,
  confidence: json['confidence'],
  engineeringReasoning: json['engineeringReasoning'] as String?,
  technicalDecisions:
      (json['technicalDecisions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  businessContext: json['businessContext'] as String?,
  risks:
      (json['risks'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  breakingChanges:
      (json['breakingChanges'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  dependencies:
      (json['dependencies'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  affectedComponents:
      (json['affectedComponents'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  referencedApis:
      (json['referencedApis'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  author: json['author'] as String?,
  metadata: json['metadata'] as Map<String, dynamic>?,
  documentId: json['documentId'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$KnowledgeRecordImplToJson(
  _$KnowledgeRecordImpl instance,
) => <String, dynamic>{
  '_id': instance.id,
  'title': instance.title,
  'summary': instance.summary,
  'sourceType': instance.sourceType,
  'embeddingStatus': instance.embeddingStatus,
  'confidence': instance.confidence,
  'engineeringReasoning': instance.engineeringReasoning,
  'technicalDecisions': instance.technicalDecisions,
  'businessContext': instance.businessContext,
  'risks': instance.risks,
  'breakingChanges': instance.breakingChanges,
  'dependencies': instance.dependencies,
  'affectedComponents': instance.affectedComponents,
  'referencedApis': instance.referencedApis,
  'tags': instance.tags,
  'author': instance.author,
  'metadata': instance.metadata,
  'documentId': instance.documentId,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
