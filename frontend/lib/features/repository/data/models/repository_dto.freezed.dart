// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'repository_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SourceConfigurationDto _$SourceConfigurationDtoFromJson(
  Map<String, dynamic> json,
) {
  return _SourceConfigurationDto.fromJson(json);
}

/// @nodoc
mixin _$SourceConfigurationDto {
  bool get code => throw _privateConstructorUsedError;
  bool get docs => throw _privateConstructorUsedError;
  bool get prs => throw _privateConstructorUsedError;

  /// Serializes this SourceConfigurationDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SourceConfigurationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SourceConfigurationDtoCopyWith<SourceConfigurationDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SourceConfigurationDtoCopyWith<$Res> {
  factory $SourceConfigurationDtoCopyWith(
    SourceConfigurationDto value,
    $Res Function(SourceConfigurationDto) then,
  ) = _$SourceConfigurationDtoCopyWithImpl<$Res, SourceConfigurationDto>;
  @useResult
  $Res call({bool code, bool docs, bool prs});
}

/// @nodoc
class _$SourceConfigurationDtoCopyWithImpl<
  $Res,
  $Val extends SourceConfigurationDto
>
    implements $SourceConfigurationDtoCopyWith<$Res> {
  _$SourceConfigurationDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SourceConfigurationDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? code = null, Object? docs = null, Object? prs = null}) {
    return _then(
      _value.copyWith(
            code:
                null == code
                    ? _value.code
                    : code // ignore: cast_nullable_to_non_nullable
                        as bool,
            docs:
                null == docs
                    ? _value.docs
                    : docs // ignore: cast_nullable_to_non_nullable
                        as bool,
            prs:
                null == prs
                    ? _value.prs
                    : prs // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SourceConfigurationDtoImplCopyWith<$Res>
    implements $SourceConfigurationDtoCopyWith<$Res> {
  factory _$$SourceConfigurationDtoImplCopyWith(
    _$SourceConfigurationDtoImpl value,
    $Res Function(_$SourceConfigurationDtoImpl) then,
  ) = __$$SourceConfigurationDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool code, bool docs, bool prs});
}

/// @nodoc
class __$$SourceConfigurationDtoImplCopyWithImpl<$Res>
    extends
        _$SourceConfigurationDtoCopyWithImpl<$Res, _$SourceConfigurationDtoImpl>
    implements _$$SourceConfigurationDtoImplCopyWith<$Res> {
  __$$SourceConfigurationDtoImplCopyWithImpl(
    _$SourceConfigurationDtoImpl _value,
    $Res Function(_$SourceConfigurationDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SourceConfigurationDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? code = null, Object? docs = null, Object? prs = null}) {
    return _then(
      _$SourceConfigurationDtoImpl(
        code:
            null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                    as bool,
        docs:
            null == docs
                ? _value.docs
                : docs // ignore: cast_nullable_to_non_nullable
                    as bool,
        prs:
            null == prs
                ? _value.prs
                : prs // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SourceConfigurationDtoImpl implements _SourceConfigurationDto {
  const _$SourceConfigurationDtoImpl({
    this.code = true,
    this.docs = true,
    this.prs = false,
  });

  factory _$SourceConfigurationDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SourceConfigurationDtoImplFromJson(json);

  @override
  @JsonKey()
  final bool code;
  @override
  @JsonKey()
  final bool docs;
  @override
  @JsonKey()
  final bool prs;

  @override
  String toString() {
    return 'SourceConfigurationDto(code: $code, docs: $docs, prs: $prs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SourceConfigurationDtoImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.docs, docs) || other.docs == docs) &&
            (identical(other.prs, prs) || other.prs == prs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, code, docs, prs);

  /// Create a copy of SourceConfigurationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SourceConfigurationDtoImplCopyWith<_$SourceConfigurationDtoImpl>
  get copyWith =>
      __$$SourceConfigurationDtoImplCopyWithImpl<_$SourceConfigurationDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SourceConfigurationDtoImplToJson(this);
  }
}

abstract class _SourceConfigurationDto implements SourceConfigurationDto {
  const factory _SourceConfigurationDto({
    final bool code,
    final bool docs,
    final bool prs,
  }) = _$SourceConfigurationDtoImpl;

  factory _SourceConfigurationDto.fromJson(Map<String, dynamic> json) =
      _$SourceConfigurationDtoImpl.fromJson;

  @override
  bool get code;
  @override
  bool get docs;
  @override
  bool get prs;

  /// Create a copy of SourceConfigurationDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SourceConfigurationDtoImplCopyWith<_$SourceConfigurationDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}

CreateRepositoryDto _$CreateRepositoryDtoFromJson(Map<String, dynamic> json) {
  return _CreateRepositoryDto.fromJson(json);
}

/// @nodoc
mixin _$CreateRepositoryDto {
  String get projectId => throw _privateConstructorUsedError;
  String get repositoryName => throw _privateConstructorUsedError;
  String? get repositoryUrl => throw _privateConstructorUsedError;
  String get provider => throw _privateConstructorUsedError;
  String? get githubInstallationId => throw _privateConstructorUsedError;
  int? get githubRepositoryId => throw _privateConstructorUsedError;
  String? get githubRepositoryFullName => throw _privateConstructorUsedError;
  SourceConfigurationDto? get sourceConfiguration =>
      throw _privateConstructorUsedError;

  /// Serializes this CreateRepositoryDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateRepositoryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateRepositoryDtoCopyWith<CreateRepositoryDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateRepositoryDtoCopyWith<$Res> {
  factory $CreateRepositoryDtoCopyWith(
    CreateRepositoryDto value,
    $Res Function(CreateRepositoryDto) then,
  ) = _$CreateRepositoryDtoCopyWithImpl<$Res, CreateRepositoryDto>;
  @useResult
  $Res call({
    String projectId,
    String repositoryName,
    String? repositoryUrl,
    String provider,
    String? githubInstallationId,
    int? githubRepositoryId,
    String? githubRepositoryFullName,
    SourceConfigurationDto? sourceConfiguration,
  });

  $SourceConfigurationDtoCopyWith<$Res>? get sourceConfiguration;
}

/// @nodoc
class _$CreateRepositoryDtoCopyWithImpl<$Res, $Val extends CreateRepositoryDto>
    implements $CreateRepositoryDtoCopyWith<$Res> {
  _$CreateRepositoryDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateRepositoryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? projectId = null,
    Object? repositoryName = null,
    Object? repositoryUrl = freezed,
    Object? provider = null,
    Object? githubInstallationId = freezed,
    Object? githubRepositoryId = freezed,
    Object? githubRepositoryFullName = freezed,
    Object? sourceConfiguration = freezed,
  }) {
    return _then(
      _value.copyWith(
            projectId:
                null == projectId
                    ? _value.projectId
                    : projectId // ignore: cast_nullable_to_non_nullable
                        as String,
            repositoryName:
                null == repositoryName
                    ? _value.repositoryName
                    : repositoryName // ignore: cast_nullable_to_non_nullable
                        as String,
            repositoryUrl:
                freezed == repositoryUrl
                    ? _value.repositoryUrl
                    : repositoryUrl // ignore: cast_nullable_to_non_nullable
                        as String?,
            provider:
                null == provider
                    ? _value.provider
                    : provider // ignore: cast_nullable_to_non_nullable
                        as String,
            githubInstallationId:
                freezed == githubInstallationId
                    ? _value.githubInstallationId
                    : githubInstallationId // ignore: cast_nullable_to_non_nullable
                        as String?,
            githubRepositoryId:
                freezed == githubRepositoryId
                    ? _value.githubRepositoryId
                    : githubRepositoryId // ignore: cast_nullable_to_non_nullable
                        as int?,
            githubRepositoryFullName:
                freezed == githubRepositoryFullName
                    ? _value.githubRepositoryFullName
                    : githubRepositoryFullName // ignore: cast_nullable_to_non_nullable
                        as String?,
            sourceConfiguration:
                freezed == sourceConfiguration
                    ? _value.sourceConfiguration
                    : sourceConfiguration // ignore: cast_nullable_to_non_nullable
                        as SourceConfigurationDto?,
          )
          as $Val,
    );
  }

  /// Create a copy of CreateRepositoryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SourceConfigurationDtoCopyWith<$Res>? get sourceConfiguration {
    if (_value.sourceConfiguration == null) {
      return null;
    }

    return $SourceConfigurationDtoCopyWith<$Res>(_value.sourceConfiguration!, (
      value,
    ) {
      return _then(_value.copyWith(sourceConfiguration: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CreateRepositoryDtoImplCopyWith<$Res>
    implements $CreateRepositoryDtoCopyWith<$Res> {
  factory _$$CreateRepositoryDtoImplCopyWith(
    _$CreateRepositoryDtoImpl value,
    $Res Function(_$CreateRepositoryDtoImpl) then,
  ) = __$$CreateRepositoryDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String projectId,
    String repositoryName,
    String? repositoryUrl,
    String provider,
    String? githubInstallationId,
    int? githubRepositoryId,
    String? githubRepositoryFullName,
    SourceConfigurationDto? sourceConfiguration,
  });

  @override
  $SourceConfigurationDtoCopyWith<$Res>? get sourceConfiguration;
}

/// @nodoc
class __$$CreateRepositoryDtoImplCopyWithImpl<$Res>
    extends _$CreateRepositoryDtoCopyWithImpl<$Res, _$CreateRepositoryDtoImpl>
    implements _$$CreateRepositoryDtoImplCopyWith<$Res> {
  __$$CreateRepositoryDtoImplCopyWithImpl(
    _$CreateRepositoryDtoImpl _value,
    $Res Function(_$CreateRepositoryDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateRepositoryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? projectId = null,
    Object? repositoryName = null,
    Object? repositoryUrl = freezed,
    Object? provider = null,
    Object? githubInstallationId = freezed,
    Object? githubRepositoryId = freezed,
    Object? githubRepositoryFullName = freezed,
    Object? sourceConfiguration = freezed,
  }) {
    return _then(
      _$CreateRepositoryDtoImpl(
        projectId:
            null == projectId
                ? _value.projectId
                : projectId // ignore: cast_nullable_to_non_nullable
                    as String,
        repositoryName:
            null == repositoryName
                ? _value.repositoryName
                : repositoryName // ignore: cast_nullable_to_non_nullable
                    as String,
        repositoryUrl:
            freezed == repositoryUrl
                ? _value.repositoryUrl
                : repositoryUrl // ignore: cast_nullable_to_non_nullable
                    as String?,
        provider:
            null == provider
                ? _value.provider
                : provider // ignore: cast_nullable_to_non_nullable
                    as String,
        githubInstallationId:
            freezed == githubInstallationId
                ? _value.githubInstallationId
                : githubInstallationId // ignore: cast_nullable_to_non_nullable
                    as String?,
        githubRepositoryId:
            freezed == githubRepositoryId
                ? _value.githubRepositoryId
                : githubRepositoryId // ignore: cast_nullable_to_non_nullable
                    as int?,
        githubRepositoryFullName:
            freezed == githubRepositoryFullName
                ? _value.githubRepositoryFullName
                : githubRepositoryFullName // ignore: cast_nullable_to_non_nullable
                    as String?,
        sourceConfiguration:
            freezed == sourceConfiguration
                ? _value.sourceConfiguration
                : sourceConfiguration // ignore: cast_nullable_to_non_nullable
                    as SourceConfigurationDto?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateRepositoryDtoImpl implements _CreateRepositoryDto {
  const _$CreateRepositoryDtoImpl({
    required this.projectId,
    required this.repositoryName,
    this.repositoryUrl,
    this.provider = 'GITHUB',
    this.githubInstallationId,
    this.githubRepositoryId,
    this.githubRepositoryFullName,
    this.sourceConfiguration,
  });

  factory _$CreateRepositoryDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateRepositoryDtoImplFromJson(json);

  @override
  final String projectId;
  @override
  final String repositoryName;
  @override
  final String? repositoryUrl;
  @override
  @JsonKey()
  final String provider;
  @override
  final String? githubInstallationId;
  @override
  final int? githubRepositoryId;
  @override
  final String? githubRepositoryFullName;
  @override
  final SourceConfigurationDto? sourceConfiguration;

  @override
  String toString() {
    return 'CreateRepositoryDto(projectId: $projectId, repositoryName: $repositoryName, repositoryUrl: $repositoryUrl, provider: $provider, githubInstallationId: $githubInstallationId, githubRepositoryId: $githubRepositoryId, githubRepositoryFullName: $githubRepositoryFullName, sourceConfiguration: $sourceConfiguration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateRepositoryDtoImpl &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.repositoryName, repositoryName) ||
                other.repositoryName == repositoryName) &&
            (identical(other.repositoryUrl, repositoryUrl) ||
                other.repositoryUrl == repositoryUrl) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.githubInstallationId, githubInstallationId) ||
                other.githubInstallationId == githubInstallationId) &&
            (identical(other.githubRepositoryId, githubRepositoryId) ||
                other.githubRepositoryId == githubRepositoryId) &&
            (identical(
                  other.githubRepositoryFullName,
                  githubRepositoryFullName,
                ) ||
                other.githubRepositoryFullName == githubRepositoryFullName) &&
            (identical(other.sourceConfiguration, sourceConfiguration) ||
                other.sourceConfiguration == sourceConfiguration));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    projectId,
    repositoryName,
    repositoryUrl,
    provider,
    githubInstallationId,
    githubRepositoryId,
    githubRepositoryFullName,
    sourceConfiguration,
  );

  /// Create a copy of CreateRepositoryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateRepositoryDtoImplCopyWith<_$CreateRepositoryDtoImpl> get copyWith =>
      __$$CreateRepositoryDtoImplCopyWithImpl<_$CreateRepositoryDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateRepositoryDtoImplToJson(this);
  }
}

abstract class _CreateRepositoryDto implements CreateRepositoryDto {
  const factory _CreateRepositoryDto({
    required final String projectId,
    required final String repositoryName,
    final String? repositoryUrl,
    final String provider,
    final String? githubInstallationId,
    final int? githubRepositoryId,
    final String? githubRepositoryFullName,
    final SourceConfigurationDto? sourceConfiguration,
  }) = _$CreateRepositoryDtoImpl;

  factory _CreateRepositoryDto.fromJson(Map<String, dynamic> json) =
      _$CreateRepositoryDtoImpl.fromJson;

  @override
  String get projectId;
  @override
  String get repositoryName;
  @override
  String? get repositoryUrl;
  @override
  String get provider;
  @override
  String? get githubInstallationId;
  @override
  int? get githubRepositoryId;
  @override
  String? get githubRepositoryFullName;
  @override
  SourceConfigurationDto? get sourceConfiguration;

  /// Create a copy of CreateRepositoryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateRepositoryDtoImplCopyWith<_$CreateRepositoryDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UpdateRepositoryDto _$UpdateRepositoryDtoFromJson(Map<String, dynamic> json) {
  return _UpdateRepositoryDto.fromJson(json);
}

/// @nodoc
mixin _$UpdateRepositoryDto {
  bool? get isActive => throw _privateConstructorUsedError;

  /// Serializes this UpdateRepositoryDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateRepositoryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateRepositoryDtoCopyWith<UpdateRepositoryDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateRepositoryDtoCopyWith<$Res> {
  factory $UpdateRepositoryDtoCopyWith(
    UpdateRepositoryDto value,
    $Res Function(UpdateRepositoryDto) then,
  ) = _$UpdateRepositoryDtoCopyWithImpl<$Res, UpdateRepositoryDto>;
  @useResult
  $Res call({bool? isActive});
}

/// @nodoc
class _$UpdateRepositoryDtoCopyWithImpl<$Res, $Val extends UpdateRepositoryDto>
    implements $UpdateRepositoryDtoCopyWith<$Res> {
  _$UpdateRepositoryDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateRepositoryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isActive = freezed}) {
    return _then(
      _value.copyWith(
            isActive:
                freezed == isActive
                    ? _value.isActive
                    : isActive // ignore: cast_nullable_to_non_nullable
                        as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateRepositoryDtoImplCopyWith<$Res>
    implements $UpdateRepositoryDtoCopyWith<$Res> {
  factory _$$UpdateRepositoryDtoImplCopyWith(
    _$UpdateRepositoryDtoImpl value,
    $Res Function(_$UpdateRepositoryDtoImpl) then,
  ) = __$$UpdateRepositoryDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool? isActive});
}

/// @nodoc
class __$$UpdateRepositoryDtoImplCopyWithImpl<$Res>
    extends _$UpdateRepositoryDtoCopyWithImpl<$Res, _$UpdateRepositoryDtoImpl>
    implements _$$UpdateRepositoryDtoImplCopyWith<$Res> {
  __$$UpdateRepositoryDtoImplCopyWithImpl(
    _$UpdateRepositoryDtoImpl _value,
    $Res Function(_$UpdateRepositoryDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateRepositoryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isActive = freezed}) {
    return _then(
      _$UpdateRepositoryDtoImpl(
        isActive:
            freezed == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                    as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateRepositoryDtoImpl implements _UpdateRepositoryDto {
  const _$UpdateRepositoryDtoImpl({this.isActive});

  factory _$UpdateRepositoryDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateRepositoryDtoImplFromJson(json);

  @override
  final bool? isActive;

  @override
  String toString() {
    return 'UpdateRepositoryDto(isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateRepositoryDtoImpl &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, isActive);

  /// Create a copy of UpdateRepositoryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateRepositoryDtoImplCopyWith<_$UpdateRepositoryDtoImpl> get copyWith =>
      __$$UpdateRepositoryDtoImplCopyWithImpl<_$UpdateRepositoryDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateRepositoryDtoImplToJson(this);
  }
}

abstract class _UpdateRepositoryDto implements UpdateRepositoryDto {
  const factory _UpdateRepositoryDto({final bool? isActive}) =
      _$UpdateRepositoryDtoImpl;

  factory _UpdateRepositoryDto.fromJson(Map<String, dynamic> json) =
      _$UpdateRepositoryDtoImpl.fromJson;

  @override
  bool? get isActive;

  /// Create a copy of UpdateRepositoryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateRepositoryDtoImplCopyWith<_$UpdateRepositoryDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
