import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/providers/active_org_provider.dart';

class ProjectMember {
  final String id;
  final String name;
  final String email;
  final String projectRole;

  ProjectMember({
    required this.id,
    required this.name,
    required this.email,
    required this.projectRole,
  });

  factory ProjectMember.fromJson(Map<String, dynamic> json) {
    return ProjectMember(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      projectRole: json['projectRole'] as String? ?? 'VIEWER',
    );
  }
}

final projectMembersProvider = FutureProvider.family<List<ProjectMember>, String>((ref, projectId) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get('/projects/$projectId/members');
  final List<dynamic> data = response.data['data'];
  return data.map((json) => ProjectMember.fromJson(json)).toList();
});

final addProjectMemberProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return (String projectId, String email, String role) async {
    await dio.post('/projects/$projectId/members', data: {
      'email': email,
      'role': role,
    });
    ref.invalidate(projectMembersProvider(projectId));
  };
});

final updateProjectMemberRoleProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return (String projectId, String userId, String role) async {
    await dio.patch('/projects/$projectId/members/$userId/role', data: {
      'role': role,
    });
    ref.invalidate(projectMembersProvider(projectId));
  };
});

final removeProjectMemberProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return (String projectId, String userId) async {
    await dio.delete('/projects/$projectId/members/$userId');
    ref.invalidate(projectMembersProvider(projectId));
  };
});
