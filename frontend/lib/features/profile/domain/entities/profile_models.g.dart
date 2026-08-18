// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SessionImpl _$$SessionImplFromJson(Map<String, dynamic> json) =>
    _$SessionImpl(
      sessionId: json['sessionId'] as String,
      deviceName: json['deviceName'] as String?,
      platform: json['platform'] as String?,
      appVersion: json['appVersion'] as String?,
      ipAddress: json['ipAddress'] as String?,
      lastUsedAt: DateTime.parse(json['lastUsedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$SessionImplToJson(_$SessionImpl instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'deviceName': instance.deviceName,
      'platform': instance.platform,
      'appVersion': instance.appVersion,
      'ipAddress': instance.ipAddress,
      'lastUsedAt': instance.lastUsedAt.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };
