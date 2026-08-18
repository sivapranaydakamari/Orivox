// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Session _$SessionFromJson(Map<String, dynamic> json) {
  return _Session.fromJson(json);
}

/// @nodoc
mixin _$Session {
  String get sessionId => throw _privateConstructorUsedError;
  String? get deviceName => throw _privateConstructorUsedError;
  String? get platform => throw _privateConstructorUsedError;
  String? get appVersion => throw _privateConstructorUsedError;
  String? get ipAddress => throw _privateConstructorUsedError;
  DateTime get lastUsedAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Session to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionCopyWith<Session> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionCopyWith<$Res> {
  factory $SessionCopyWith(Session value, $Res Function(Session) then) =
      _$SessionCopyWithImpl<$Res, Session>;
  @useResult
  $Res call({
    String sessionId,
    String? deviceName,
    String? platform,
    String? appVersion,
    String? ipAddress,
    DateTime lastUsedAt,
    DateTime createdAt,
  });
}

/// @nodoc
class _$SessionCopyWithImpl<$Res, $Val extends Session>
    implements $SessionCopyWith<$Res> {
  _$SessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? deviceName = freezed,
    Object? platform = freezed,
    Object? appVersion = freezed,
    Object? ipAddress = freezed,
    Object? lastUsedAt = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            sessionId:
                null == sessionId
                    ? _value.sessionId
                    : sessionId // ignore: cast_nullable_to_non_nullable
                        as String,
            deviceName:
                freezed == deviceName
                    ? _value.deviceName
                    : deviceName // ignore: cast_nullable_to_non_nullable
                        as String?,
            platform:
                freezed == platform
                    ? _value.platform
                    : platform // ignore: cast_nullable_to_non_nullable
                        as String?,
            appVersion:
                freezed == appVersion
                    ? _value.appVersion
                    : appVersion // ignore: cast_nullable_to_non_nullable
                        as String?,
            ipAddress:
                freezed == ipAddress
                    ? _value.ipAddress
                    : ipAddress // ignore: cast_nullable_to_non_nullable
                        as String?,
            lastUsedAt:
                null == lastUsedAt
                    ? _value.lastUsedAt
                    : lastUsedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SessionImplCopyWith<$Res> implements $SessionCopyWith<$Res> {
  factory _$$SessionImplCopyWith(
    _$SessionImpl value,
    $Res Function(_$SessionImpl) then,
  ) = __$$SessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String sessionId,
    String? deviceName,
    String? platform,
    String? appVersion,
    String? ipAddress,
    DateTime lastUsedAt,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$SessionImplCopyWithImpl<$Res>
    extends _$SessionCopyWithImpl<$Res, _$SessionImpl>
    implements _$$SessionImplCopyWith<$Res> {
  __$$SessionImplCopyWithImpl(
    _$SessionImpl _value,
    $Res Function(_$SessionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? deviceName = freezed,
    Object? platform = freezed,
    Object? appVersion = freezed,
    Object? ipAddress = freezed,
    Object? lastUsedAt = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$SessionImpl(
        sessionId:
            null == sessionId
                ? _value.sessionId
                : sessionId // ignore: cast_nullable_to_non_nullable
                    as String,
        deviceName:
            freezed == deviceName
                ? _value.deviceName
                : deviceName // ignore: cast_nullable_to_non_nullable
                    as String?,
        platform:
            freezed == platform
                ? _value.platform
                : platform // ignore: cast_nullable_to_non_nullable
                    as String?,
        appVersion:
            freezed == appVersion
                ? _value.appVersion
                : appVersion // ignore: cast_nullable_to_non_nullable
                    as String?,
        ipAddress:
            freezed == ipAddress
                ? _value.ipAddress
                : ipAddress // ignore: cast_nullable_to_non_nullable
                    as String?,
        lastUsedAt:
            null == lastUsedAt
                ? _value.lastUsedAt
                : lastUsedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionImpl implements _Session {
  const _$SessionImpl({
    required this.sessionId,
    this.deviceName,
    this.platform,
    this.appVersion,
    this.ipAddress,
    required this.lastUsedAt,
    required this.createdAt,
  });

  factory _$SessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionImplFromJson(json);

  @override
  final String sessionId;
  @override
  final String? deviceName;
  @override
  final String? platform;
  @override
  final String? appVersion;
  @override
  final String? ipAddress;
  @override
  final DateTime lastUsedAt;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'Session(sessionId: $sessionId, deviceName: $deviceName, platform: $platform, appVersion: $appVersion, ipAddress: $ipAddress, lastUsedAt: $lastUsedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.deviceName, deviceName) ||
                other.deviceName == deviceName) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.appVersion, appVersion) ||
                other.appVersion == appVersion) &&
            (identical(other.ipAddress, ipAddress) ||
                other.ipAddress == ipAddress) &&
            (identical(other.lastUsedAt, lastUsedAt) ||
                other.lastUsedAt == lastUsedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    sessionId,
    deviceName,
    platform,
    appVersion,
    ipAddress,
    lastUsedAt,
    createdAt,
  );

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionImplCopyWith<_$SessionImpl> get copyWith =>
      __$$SessionImplCopyWithImpl<_$SessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionImplToJson(this);
  }
}

abstract class _Session implements Session {
  const factory _Session({
    required final String sessionId,
    final String? deviceName,
    final String? platform,
    final String? appVersion,
    final String? ipAddress,
    required final DateTime lastUsedAt,
    required final DateTime createdAt,
  }) = _$SessionImpl;

  factory _Session.fromJson(Map<String, dynamic> json) = _$SessionImpl.fromJson;

  @override
  String get sessionId;
  @override
  String? get deviceName;
  @override
  String? get platform;
  @override
  String? get appVersion;
  @override
  String? get ipAddress;
  @override
  DateTime get lastUsedAt;
  @override
  DateTime get createdAt;

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionImplCopyWith<_$SessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
