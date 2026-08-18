// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'knowledge_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$KnowledgeStats {
  int get totalDocuments => throw _privateConstructorUsedError;
  int get totalRecords => throw _privateConstructorUsedError;
  int get repositoryCount => throw _privateConstructorUsedError;
  int get processingCount => throw _privateConstructorUsedError;
  int get failedCount => throw _privateConstructorUsedError;
  DateTime? get lastIndexed => throw _privateConstructorUsedError;

  /// Create a copy of KnowledgeStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KnowledgeStatsCopyWith<KnowledgeStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KnowledgeStatsCopyWith<$Res> {
  factory $KnowledgeStatsCopyWith(
    KnowledgeStats value,
    $Res Function(KnowledgeStats) then,
  ) = _$KnowledgeStatsCopyWithImpl<$Res, KnowledgeStats>;
  @useResult
  $Res call({
    int totalDocuments,
    int totalRecords,
    int repositoryCount,
    int processingCount,
    int failedCount,
    DateTime? lastIndexed,
  });
}

/// @nodoc
class _$KnowledgeStatsCopyWithImpl<$Res, $Val extends KnowledgeStats>
    implements $KnowledgeStatsCopyWith<$Res> {
  _$KnowledgeStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KnowledgeStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalDocuments = null,
    Object? totalRecords = null,
    Object? repositoryCount = null,
    Object? processingCount = null,
    Object? failedCount = null,
    Object? lastIndexed = freezed,
  }) {
    return _then(
      _value.copyWith(
            totalDocuments:
                null == totalDocuments
                    ? _value.totalDocuments
                    : totalDocuments // ignore: cast_nullable_to_non_nullable
                        as int,
            totalRecords:
                null == totalRecords
                    ? _value.totalRecords
                    : totalRecords // ignore: cast_nullable_to_non_nullable
                        as int,
            repositoryCount:
                null == repositoryCount
                    ? _value.repositoryCount
                    : repositoryCount // ignore: cast_nullable_to_non_nullable
                        as int,
            processingCount:
                null == processingCount
                    ? _value.processingCount
                    : processingCount // ignore: cast_nullable_to_non_nullable
                        as int,
            failedCount:
                null == failedCount
                    ? _value.failedCount
                    : failedCount // ignore: cast_nullable_to_non_nullable
                        as int,
            lastIndexed:
                freezed == lastIndexed
                    ? _value.lastIndexed
                    : lastIndexed // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$KnowledgeStatsImplCopyWith<$Res>
    implements $KnowledgeStatsCopyWith<$Res> {
  factory _$$KnowledgeStatsImplCopyWith(
    _$KnowledgeStatsImpl value,
    $Res Function(_$KnowledgeStatsImpl) then,
  ) = __$$KnowledgeStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalDocuments,
    int totalRecords,
    int repositoryCount,
    int processingCount,
    int failedCount,
    DateTime? lastIndexed,
  });
}

/// @nodoc
class __$$KnowledgeStatsImplCopyWithImpl<$Res>
    extends _$KnowledgeStatsCopyWithImpl<$Res, _$KnowledgeStatsImpl>
    implements _$$KnowledgeStatsImplCopyWith<$Res> {
  __$$KnowledgeStatsImplCopyWithImpl(
    _$KnowledgeStatsImpl _value,
    $Res Function(_$KnowledgeStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of KnowledgeStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalDocuments = null,
    Object? totalRecords = null,
    Object? repositoryCount = null,
    Object? processingCount = null,
    Object? failedCount = null,
    Object? lastIndexed = freezed,
  }) {
    return _then(
      _$KnowledgeStatsImpl(
        totalDocuments:
            null == totalDocuments
                ? _value.totalDocuments
                : totalDocuments // ignore: cast_nullable_to_non_nullable
                    as int,
        totalRecords:
            null == totalRecords
                ? _value.totalRecords
                : totalRecords // ignore: cast_nullable_to_non_nullable
                    as int,
        repositoryCount:
            null == repositoryCount
                ? _value.repositoryCount
                : repositoryCount // ignore: cast_nullable_to_non_nullable
                    as int,
        processingCount:
            null == processingCount
                ? _value.processingCount
                : processingCount // ignore: cast_nullable_to_non_nullable
                    as int,
        failedCount:
            null == failedCount
                ? _value.failedCount
                : failedCount // ignore: cast_nullable_to_non_nullable
                    as int,
        lastIndexed:
            freezed == lastIndexed
                ? _value.lastIndexed
                : lastIndexed // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc

class _$KnowledgeStatsImpl implements _KnowledgeStats {
  const _$KnowledgeStatsImpl({
    this.totalDocuments = 0,
    this.totalRecords = 0,
    this.repositoryCount = 0,
    this.processingCount = 0,
    this.failedCount = 0,
    this.lastIndexed,
  });

  @override
  @JsonKey()
  final int totalDocuments;
  @override
  @JsonKey()
  final int totalRecords;
  @override
  @JsonKey()
  final int repositoryCount;
  @override
  @JsonKey()
  final int processingCount;
  @override
  @JsonKey()
  final int failedCount;
  @override
  final DateTime? lastIndexed;

  @override
  String toString() {
    return 'KnowledgeStats(totalDocuments: $totalDocuments, totalRecords: $totalRecords, repositoryCount: $repositoryCount, processingCount: $processingCount, failedCount: $failedCount, lastIndexed: $lastIndexed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KnowledgeStatsImpl &&
            (identical(other.totalDocuments, totalDocuments) ||
                other.totalDocuments == totalDocuments) &&
            (identical(other.totalRecords, totalRecords) ||
                other.totalRecords == totalRecords) &&
            (identical(other.repositoryCount, repositoryCount) ||
                other.repositoryCount == repositoryCount) &&
            (identical(other.processingCount, processingCount) ||
                other.processingCount == processingCount) &&
            (identical(other.failedCount, failedCount) ||
                other.failedCount == failedCount) &&
            (identical(other.lastIndexed, lastIndexed) ||
                other.lastIndexed == lastIndexed));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalDocuments,
    totalRecords,
    repositoryCount,
    processingCount,
    failedCount,
    lastIndexed,
  );

  /// Create a copy of KnowledgeStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KnowledgeStatsImplCopyWith<_$KnowledgeStatsImpl> get copyWith =>
      __$$KnowledgeStatsImplCopyWithImpl<_$KnowledgeStatsImpl>(
        this,
        _$identity,
      );
}

abstract class _KnowledgeStats implements KnowledgeStats {
  const factory _KnowledgeStats({
    final int totalDocuments,
    final int totalRecords,
    final int repositoryCount,
    final int processingCount,
    final int failedCount,
    final DateTime? lastIndexed,
  }) = _$KnowledgeStatsImpl;

  @override
  int get totalDocuments;
  @override
  int get totalRecords;
  @override
  int get repositoryCount;
  @override
  int get processingCount;
  @override
  int get failedCount;
  @override
  DateTime? get lastIndexed;

  /// Create a copy of KnowledgeStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KnowledgeStatsImplCopyWith<_$KnowledgeStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
