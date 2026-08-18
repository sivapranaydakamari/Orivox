import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/organization.dart';

part 'organization_model.freezed.dart';
part 'organization_model.g.dart';

@freezed
class OrganizationModel with _$OrganizationModel {
  const OrganizationModel._();
  const factory OrganizationModel({
    @JsonKey(name: '_id') required String id,
    required String name,
    required String slug,
  }) = _OrganizationModel;

  factory OrganizationModel.fromJson(Map<String, dynamic> json) =>
      _$OrganizationModelFromJson(json);

  Organization toEntity() {
    return Organization(
      id: id,
      name: name,
      slug: slug,
    );
  }
}
