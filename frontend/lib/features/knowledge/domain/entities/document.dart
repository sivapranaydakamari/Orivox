import 'package:freezed_annotation/freezed_annotation.dart';

part 'document.freezed.dart';
part 'document.g.dart';

@freezed
class AppDocument with _$AppDocument {
  const factory AppDocument({
    @JsonKey(name: '_id') required String id,
    required String title,
    required String rawContent,
    required String sourceType,
    required String status,
    Map<String, dynamic>? metadata,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AppDocument;

  factory AppDocument.fromJson(Map<String, dynamic> json) => _$AppDocumentFromJson(json);
}
