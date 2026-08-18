import 'package:freezed_annotation/freezed_annotation.dart';

part 'worker_metric.freezed.dart';
part 'worker_metric.g.dart';

@freezed
class WorkerMetric with _$WorkerMetric {
  const factory WorkerMetric({
    @JsonKey(name: '_id') required String id,
    required String workerId,
    required String hostname,
    required String jobType,
    required int jobsProcessed,
    required int jobsFailed,
    required double averageProcessingTime,
    required DateTime lastHeartbeat,
    @Default(true) bool isHealthy,
  }) = _WorkerMetric;

  factory WorkerMetric.fromJson(Map<String, dynamic> json) => _$WorkerMetricFromJson(json);
}
