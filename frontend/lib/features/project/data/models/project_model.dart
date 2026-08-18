import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/project.dart';

part 'project_model.freezed.dart';
part 'project_model.g.dart';

@freezed
class ProjectModel with _$ProjectModel {
  const ProjectModel._();
  const factory ProjectModel({
    @JsonKey(name: '_id') required String id,
    required String name,
    String? description,
    required String organizationId,
  }) = _ProjectModel;

  factory ProjectModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectModelFromJson(json);

  Project toEntity() {
    return Project(
      id: id,
      name: name,
      description: description,
      organizationId: organizationId,
    );
  }
}
