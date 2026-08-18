// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JobStatusImpl _$$JobStatusImplFromJson(Map<String, dynamic> json) =>
    _$JobStatusImpl(
      id: json['id'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
      progress: (json['progress'] as num?)?.toDouble() ?? 0,
      queuedAt:
          json['queuedAt'] == null
              ? null
              : DateTime.parse(json['queuedAt'] as String),
      startedAt:
          json['startedAt'] == null
              ? null
              : DateTime.parse(json['startedAt'] as String),
      completedAt:
          json['completedAt'] == null
              ? null
              : DateTime.parse(json['completedAt'] as String),
      duration: (json['duration'] as num?)?.toInt(),
      retries: (json['retries'] as num?)?.toInt() ?? 0,
      error: json['error'] as String?,
      result: json['result'],
    );

Map<String, dynamic> _$$JobStatusImplToJson(_$JobStatusImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'status': instance.status,
      'progress': instance.progress,
      'queuedAt': instance.queuedAt?.toIso8601String(),
      'startedAt': instance.startedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'duration': instance.duration,
      'retries': instance.retries,
      'error': instance.error,
      'result': instance.result,
    };
