import 'package:freezed_annotation/freezed_annotation.dart';

part 'repository_dto.freezed.dart';
part 'repository_dto.g.dart';

@freezed
class CreateRepositoryDto with _$CreateRepositoryDto {
  const factory CreateRepositoryDto({
    required String projectId,
    required String repositoryUrl,
    required String repositoryName,
    @Default('GITHUB') String provider,
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
