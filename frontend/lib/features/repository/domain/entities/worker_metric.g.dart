// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker_metric.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkerMetricImpl _$$WorkerMetricImplFromJson(Map<String, dynamic> json) =>
    _$WorkerMetricImpl(
      id: json['_id'] as String,
      workerId: json['workerId'] as String,
      hostname: json['hostname'] as String,
      jobType: json['jobType'] as String,
      jobsProcessed: (json['jobsProcessed'] as num).toInt(),
      jobsFailed: (json['jobsFailed'] as num).toInt(),
      averageProcessingTime: (json['averageProcessingTime'] as num).toDouble(),
      lastHeartbeat: DateTime.parse(json['lastHeartbeat'] as String),
      isHealthy: json['isHealthy'] as bool? ?? true,
    );

Map<String, dynamic> _$$WorkerMetricImplToJson(_$WorkerMetricImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'workerId': instance.workerId,
      'hostname': instance.hostname,
      'jobType': instance.jobType,
      'jobsProcessed': instance.jobsProcessed,
      'jobsFailed': instance.jobsFailed,
      'averageProcessingTime': instance.averageProcessingTime,
      'lastHeartbeat': instance.lastHeartbeat.toIso8601String(),
      'isHealthy': instance.isHealthy,
    };
