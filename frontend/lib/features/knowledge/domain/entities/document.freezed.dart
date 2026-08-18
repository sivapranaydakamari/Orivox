// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AppDocument _$AppDocumentFromJson(Map<String, dynamic> json) {
  return _AppDocument.fromJson(json);
}

/// @nodoc
mixin _$AppDocument {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get rawContent => throw _privateConstructorUsedError;
  String get sourceType => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this AppDocument to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppDocument
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppDocumentCopyWith<AppDocument> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppDocumentCopyWith<$Res> {
  factory $AppDocumentCopyWith(
    AppDocument value,
    $Res Function(AppDocument) then,
  ) = _$AppDocumentCopyWithImpl<$Res, AppDocument>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String title,
    String rawContent,
    String sourceType,
    String status,
    Map<String, dynamic>? metadata,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$AppDocumentCopyWithImpl<$Res, $Val extends AppDocument>
    implements $AppDocumentCopyWith<$Res> {
  _$AppDocumentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppDocument
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? rawContent = null,
    Object? sourceType = null,
    Object? status = null,
    Object? metadata = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            title:
                null == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String,
            rawContent:
                null == rawContent
                    ? _value.rawContent
                    : rawContent // ignore: cast_nullable_to_non_nullable
                        as String,
            sourceType:
                null == sourceType
                    ? _value.sourceType
                    : sourceType // ignore: cast_nullable_to_non_nullable
                        as String,
            status:
                null == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as String,
            metadata:
                freezed == metadata
                    ? _value.metadata
                    : metadata // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            updatedAt:
                null == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppDocumentImplCopyWith<$Res>
    implements $AppDocumentCopyWith<$Res> {
  factory _$$AppDocumentImplCopyWith(
    _$AppDocumentImpl value,
    $Res Function(_$AppDocumentImpl) then,
  ) = __$$AppDocumentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String title,
    String rawContent,
    String sourceType,
    String status,
    Map<String, dynamic>? metadata,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$AppDocumentImplCopyWithImpl<$Res>
    extends _$AppDocumentCopyWithImpl<$Res, _$AppDocumentImpl>
    implements _$$AppDocumentImplCopyWith<$Res> {
  __$$AppDocumentImplCopyWithImpl(
    _$AppDocumentImpl _value,
    $Res Function(_$AppDocumentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppDocument
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? rawContent = null,
    Object? sourceType = null,
    Object? status = null,
    Object? metadata = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$AppDocumentImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        title:
            null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String,
        rawContent:
            null == rawContent
                ? _value.rawContent
                : rawContent // ignore: cast_nullable_to_non_nullable
                    as String,
        sourceType:
            null == sourceType
                ? _value.sourceType
                : sourceType // ignore: cast_nullable_to_non_nullable
                    as String,
        status:
            null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as String,
        metadata:
            freezed == metadata
                ? _value._metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        updatedAt:
            null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppDocumentImpl implements _AppDocument {
  const _$AppDocumentImpl({
    @JsonKey(name: '_id') required this.id,
    required this.title,
    required this.rawContent,
    required this.sourceType,
    required this.status,
    final Map<String, dynamic>? metadata,
    required this.createdAt,
    required this.updatedAt,
  }) : _metadata = metadata;

  factory _$AppDocumentImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppDocumentImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String title;
  @override
  final String rawContent;
  @override
  final String sourceType;
  @override
  final String status;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'AppDocument(id: $id, title: $title, rawContent: $rawContent, sourceType: $sourceType, status: $status, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppDocumentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.rawContent, rawContent) ||
                other.rawContent == rawContent) &&
            (identical(other.sourceType, sourceType) ||
                other.sourceType == sourceType) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    rawContent,
    sourceType,
    status,
    const DeepCollectionEquality().hash(_metadata),
    createdAt,
    updatedAt,
  );

  /// Create a copy of AppDocument
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppDocumentImplCopyWith<_$AppDocumentImpl> get copyWith =>
      __$$AppDocumentImplCopyWithImpl<_$AppDocumentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppDocumentImplToJson(this);
  }
}

abstract class _AppDocument implements AppDocument {
  const factory _AppDocument({
    @JsonKey(name: '_id') required final String id,
    required final String title,
    required final String rawContent,
    required final String sourceType,
    required final String status,
    final Map<String, dynamic>? metadata,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$AppDocumentImpl;

  factory _AppDocument.fromJson(Map<String, dynamic> json) =
      _$AppDocumentImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get title;
  @override
  String get rawContent;
  @override
  String get sourceType;
  @override
  String get status;
  @override
  Map<String, dynamic>? get metadata;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of AppDocument
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppDocumentImplCopyWith<_$AppDocumentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
