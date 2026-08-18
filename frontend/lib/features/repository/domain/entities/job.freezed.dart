// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

JobStatus _$JobStatusFromJson(Map<String, dynamic> json) {
  return _JobStatus.fromJson(json);
}

/// @nodoc
mixin _$JobStatus {
  String get id => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  double get progress => throw _privateConstructorUsedError;
  DateTime? get queuedAt => throw _privateConstructorUsedError;
  DateTime? get startedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  int? get duration => throw _privateConstructorUsedError;
  int get retries => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  dynamic get result => throw _privateConstructorUsedError;

  /// Serializes this JobStatus to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JobStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JobStatusCopyWith<JobStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JobStatusCopyWith<$Res> {
  factory $JobStatusCopyWith(JobStatus value, $Res Function(JobStatus) then) =
      _$JobStatusCopyWithImpl<$Res, JobStatus>;
  @useResult
  $Res call({
    String id,
    String type,
    String status,
    double progress,
    DateTime? queuedAt,
    DateTime? startedAt,
    DateTime? completedAt,
    int? duration,
    int retries,
    String? error,
    dynamic result,
  });
}

/// @nodoc
class _$JobStatusCopyWithImpl<$Res, $Val extends JobStatus>
    implements $JobStatusCopyWith<$Res> {
  _$JobStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JobStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? status = null,
    Object? progress = null,
    Object? queuedAt = freezed,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? duration = freezed,
    Object? retries = null,
    Object? error = freezed,
    Object? result = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            type:
                null == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as String,
            status:
                null == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as String,
            progress:
                null == progress
                    ? _value.progress
                    : progress // ignore: cast_nullable_to_non_nullable
                        as double,
            queuedAt:
                freezed == queuedAt
                    ? _value.queuedAt
                    : queuedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            startedAt:
                freezed == startedAt
                    ? _value.startedAt
                    : startedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            completedAt:
                freezed == completedAt
                    ? _value.completedAt
                    : completedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            duration:
                freezed == duration
                    ? _value.duration
                    : duration // ignore: cast_nullable_to_non_nullable
                        as int?,
            retries:
                null == retries
                    ? _value.retries
                    : retries // ignore: cast_nullable_to_non_nullable
                        as int,
            error:
                freezed == error
                    ? _value.error
                    : error // ignore: cast_nullable_to_non_nullable
                        as String?,
            result:
                freezed == result
                    ? _value.result
                    : result // ignore: cast_nullable_to_non_nullable
                        as dynamic,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$JobStatusImplCopyWith<$Res>
    implements $JobStatusCopyWith<$Res> {
  factory _$$JobStatusImplCopyWith(
    _$JobStatusImpl value,
    $Res Function(_$JobStatusImpl) then,
  ) = __$$JobStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String type,
    String status,
    double progress,
    DateTime? queuedAt,
    DateTime? startedAt,
    DateTime? completedAt,
    int? duration,
    int retries,
    String? error,
    dynamic result,
  });
}

/// @nodoc
class __$$JobStatusImplCopyWithImpl<$Res>
    extends _$JobStatusCopyWithImpl<$Res, _$JobStatusImpl>
    implements _$$JobStatusImplCopyWith<$Res> {
  __$$JobStatusImplCopyWithImpl(
    _$JobStatusImpl _value,
    $Res Function(_$JobStatusImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JobStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? status = null,
    Object? progress = null,
    Object? queuedAt = freezed,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? duration = freezed,
    Object? retries = null,
    Object? error = freezed,
    Object? result = freezed,
  }) {
    return _then(
      _$JobStatusImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        type:
            null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as String,
        status:
            null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as String,
        progress:
            null == progress
                ? _value.progress
                : progress // ignore: cast_nullable_to_non_nullable
                    as double,
        queuedAt:
            freezed == queuedAt
                ? _value.queuedAt
                : queuedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        startedAt:
            freezed == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        completedAt:
            freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        duration:
            freezed == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                    as int?,
        retries:
            null == retries
                ? _value.retries
                : retries // ignore: cast_nullable_to_non_nullable
                    as int,
        error:
            freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                    as String?,
        result:
            freezed == result
                ? _value.result
                : result // ignore: cast_nullable_to_non_nullable
                    as dynamic,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$JobStatusImpl implements _JobStatus {
  const _$JobStatusImpl({
    required this.id,
    required this.type,
    required this.status,
    this.progress = 0,
    this.queuedAt,
    this.startedAt,
    this.completedAt,
    this.duration,
    this.retries = 0,
    this.error,
    this.result,
  });

  factory _$JobStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$JobStatusImplFromJson(json);

  @override
  final String id;
  @override
  final String type;
  @override
  final String status;
  @override
  @JsonKey()
  final double progress;
  @override
  final DateTime? queuedAt;
  @override
  final DateTime? startedAt;
  @override
  final DateTime? completedAt;
  @override
  final int? duration;
  @override
  @JsonKey()
  final int retries;
  @override
  final String? error;
  @override
  final dynamic result;

  @override
  String toString() {
    return 'JobStatus(id: $id, type: $type, status: $status, progress: $progress, queuedAt: $queuedAt, startedAt: $startedAt, completedAt: $completedAt, duration: $duration, retries: $retries, error: $error, result: $result)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JobStatusImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.queuedAt, queuedAt) ||
                other.queuedAt == queuedAt) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.retries, retries) || other.retries == retries) &&
            (identical(other.error, error) || other.error == error) &&
            const DeepCollectionEquality().equals(other.result, result));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    type,
    status,
    progress,
    queuedAt,
    startedAt,
    completedAt,
    duration,
    retries,
    error,
    const DeepCollectionEquality().hash(result),
  );

  /// Create a copy of JobStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JobStatusImplCopyWith<_$JobStatusImpl> get copyWith =>
      __$$JobStatusImplCopyWithImpl<_$JobStatusImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JobStatusImplToJson(this);
  }
}

abstract class _JobStatus implements JobStatus {
  const factory _JobStatus({
    required final String id,
    required final String type,
    required final String status,
    final double progress,
    final DateTime? queuedAt,
    final DateTime? startedAt,
    final DateTime? completedAt,
    final int? duration,
    final int retries,
    final String? error,
    final dynamic result,
  }) = _$JobStatusImpl;

  factory _JobStatus.fromJson(Map<String, dynamic> json) =
      _$JobStatusImpl.fromJson;

  @override
  String get id;
  @override
  String get type;
  @override
  String get status;
  @override
  double get progress;
  @override
  DateTime? get queuedAt;
  @override
  DateTime? get startedAt;
  @override
  DateTime? get completedAt;
  @override
  int? get duration;
  @override
  int get retries;
  @override
  String? get error;
  @override
  dynamic get result;

  /// Create a copy of JobStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JobStatusImplCopyWith<_$JobStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
