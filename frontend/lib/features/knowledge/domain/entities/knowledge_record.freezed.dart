// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'knowledge_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

KnowledgeRecord _$KnowledgeRecordFromJson(Map<String, dynamic> json) {
  return _KnowledgeRecord.fromJson(json);
}

/// @nodoc
mixin _$KnowledgeRecord {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get summary => throw _privateConstructorUsedError;
  String get sourceType => throw _privateConstructorUsedError;
  String get embeddingStatus => throw _privateConstructorUsedError;
  dynamic get confidence => throw _privateConstructorUsedError;
  String? get engineeringReasoning => throw _privateConstructorUsedError;
  List<String> get technicalDecisions => throw _privateConstructorUsedError;
  String? get businessContext => throw _privateConstructorUsedError;
  List<String> get risks => throw _privateConstructorUsedError;
  List<String> get breakingChanges => throw _privateConstructorUsedError;
  List<String> get dependencies => throw _privateConstructorUsedError;
  List<String> get affectedComponents => throw _privateConstructorUsedError;
  List<String> get referencedApis => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  String? get author => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  String? get documentId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this KnowledgeRecord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KnowledgeRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KnowledgeRecordCopyWith<KnowledgeRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KnowledgeRecordCopyWith<$Res> {
  factory $KnowledgeRecordCopyWith(
    KnowledgeRecord value,
    $Res Function(KnowledgeRecord) then,
  ) = _$KnowledgeRecordCopyWithImpl<$Res, KnowledgeRecord>;
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String title,
    String summary,
    String sourceType,
    String embeddingStatus,
    dynamic confidence,
    String? engineeringReasoning,
    List<String> technicalDecisions,
    String? businessContext,
    List<String> risks,
    List<String> breakingChanges,
    List<String> dependencies,
    List<String> affectedComponents,
    List<String> referencedApis,
    List<String> tags,
    String? author,
    Map<String, dynamic>? metadata,
    String? documentId,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$KnowledgeRecordCopyWithImpl<$Res, $Val extends KnowledgeRecord>
    implements $KnowledgeRecordCopyWith<$Res> {
  _$KnowledgeRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KnowledgeRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? summary = null,
    Object? sourceType = null,
    Object? embeddingStatus = null,
    Object? confidence = freezed,
    Object? engineeringReasoning = freezed,
    Object? technicalDecisions = null,
    Object? businessContext = freezed,
    Object? risks = null,
    Object? breakingChanges = null,
    Object? dependencies = null,
    Object? affectedComponents = null,
    Object? referencedApis = null,
    Object? tags = null,
    Object? author = freezed,
    Object? metadata = freezed,
    Object? documentId = freezed,
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
            summary:
                null == summary
                    ? _value.summary
                    : summary // ignore: cast_nullable_to_non_nullable
                        as String,
            sourceType:
                null == sourceType
                    ? _value.sourceType
                    : sourceType // ignore: cast_nullable_to_non_nullable
                        as String,
            embeddingStatus:
                null == embeddingStatus
                    ? _value.embeddingStatus
                    : embeddingStatus // ignore: cast_nullable_to_non_nullable
                        as String,
            confidence:
                freezed == confidence
                    ? _value.confidence
                    : confidence // ignore: cast_nullable_to_non_nullable
                        as dynamic,
            engineeringReasoning:
                freezed == engineeringReasoning
                    ? _value.engineeringReasoning
                    : engineeringReasoning // ignore: cast_nullable_to_non_nullable
                        as String?,
            technicalDecisions:
                null == technicalDecisions
                    ? _value.technicalDecisions
                    : technicalDecisions // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            businessContext:
                freezed == businessContext
                    ? _value.businessContext
                    : businessContext // ignore: cast_nullable_to_non_nullable
                        as String?,
            risks:
                null == risks
                    ? _value.risks
                    : risks // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            breakingChanges:
                null == breakingChanges
                    ? _value.breakingChanges
                    : breakingChanges // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            dependencies:
                null == dependencies
                    ? _value.dependencies
                    : dependencies // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            affectedComponents:
                null == affectedComponents
                    ? _value.affectedComponents
                    : affectedComponents // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            referencedApis:
                null == referencedApis
                    ? _value.referencedApis
                    : referencedApis // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            tags:
                null == tags
                    ? _value.tags
                    : tags // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            author:
                freezed == author
                    ? _value.author
                    : author // ignore: cast_nullable_to_non_nullable
                        as String?,
            metadata:
                freezed == metadata
                    ? _value.metadata
                    : metadata // ignore: cast_nullable_to_non_nullable
                        as Map<String, dynamic>?,
            documentId:
                freezed == documentId
                    ? _value.documentId
                    : documentId // ignore: cast_nullable_to_non_nullable
                        as String?,
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
abstract class _$$KnowledgeRecordImplCopyWith<$Res>
    implements $KnowledgeRecordCopyWith<$Res> {
  factory _$$KnowledgeRecordImplCopyWith(
    _$KnowledgeRecordImpl value,
    $Res Function(_$KnowledgeRecordImpl) then,
  ) = __$$KnowledgeRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '_id') String id,
    String title,
    String summary,
    String sourceType,
    String embeddingStatus,
    dynamic confidence,
    String? engineeringReasoning,
    List<String> technicalDecisions,
    String? businessContext,
    List<String> risks,
    List<String> breakingChanges,
    List<String> dependencies,
    List<String> affectedComponents,
    List<String> referencedApis,
    List<String> tags,
    String? author,
    Map<String, dynamic>? metadata,
    String? documentId,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$KnowledgeRecordImplCopyWithImpl<$Res>
    extends _$KnowledgeRecordCopyWithImpl<$Res, _$KnowledgeRecordImpl>
    implements _$$KnowledgeRecordImplCopyWith<$Res> {
  __$$KnowledgeRecordImplCopyWithImpl(
    _$KnowledgeRecordImpl _value,
    $Res Function(_$KnowledgeRecordImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of KnowledgeRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? summary = null,
    Object? sourceType = null,
    Object? embeddingStatus = null,
    Object? confidence = freezed,
    Object? engineeringReasoning = freezed,
    Object? technicalDecisions = null,
    Object? businessContext = freezed,
    Object? risks = null,
    Object? breakingChanges = null,
    Object? dependencies = null,
    Object? affectedComponents = null,
    Object? referencedApis = null,
    Object? tags = null,
    Object? author = freezed,
    Object? metadata = freezed,
    Object? documentId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$KnowledgeRecordImpl(
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
        summary:
            null == summary
                ? _value.summary
                : summary // ignore: cast_nullable_to_non_nullable
                    as String,
        sourceType:
            null == sourceType
                ? _value.sourceType
                : sourceType // ignore: cast_nullable_to_non_nullable
                    as String,
        embeddingStatus:
            null == embeddingStatus
                ? _value.embeddingStatus
                : embeddingStatus // ignore: cast_nullable_to_non_nullable
                    as String,
        confidence:
            freezed == confidence
                ? _value.confidence
                : confidence // ignore: cast_nullable_to_non_nullable
                    as dynamic,
        engineeringReasoning:
            freezed == engineeringReasoning
                ? _value.engineeringReasoning
                : engineeringReasoning // ignore: cast_nullable_to_non_nullable
                    as String?,
        technicalDecisions:
            null == technicalDecisions
                ? _value._technicalDecisions
                : technicalDecisions // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        businessContext:
            freezed == businessContext
                ? _value.businessContext
                : businessContext // ignore: cast_nullable_to_non_nullable
                    as String?,
        risks:
            null == risks
                ? _value._risks
                : risks // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        breakingChanges:
            null == breakingChanges
                ? _value._breakingChanges
                : breakingChanges // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        dependencies:
            null == dependencies
                ? _value._dependencies
                : dependencies // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        affectedComponents:
            null == affectedComponents
                ? _value._affectedComponents
                : affectedComponents // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        referencedApis:
            null == referencedApis
                ? _value._referencedApis
                : referencedApis // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        tags:
            null == tags
                ? _value._tags
                : tags // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        author:
            freezed == author
                ? _value.author
                : author // ignore: cast_nullable_to_non_nullable
                    as String?,
        metadata:
            freezed == metadata
                ? _value._metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                    as Map<String, dynamic>?,
        documentId:
            freezed == documentId
                ? _value.documentId
                : documentId // ignore: cast_nullable_to_non_nullable
                    as String?,
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
class _$KnowledgeRecordImpl implements _KnowledgeRecord {
  const _$KnowledgeRecordImpl({
    @JsonKey(name: '_id') required this.id,
    required this.title,
    required this.summary,
    required this.sourceType,
    required this.embeddingStatus,
    this.confidence,
    this.engineeringReasoning,
    final List<String> technicalDecisions = const [],
    this.businessContext,
    final List<String> risks = const [],
    final List<String> breakingChanges = const [],
    final List<String> dependencies = const [],
    final List<String> affectedComponents = const [],
    final List<String> referencedApis = const [],
    final List<String> tags = const [],
    this.author,
    final Map<String, dynamic>? metadata,
    this.documentId,
    required this.createdAt,
    required this.updatedAt,
  }) : _technicalDecisions = technicalDecisions,
       _risks = risks,
       _breakingChanges = breakingChanges,
       _dependencies = dependencies,
       _affectedComponents = affectedComponents,
       _referencedApis = referencedApis,
       _tags = tags,
       _metadata = metadata;

  factory _$KnowledgeRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$KnowledgeRecordImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String title;
  @override
  final String summary;
  @override
  final String sourceType;
  @override
  final String embeddingStatus;
  @override
  final dynamic confidence;
  @override
  final String? engineeringReasoning;
  final List<String> _technicalDecisions;
  @override
  @JsonKey()
  List<String> get technicalDecisions {
    if (_technicalDecisions is EqualUnmodifiableListView)
      return _technicalDecisions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_technicalDecisions);
  }

  @override
  final String? businessContext;
  final List<String> _risks;
  @override
  @JsonKey()
  List<String> get risks {
    if (_risks is EqualUnmodifiableListView) return _risks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_risks);
  }

  final List<String> _breakingChanges;
  @override
  @JsonKey()
  List<String> get breakingChanges {
    if (_breakingChanges is EqualUnmodifiableListView) return _breakingChanges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_breakingChanges);
  }

  final List<String> _dependencies;
  @override
  @JsonKey()
  List<String> get dependencies {
    if (_dependencies is EqualUnmodifiableListView) return _dependencies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dependencies);
  }

  final List<String> _affectedComponents;
  @override
  @JsonKey()
  List<String> get affectedComponents {
    if (_affectedComponents is EqualUnmodifiableListView)
      return _affectedComponents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_affectedComponents);
  }

  final List<String> _referencedApis;
  @override
  @JsonKey()
  List<String> get referencedApis {
    if (_referencedApis is EqualUnmodifiableListView) return _referencedApis;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_referencedApis);
  }

  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final String? author;
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
  final String? documentId;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'KnowledgeRecord(id: $id, title: $title, summary: $summary, sourceType: $sourceType, embeddingStatus: $embeddingStatus, confidence: $confidence, engineeringReasoning: $engineeringReasoning, technicalDecisions: $technicalDecisions, businessContext: $businessContext, risks: $risks, breakingChanges: $breakingChanges, dependencies: $dependencies, affectedComponents: $affectedComponents, referencedApis: $referencedApis, tags: $tags, author: $author, metadata: $metadata, documentId: $documentId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KnowledgeRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.sourceType, sourceType) ||
                other.sourceType == sourceType) &&
            (identical(other.embeddingStatus, embeddingStatus) ||
                other.embeddingStatus == embeddingStatus) &&
            const DeepCollectionEquality().equals(
              other.confidence,
              confidence,
            ) &&
            (identical(other.engineeringReasoning, engineeringReasoning) ||
                other.engineeringReasoning == engineeringReasoning) &&
            const DeepCollectionEquality().equals(
              other._technicalDecisions,
              _technicalDecisions,
            ) &&
            (identical(other.businessContext, businessContext) ||
                other.businessContext == businessContext) &&
            const DeepCollectionEquality().equals(other._risks, _risks) &&
            const DeepCollectionEquality().equals(
              other._breakingChanges,
              _breakingChanges,
            ) &&
            const DeepCollectionEquality().equals(
              other._dependencies,
              _dependencies,
            ) &&
            const DeepCollectionEquality().equals(
              other._affectedComponents,
              _affectedComponents,
            ) &&
            const DeepCollectionEquality().equals(
              other._referencedApis,
              _referencedApis,
            ) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.author, author) || other.author == author) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.documentId, documentId) ||
                other.documentId == documentId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    title,
    summary,
    sourceType,
    embeddingStatus,
    const DeepCollectionEquality().hash(confidence),
    engineeringReasoning,
    const DeepCollectionEquality().hash(_technicalDecisions),
    businessContext,
    const DeepCollectionEquality().hash(_risks),
    const DeepCollectionEquality().hash(_breakingChanges),
    const DeepCollectionEquality().hash(_dependencies),
    const DeepCollectionEquality().hash(_affectedComponents),
    const DeepCollectionEquality().hash(_referencedApis),
    const DeepCollectionEquality().hash(_tags),
    author,
    const DeepCollectionEquality().hash(_metadata),
    documentId,
    createdAt,
    updatedAt,
  ]);

  /// Create a copy of KnowledgeRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KnowledgeRecordImplCopyWith<_$KnowledgeRecordImpl> get copyWith =>
      __$$KnowledgeRecordImplCopyWithImpl<_$KnowledgeRecordImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$KnowledgeRecordImplToJson(this);
  }
}

abstract class _KnowledgeRecord implements KnowledgeRecord {
  const factory _KnowledgeRecord({
    @JsonKey(name: '_id') required final String id,
    required final String title,
    required final String summary,
    required final String sourceType,
    required final String embeddingStatus,
    final dynamic confidence,
    final String? engineeringReasoning,
    final List<String> technicalDecisions,
    final String? businessContext,
    final List<String> risks,
    final List<String> breakingChanges,
    final List<String> dependencies,
    final List<String> affectedComponents,
    final List<String> referencedApis,
    final List<String> tags,
    final String? author,
    final Map<String, dynamic>? metadata,
    final String? documentId,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$KnowledgeRecordImpl;

  factory _KnowledgeRecord.fromJson(Map<String, dynamic> json) =
      _$KnowledgeRecordImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  String get title;
  @override
  String get summary;
  @override
  String get sourceType;
  @override
  String get embeddingStatus;
  @override
  dynamic get confidence;
  @override
  String? get engineeringReasoning;
  @override
  List<String> get technicalDecisions;
  @override
  String? get businessContext;
  @override
  List<String> get risks;
  @override
  List<String> get breakingChanges;
  @override
  List<String> get dependencies;
  @override
  List<String> get affectedComponents;
  @override
  List<String> get referencedApis;
  @override
  List<String> get tags;
  @override
  String? get author;
  @override
  Map<String, dynamic>? get metadata;
  @override
  String? get documentId;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of KnowledgeRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KnowledgeRecordImplCopyWith<_$KnowledgeRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
