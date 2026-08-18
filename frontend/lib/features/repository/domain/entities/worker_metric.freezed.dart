// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'worker_metric.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WorkerMetric _$WorkerMetricFromJson(Map<String, dynamic> json) {
  return _WorkerMetric.fromJson(json);
}

/// @nodoc
mixin _$WorkerMetric {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get workerId => throw _privateConstructorUsedError;
  String get hostname => throw _privateConstructorUsedError;
  String get jobType => throw _privateConstructorUsedError;
  int get jobsProcessed => throw _privateConstructorUsedError;
  int get jobsFailed => throw _privateConstructorUsedError;
  double get averageProcessingTime => throw _privateConstructorUsedError;
  DateTime get lastHeartbeat => throw _privateConstructorUsedError;
  bool get isHealthy => throw _privateConstructorUsedError;

  /// Serializes this WorkerMetric to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkerMetric
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkerMetricCopyWith<WorkerMetric> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkerMetricCopyWith<$Res> {
  factory $WorkerMetricCopyWith(
    WorkerMetric value,
    $Res Function(WorkerMetric) then,
  ) = _$WorkerMetricCopyWithImpl<$Res, WorkerMetric>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String workerId,
    String hostname,
    String jobType,
    int jobsProcessed,
    int jobsFailed,
    double averageProcessingTime,
    DateTime lastHeartbeat,
    bool isHealthy,
  });
}

/// @nodoc
class _$WorkerMetricCopyWithImpl<$Res, $Val extends WorkerMetric>
    implements $WorkerMetricCopyWith<$Res> {
  _$WorkerMetricCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkerMetric
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workerId = null,
    Object? hostname = null,
    Object? jobType = null,
    Object? jobsProcessed = null,
    Object? jobsFailed = null,
    Object? averageProcessingTime = null,
    Object? lastHeartbeat = null,
    Object? isHealthy = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            workerId:
                null == workerId
                    ? _value.workerId
                    : workerId // ignore: cast_nullable_to_non_nullable
                        as String,
            hostname:
                null == hostname
                    ? _value.hostname
                    : hostname // ignore: cast_nullable_to_non_nullable
                        as String,
            jobType:
                null == jobType
                    ? _value.jobType
                    : jobType // ignore: cast_nullable_to_non_nullable
                        as String,
            jobsProcessed:
                null == jobsProcessed
                    ? _value.jobsProcessed
                    : jobsProcessed // ignore: cast_nullable_to_non_nullable
                        as int,
            jobsFailed:
                null == jobsFailed
                    ? _value.jobsFailed
                    : jobsFailed // ignore: cast_nullable_to_non_nullable
                        as int,
            averageProcessingTime:
                null == averageProcessingTime
                    ? _value.averageProcessingTime
                    : averageProcessingTime // ignore: cast_nullable_to_non_nullable
                        as double,
            lastHeartbeat:
                null == lastHeartbeat
                    ? _value.lastHeartbeat
                    : lastHeartbeat // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            isHealthy:
                null == isHealthy
                    ? _value.isHealthy
                    : isHealthy // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WorkerMetricImplCopyWith<$Res>
    implements $WorkerMetricCopyWith<$Res> {
  factory _$$WorkerMetricImplCopyWith(
    _$WorkerMetricImpl value,
    $Res Function(_$WorkerMetricImpl) then,
  ) = __$$WorkerMetricImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String workerId,
    String hostname,
    String jobType,
    int jobsProcessed,
    int jobsFailed,
    double averageProcessingTime,
    DateTime lastHeartbeat,
    bool isHealthy,
  });
}

/// @nodoc
class __$$WorkerMetricImplCopyWithImpl<$Res>
    extends _$WorkerMetricCopyWithImpl<$Res, _$WorkerMetricImpl>
    implements _$$WorkerMetricImplCopyWith<$Res> {
  __$$WorkerMetricImplCopyWithImpl(
    _$WorkerMetricImpl _value,
    $Res Function(_$WorkerMetricImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WorkerMetric
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? workerId = null,
    Object? hostname = null,
    Object? jobType = null,
    Object? jobsProcessed = null,
    Object? jobsFailed = null,
    Object? averageProcessingTime = null,
    Object? lastHeartbeat = null,
    Object? isHealthy = null,
  }) {
    return _then(
      _$WorkerMetricImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        workerId:
            null == workerId
                ? _value.workerId
                : workerId // ignore: cast_nullable_to_non_nullable
                    as String,
        hostname:
            null == hostname
                ? _value.hostname
                : hostname // ignore: cast_nullable_to_non_nullable
                    as String,
        jobType:
            null == jobType
                ? _value.jobType
                : jobType // ignore: cast_nullable_to_non_nullable
                    as String,
        jobsProcessed:
            null == jobsProcessed
                ? _value.jobsProcessed
                : jobsProcessed // ignore: cast_nullable_to_non_nullable
                    as int,
        jobsFailed:
            null == jobsFailed
                ? _value.jobsFailed
                : jobsFailed // ignore: cast_nullable_to_non_nullable
                    as int,
        averageProcessingTime:
            null == averageProcessingTime
                ? _value.averageProcessingTime
                : averageProcessingTime // ignore: cast_nullable_to_non_nullable
                    as double,
        lastHeartbeat:
            null == lastHeartbeat
                ? _value.lastHeartbeat
                : lastHeartbeat // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        isHealthy:
            null == isHealthy
                ? _value.isHealthy
                : isHealthy // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkerMetricImpl implements _WorkerMetric {
  const _$WorkerMetricImpl({
    @JsonKey(name: '_id') required this.id,
    required this.workerId,
    required this.hostname,
    required this.jobType,
    required this.jobsProcessed,
    required this.jobsFailed,
    required this.averageProcessingTime,
    required this.lastHeartbeat,
    this.isHealthy = true,
  });

  factory _$WorkerMetricImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkerMetricImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String workerId;
  @override
  final String hostname;
  @override
  final String jobType;
  @override
  final int jobsProcessed;
  @override
  final int jobsFailed;
  @override
  final double averageProcessingTime;
  @override
  final DateTime lastHeartbeat;
  @override
  @JsonKey()
  final bool isHealthy;

  @override
  String toString() {
    return 'WorkerMetric(id: $id, workerId: $workerId, hostname: $hostname, jobType: $jobType, jobsProcessed: $jobsProcessed, jobsFailed: $jobsFailed, averageProcessingTime: $averageProcessingTime, lastHeartbeat: $lastHeartbeat, isHealthy: $isHealthy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkerMetricImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.workerId, workerId) ||
                other.workerId == workerId) &&
            (identical(other.hostname, hostname) ||
                other.hostname == hostname) &&
            (identical(other.jobType, jobType) || other.jobType == jobType) &&
            (identical(other.jobsProcessed, jobsProcessed) ||
                other.jobsProcessed == jobsProcessed) &&
            (identical(other.jobsFailed, jobsFailed) ||
                other.jobsFailed == jobsFailed) &&
            (identical(other.averageProcessingTime, averageProcessingTime) ||
                other.averageProcessingTime == averageProcessingTime) &&
            (identical(other.lastHeartbeat, lastHeartbeat) ||
                other.lastHeartbeat == lastHeartbeat) &&
            (identical(other.isHealthy, isHealthy) ||
                other.isHealthy == isHealthy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    workerId,
    hostname,
    jobType,
    jobsProcessed,
    jobsFailed,
    averageProcessingTime,
    lastHeartbeat,
    isHealthy,
  );

  /// Create a copy of WorkerMetric
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkerMetricImplCopyWith<_$WorkerMetricImpl> get copyWith =>
      __$$WorkerMetricImplCopyWithImpl<_$WorkerMetricImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkerMetricImplToJson(this);
  }
}

abstract class _WorkerMetric implements WorkerMetric {
  const factory _WorkerMetric({
    @JsonKey(name: '_id') required final String id,
    required final String workerId,
    required final String hostname,
    required final String jobType,
    required final int jobsProcessed,
    required final int jobsFailed,
    required final double averageProcessingTime,
    required final DateTime lastHeartbeat,
    final bool isHealthy,
  }) = _$WorkerMetricImpl;

  factory _WorkerMetric.fromJson(Map<String, dynamic> json) =
      _$WorkerMetricImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get workerId;
  @override
  String get hostname;
  @override
  String get jobType;
  @override
  int get jobsProcessed;
  @override
  int get jobsFailed;
  @override
  double get averageProcessingTime;
  @override
  DateTime get lastHeartbeat;
  @override
  bool get isHealthy;

  /// Create a copy of WorkerMetric
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkerMetricImplCopyWith<_$WorkerMetricImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
