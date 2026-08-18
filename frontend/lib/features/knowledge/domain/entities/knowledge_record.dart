import 'package:freezed_annotation/freezed_annotation.dart';

part 'knowledge_record.freezed.dart';
part 'knowledge_record.g.dart';

@freezed
class KnowledgeRecord with _$KnowledgeRecord {
  const factory KnowledgeRecord({
    @JsonKey(name: '_id') required String id,
    required String title,
    required String summary,
    required String sourceType,
    required String embeddingStatus,
    dynamic confidence,
    String? engineeringReasoning,
    @Default([]) List<String> technicalDecisions,
    String? businessContext,
    @Default([]) List<String> risks,
    @Default([]) List<String> breakingChanges,
    @Default([]) List<String> dependencies,
    @Default([]) List<String> affectedComponents,
    @Default([]) List<String> referencedApis,
    @Default([]) List<String> tags,
    String? author,
    Map<String, dynamic>? metadata,
    String? documentId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _KnowledgeRecord;

  factory KnowledgeRecord.fromJson(Map<String, dynamic> json) => _$KnowledgeRecordFromJson(json);
}
