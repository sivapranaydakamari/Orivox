// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppDocumentImpl _$$AppDocumentImplFromJson(Map<String, dynamic> json) =>
    _$AppDocumentImpl(
      id: json['_id'] as String,
      title: json['title'] as String,
      rawContent: json['rawContent'] as String,
      sourceType: json['sourceType'] as String,
      status: json['status'] as String,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$AppDocumentImplToJson(_$AppDocumentImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'rawContent': instance.rawContent,
      'sourceType': instance.sourceType,
      'status': instance.status,
      'metadata': instance.metadata,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
