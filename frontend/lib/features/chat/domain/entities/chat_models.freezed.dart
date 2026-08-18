// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ParsedSource _$ParsedSourceFromJson(Map<String, dynamic> json) {
  return _ParsedSource.fromJson(json);
}

/// @nodoc
mixin _$ParsedSource {
  String get sourceType => throw _privateConstructorUsedError;
  String get repository => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;
  double get similarityScore => throw _privateConstructorUsedError;
  String get rawCitation => throw _privateConstructorUsedError;

  /// Serializes this ParsedSource to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ParsedSource
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ParsedSourceCopyWith<ParsedSource> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParsedSourceCopyWith<$Res> {
  factory $ParsedSourceCopyWith(
    ParsedSource value,
    $Res Function(ParsedSource) then,
  ) = _$ParsedSourceCopyWithImpl<$Res, ParsedSource>;
  @useResult
  $Res call({
    String sourceType,
    String repository,
    String id,
    double similarityScore,
    String rawCitation,
  });
}

/// @nodoc
class _$ParsedSourceCopyWithImpl<$Res, $Val extends ParsedSource>
    implements $ParsedSourceCopyWith<$Res> {
  _$ParsedSourceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ParsedSource
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sourceType = null,
    Object? repository = null,
    Object? id = null,
    Object? similarityScore = null,
    Object? rawCitation = null,
  }) {
    return _then(
      _value.copyWith(
            sourceType:
                null == sourceType
                    ? _value.sourceType
                    : sourceType // ignore: cast_nullable_to_non_nullable
                        as String,
            repository:
                null == repository
                    ? _value.repository
                    : repository // ignore: cast_nullable_to_non_nullable
                        as String,
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            similarityScore:
                null == similarityScore
                    ? _value.similarityScore
                    : similarityScore // ignore: cast_nullable_to_non_nullable
                        as double,
            rawCitation:
                null == rawCitation
                    ? _value.rawCitation
                    : rawCitation // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ParsedSourceImplCopyWith<$Res>
    implements $ParsedSourceCopyWith<$Res> {
  factory _$$ParsedSourceImplCopyWith(
    _$ParsedSourceImpl value,
    $Res Function(_$ParsedSourceImpl) then,
  ) = __$$ParsedSourceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String sourceType,
    String repository,
    String id,
    double similarityScore,
    String rawCitation,
  });
}

/// @nodoc
class __$$ParsedSourceImplCopyWithImpl<$Res>
    extends _$ParsedSourceCopyWithImpl<$Res, _$ParsedSourceImpl>
    implements _$$ParsedSourceImplCopyWith<$Res> {
  __$$ParsedSourceImplCopyWithImpl(
    _$ParsedSourceImpl _value,
    $Res Function(_$ParsedSourceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ParsedSource
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sourceType = null,
    Object? repository = null,
    Object? id = null,
    Object? similarityScore = null,
    Object? rawCitation = null,
  }) {
    return _then(
      _$ParsedSourceImpl(
        sourceType:
            null == sourceType
                ? _value.sourceType
                : sourceType // ignore: cast_nullable_to_non_nullable
                    as String,
        repository:
            null == repository
                ? _value.repository
                : repository // ignore: cast_nullable_to_non_nullable
                    as String,
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        similarityScore:
            null == similarityScore
                ? _value.similarityScore
                : similarityScore // ignore: cast_nullable_to_non_nullable
                    as double,
        rawCitation:
            null == rawCitation
                ? _value.rawCitation
                : rawCitation // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ParsedSourceImpl implements _ParsedSource {
  const _$ParsedSourceImpl({
    required this.sourceType,
    required this.repository,
    required this.id,
    required this.similarityScore,
    required this.rawCitation,
  });

  factory _$ParsedSourceImpl.fromJson(Map<String, dynamic> json) =>
      _$$ParsedSourceImplFromJson(json);

  @override
  final String sourceType;
  @override
  final String repository;
  @override
  final String id;
  @override
  final double similarityScore;
  @override
  final String rawCitation;

  @override
  String toString() {
    return 'ParsedSource(sourceType: $sourceType, repository: $repository, id: $id, similarityScore: $similarityScore, rawCitation: $rawCitation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParsedSourceImpl &&
            (identical(other.sourceType, sourceType) ||
                other.sourceType == sourceType) &&
            (identical(other.repository, repository) ||
                other.repository == repository) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.similarityScore, similarityScore) ||
                other.similarityScore == similarityScore) &&
            (identical(other.rawCitation, rawCitation) ||
                other.rawCitation == rawCitation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    sourceType,
    repository,
    id,
    similarityScore,
    rawCitation,
  );

  /// Create a copy of ParsedSource
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ParsedSourceImplCopyWith<_$ParsedSourceImpl> get copyWith =>
      __$$ParsedSourceImplCopyWithImpl<_$ParsedSourceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ParsedSourceImplToJson(this);
  }
}

abstract class _ParsedSource implements ParsedSource {
  const factory _ParsedSource({
    required final String sourceType,
    required final String repository,
    required final String id,
    required final double similarityScore,
    required final String rawCitation,
  }) = _$ParsedSourceImpl;

  factory _ParsedSource.fromJson(Map<String, dynamic> json) =
      _$ParsedSourceImpl.fromJson;

  @override
  String get sourceType;
  @override
  String get repository;
  @override
  String get id;
  @override
  double get similarityScore;
  @override
  String get rawCitation;

  /// Create a copy of ParsedSource
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ParsedSourceImplCopyWith<_$ParsedSourceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChatResponseMetadata _$ChatResponseMetadataFromJson(Map<String, dynamic> json) {
  return _ChatResponseMetadata.fromJson(json);
}

/// @nodoc
mixin _$ChatResponseMetadata {
  double get confidence => throw _privateConstructorUsedError;
  List<String> get sources =>
      throw _privateConstructorUsedError; // Raw string sources from backend
  List<String> get warnings => throw _privateConstructorUsedError;
  String? get promptVersion => throw _privateConstructorUsedError;
  String? get modelName => throw _privateConstructorUsedError;
  String? get modelVersion => throw _privateConstructorUsedError;

  /// Serializes this ChatResponseMetadata to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatResponseMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatResponseMetadataCopyWith<ChatResponseMetadata> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatResponseMetadataCopyWith<$Res> {
  factory $ChatResponseMetadataCopyWith(
    ChatResponseMetadata value,
    $Res Function(ChatResponseMetadata) then,
  ) = _$ChatResponseMetadataCopyWithImpl<$Res, ChatResponseMetadata>;
  @useResult
  $Res call({
    double confidence,
    List<String> sources,
    List<String> warnings,
    String? promptVersion,
    String? modelName,
    String? modelVersion,
  });
}

/// @nodoc
class _$ChatResponseMetadataCopyWithImpl<
  $Res,
  $Val extends ChatResponseMetadata
>
    implements $ChatResponseMetadataCopyWith<$Res> {
  _$ChatResponseMetadataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatResponseMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? confidence = null,
    Object? sources = null,
    Object? warnings = null,
    Object? promptVersion = freezed,
    Object? modelName = freezed,
    Object? modelVersion = freezed,
  }) {
    return _then(
      _value.copyWith(
            confidence:
                null == confidence
                    ? _value.confidence
                    : confidence // ignore: cast_nullable_to_non_nullable
                        as double,
            sources:
                null == sources
                    ? _value.sources
                    : sources // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            warnings:
                null == warnings
                    ? _value.warnings
                    : warnings // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            promptVersion:
                freezed == promptVersion
                    ? _value.promptVersion
                    : promptVersion // ignore: cast_nullable_to_non_nullable
                        as String?,
            modelName:
                freezed == modelName
                    ? _value.modelName
                    : modelName // ignore: cast_nullable_to_non_nullable
                        as String?,
            modelVersion:
                freezed == modelVersion
                    ? _value.modelVersion
                    : modelVersion // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChatResponseMetadataImplCopyWith<$Res>
    implements $ChatResponseMetadataCopyWith<$Res> {
  factory _$$ChatResponseMetadataImplCopyWith(
    _$ChatResponseMetadataImpl value,
    $Res Function(_$ChatResponseMetadataImpl) then,
  ) = __$$ChatResponseMetadataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double confidence,
    List<String> sources,
    List<String> warnings,
    String? promptVersion,
    String? modelName,
    String? modelVersion,
  });
}

/// @nodoc
class __$$ChatResponseMetadataImplCopyWithImpl<$Res>
    extends _$ChatResponseMetadataCopyWithImpl<$Res, _$ChatResponseMetadataImpl>
    implements _$$ChatResponseMetadataImplCopyWith<$Res> {
  __$$ChatResponseMetadataImplCopyWithImpl(
    _$ChatResponseMetadataImpl _value,
    $Res Function(_$ChatResponseMetadataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatResponseMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? confidence = null,
    Object? sources = null,
    Object? warnings = null,
    Object? promptVersion = freezed,
    Object? modelName = freezed,
    Object? modelVersion = freezed,
  }) {
    return _then(
      _$ChatResponseMetadataImpl(
        confidence:
            null == confidence
                ? _value.confidence
                : confidence // ignore: cast_nullable_to_non_nullable
                    as double,
        sources:
            null == sources
                ? _value._sources
                : sources // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        warnings:
            null == warnings
                ? _value._warnings
                : warnings // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        promptVersion:
            freezed == promptVersion
                ? _value.promptVersion
                : promptVersion // ignore: cast_nullable_to_non_nullable
                    as String?,
        modelName:
            freezed == modelName
                ? _value.modelName
                : modelName // ignore: cast_nullable_to_non_nullable
                    as String?,
        modelVersion:
            freezed == modelVersion
                ? _value.modelVersion
                : modelVersion // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatResponseMetadataImpl implements _ChatResponseMetadata {
  const _$ChatResponseMetadataImpl({
    required this.confidence,
    final List<String> sources = const [],
    final List<String> warnings = const [],
    this.promptVersion,
    this.modelName,
    this.modelVersion,
  }) : _sources = sources,
       _warnings = warnings;

  factory _$ChatResponseMetadataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatResponseMetadataImplFromJson(json);

  @override
  final double confidence;
  final List<String> _sources;
  @override
  @JsonKey()
  List<String> get sources {
    if (_sources is EqualUnmodifiableListView) return _sources;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sources);
  }

  // Raw string sources from backend
  final List<String> _warnings;
  // Raw string sources from backend
  @override
  @JsonKey()
  List<String> get warnings {
    if (_warnings is EqualUnmodifiableListView) return _warnings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_warnings);
  }

  @override
  final String? promptVersion;
  @override
  final String? modelName;
  @override
  final String? modelVersion;

  @override
  String toString() {
    return 'ChatResponseMetadata(confidence: $confidence, sources: $sources, warnings: $warnings, promptVersion: $promptVersion, modelName: $modelName, modelVersion: $modelVersion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatResponseMetadataImpl &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            const DeepCollectionEquality().equals(other._sources, _sources) &&
            const DeepCollectionEquality().equals(other._warnings, _warnings) &&
            (identical(other.promptVersion, promptVersion) ||
                other.promptVersion == promptVersion) &&
            (identical(other.modelName, modelName) ||
                other.modelName == modelName) &&
            (identical(other.modelVersion, modelVersion) ||
                other.modelVersion == modelVersion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    confidence,
    const DeepCollectionEquality().hash(_sources),
    const DeepCollectionEquality().hash(_warnings),
    promptVersion,
    modelName,
    modelVersion,
  );

  /// Create a copy of ChatResponseMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatResponseMetadataImplCopyWith<_$ChatResponseMetadataImpl>
  get copyWith =>
      __$$ChatResponseMetadataImplCopyWithImpl<_$ChatResponseMetadataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatResponseMetadataImplToJson(this);
  }
}

abstract class _ChatResponseMetadata implements ChatResponseMetadata {
  const factory _ChatResponseMetadata({
    required final double confidence,
    final List<String> sources,
    final List<String> warnings,
    final String? promptVersion,
    final String? modelName,
    final String? modelVersion,
  }) = _$ChatResponseMetadataImpl;

  factory _ChatResponseMetadata.fromJson(Map<String, dynamic> json) =
      _$ChatResponseMetadataImpl.fromJson;

  @override
  double get confidence;
  @override
  List<String> get sources; // Raw string sources from backend
  @override
  List<String> get warnings;
  @override
  String? get promptVersion;
  @override
  String? get modelName;
  @override
  String? get modelVersion;

  /// Create a copy of ChatResponseMetadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatResponseMetadataImplCopyWith<_$ChatResponseMetadataImpl>
  get copyWith => throw _privateConstructorUsedError;
}

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) {
  return _ChatMessage.fromJson(json);
}

/// @nodoc
mixin _$ChatMessage {
  String get id => throw _privateConstructorUsedError;
  ChatRole get role => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  ChatResponseMetadata? get metadata => throw _privateConstructorUsedError;
  bool get isError => throw _privateConstructorUsedError;

  /// Serializes this ChatMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatMessageCopyWith<ChatMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMessageCopyWith<$Res> {
  factory $ChatMessageCopyWith(
    ChatMessage value,
    $Res Function(ChatMessage) then,
  ) = _$ChatMessageCopyWithImpl<$Res, ChatMessage>;
  @useResult
  $Res call({
    String id,
    ChatRole role,
    String content,
    DateTime timestamp,
    ChatResponseMetadata? metadata,
    bool isError,
  });

  $ChatResponseMetadataCopyWith<$Res>? get metadata;
}

/// @nodoc
class _$ChatMessageCopyWithImpl<$Res, $Val extends ChatMessage>
    implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? role = null,
    Object? content = null,
    Object? timestamp = null,
    Object? metadata = freezed,
    Object? isError = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            role:
                null == role
                    ? _value.role
                    : role // ignore: cast_nullable_to_non_nullable
                        as ChatRole,
            content:
                null == content
                    ? _value.content
                    : content // ignore: cast_nullable_to_non_nullable
                        as String,
            timestamp:
                null == timestamp
                    ? _value.timestamp
                    : timestamp // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            metadata:
                freezed == metadata
                    ? _value.metadata
                    : metadata // ignore: cast_nullable_to_non_nullable
                        as ChatResponseMetadata?,
            isError:
                null == isError
                    ? _value.isError
                    : isError // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChatResponseMetadataCopyWith<$Res>? get metadata {
    if (_value.metadata == null) {
      return null;
    }

    return $ChatResponseMetadataCopyWith<$Res>(_value.metadata!, (value) {
      return _then(_value.copyWith(metadata: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChatMessageImplCopyWith<$Res>
    implements $ChatMessageCopyWith<$Res> {
  factory _$$ChatMessageImplCopyWith(
    _$ChatMessageImpl value,
    $Res Function(_$ChatMessageImpl) then,
  ) = __$$ChatMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    ChatRole role,
    String content,
    DateTime timestamp,
    ChatResponseMetadata? metadata,
    bool isError,
  });

  @override
  $ChatResponseMetadataCopyWith<$Res>? get metadata;
}

/// @nodoc
class __$$ChatMessageImplCopyWithImpl<$Res>
    extends _$ChatMessageCopyWithImpl<$Res, _$ChatMessageImpl>
    implements _$$ChatMessageImplCopyWith<$Res> {
  __$$ChatMessageImplCopyWithImpl(
    _$ChatMessageImpl _value,
    $Res Function(_$ChatMessageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? role = null,
    Object? content = null,
    Object? timestamp = null,
    Object? metadata = freezed,
    Object? isError = null,
  }) {
    return _then(
      _$ChatMessageImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        role:
            null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                    as ChatRole,
        content:
            null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                    as String,
        timestamp:
            null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        metadata:
            freezed == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                    as ChatResponseMetadata?,
        isError:
            null == isError
                ? _value.isError
                : isError // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatMessageImpl implements _ChatMessage {
  const _$ChatMessageImpl({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    this.metadata,
    this.isError = false,
  });

  factory _$ChatMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatMessageImplFromJson(json);

  @override
  final String id;
  @override
  final ChatRole role;
  @override
  final String content;
  @override
  final DateTime timestamp;
  @override
  final ChatResponseMetadata? metadata;
  @override
  @JsonKey()
  final bool isError;

  @override
  String toString() {
    return 'ChatMessage(id: $id, role: $role, content: $content, timestamp: $timestamp, metadata: $metadata, isError: $isError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.metadata, metadata) ||
                other.metadata == metadata) &&
            (identical(other.isError, isError) || other.isError == isError));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, role, content, timestamp, metadata, isError);

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      __$$ChatMessageImplCopyWithImpl<_$ChatMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatMessageImplToJson(this);
  }
}

abstract class _ChatMessage implements ChatMessage {
  const factory _ChatMessage({
    required final String id,
    required final ChatRole role,
    required final String content,
    required final DateTime timestamp,
    final ChatResponseMetadata? metadata,
    final bool isError,
  }) = _$ChatMessageImpl;

  factory _ChatMessage.fromJson(Map<String, dynamic> json) =
      _$ChatMessageImpl.fromJson;

  @override
  String get id;
  @override
  ChatRole get role;
  @override
  String get content;
  @override
  DateTime get timestamp;
  @override
  ChatResponseMetadata? get metadata;
  @override
  bool get isError;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Conversation _$ConversationFromJson(Map<String, dynamic> json) {
  return _Conversation.fromJson(json);
}

/// @nodoc
mixin _$Conversation {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  List<ChatMessage> get messages => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Conversation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConversationCopyWith<Conversation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationCopyWith<$Res> {
  factory $ConversationCopyWith(
    Conversation value,
    $Res Function(Conversation) then,
  ) = _$ConversationCopyWithImpl<$Res, Conversation>;
  @useResult
  $Res call({
    String id,
    String title,
    List<ChatMessage> messages,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$ConversationCopyWithImpl<$Res, $Val extends Conversation>
    implements $ConversationCopyWith<$Res> {
  _$ConversationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? messages = null,
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
            messages:
                null == messages
                    ? _value.messages
                    : messages // ignore: cast_nullable_to_non_nullable
                        as List<ChatMessage>,
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
abstract class _$$ConversationImplCopyWith<$Res>
    implements $ConversationCopyWith<$Res> {
  factory _$$ConversationImplCopyWith(
    _$ConversationImpl value,
    $Res Function(_$ConversationImpl) then,
  ) = __$$ConversationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    List<ChatMessage> messages,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$ConversationImplCopyWithImpl<$Res>
    extends _$ConversationCopyWithImpl<$Res, _$ConversationImpl>
    implements _$$ConversationImplCopyWith<$Res> {
  __$$ConversationImplCopyWithImpl(
    _$ConversationImpl _value,
    $Res Function(_$ConversationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? messages = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$ConversationImpl(
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
        messages:
            null == messages
                ? _value._messages
                : messages // ignore: cast_nullable_to_non_nullable
                    as List<ChatMessage>,
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
class _$ConversationImpl implements _Conversation {
  const _$ConversationImpl({
    required this.id,
    required this.title,
    final List<ChatMessage> messages = const [],
    required this.createdAt,
    required this.updatedAt,
  }) : _messages = messages;

  factory _$ConversationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  final List<ChatMessage> _messages;
  @override
  @JsonKey()
  List<ChatMessage> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Conversation(id: $id, title: $title, messages: $messages, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other._messages, _messages) &&
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
    const DeepCollectionEquality().hash(_messages),
    createdAt,
    updatedAt,
  );

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationImplCopyWith<_$ConversationImpl> get copyWith =>
      __$$ConversationImplCopyWithImpl<_$ConversationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationImplToJson(this);
  }
}

abstract class _Conversation implements Conversation {
  const factory _Conversation({
    required final String id,
    required final String title,
    final List<ChatMessage> messages,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$ConversationImpl;

  factory _Conversation.fromJson(Map<String, dynamic> json) =
      _$ConversationImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  List<ChatMessage> get messages;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConversationImplCopyWith<_$ConversationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
