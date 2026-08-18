import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_models.freezed.dart';
part 'profile_models.g.dart';

@freezed
class Session with _$Session {
  const factory Session({
    required String sessionId,
    String? deviceName,
    String? platform,
    String? appVersion,
    String? ipAddress,
    required DateTime lastUsedAt,
    required DateTime createdAt,
  }) = _Session;

  factory Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);
}
