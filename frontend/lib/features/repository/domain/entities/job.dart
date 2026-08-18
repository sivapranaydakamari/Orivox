import 'package:freezed_annotation/freezed_annotation.dart';

part 'job.freezed.dart';
part 'job.g.dart';

@freezed
class JobStatus with _$JobStatus {
  const factory JobStatus({
    required String id,
    required String type,
    required String status,
    @Default(0) double progress,
    DateTime? queuedAt,
    DateTime? startedAt,
    DateTime? completedAt,
    int? duration,
    @Default(0) int retries,
    String? error,
    dynamic result,
  }) = _JobStatus;

  factory JobStatus.fromJson(Map<String, dynamic> json) => _$JobStatusFromJson(json);
}
