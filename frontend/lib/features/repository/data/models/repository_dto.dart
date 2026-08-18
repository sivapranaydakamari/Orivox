import 'package:freezed_annotation/freezed_annotation.dart';

part 'repository_dto.freezed.dart';
part 'repository_dto.g.dart';

@freezed
class SourceConfigurationDto with _$SourceConfigurationDto {
  const factory SourceConfigurationDto({
    @Default(true) bool code,
    @Default(true) bool docs,
    @Default(false) bool prs,
  }) = _SourceConfigurationDto;

  factory SourceConfigurationDto.fromJson(Map<String, dynamic> json) => _$SourceConfigurationDtoFromJson(json);
}

@freezed
class CreateRepositoryDto with _$CreateRepositoryDto {
  const factory CreateRepositoryDto({
    required String projectId,
    required String repositoryName,
    String? repositoryUrl,
    @Default('GITHUB') String provider,
    String? githubInstallationId,
    int? githubRepositoryId,
    String? githubRepositoryFullName,
    SourceConfigurationDto? sourceConfiguration,
  }) = _CreateRepositoryDto;

  factory CreateRepositoryDto.fromJson(Map<String, dynamic> json) => _$CreateRepositoryDtoFromJson(json);
}

@freezed
class UpdateRepositoryDto with _$UpdateRepositoryDto {
  const factory UpdateRepositoryDto({
    bool? isActive,
  }) = _UpdateRepositoryDto;

  factory UpdateRepositoryDto.fromJson(Map<String, dynamic> json) => _$UpdateRepositoryDtoFromJson(json);
}
