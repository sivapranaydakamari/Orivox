import 'package:dio/dio.dart';
import '../models/organization_model.dart';

class OrganizationRemoteDataSource {
  final Dio _dio;

  OrganizationRemoteDataSource(this._dio);

  Future<List<OrganizationModel>> getAllOrganizations() async {
    final response = await _dio.get('/organizations');
    return (response.data['data'] as List)
        .map((e) => OrganizationModel.fromJson(e))
        .toList();
  }

  Future<OrganizationModel> getOrganizationById(String id) async {
    final response = await _dio.get('/organizations/$id');
    return OrganizationModel.fromJson(response.data['data']);
  }

  Future<OrganizationModel> createOrganization(String name, String slug) async {
    final response = await _dio.post(
      '/organizations',
      data: {'name': name, 'slug': slug},
    );
    return OrganizationModel.fromJson(response.data['data']);
  }

  Future<OrganizationModel> updateOrganization(String id, String name) async {
    final response = await _dio.patch(
      '/organizations/$id',
      data: {'name': name},
    );
    return OrganizationModel.fromJson(response.data['data']);
  }

  Future<void> deleteOrganization(String id) async {
    await _dio.delete('/organizations/$id');
  }
}
