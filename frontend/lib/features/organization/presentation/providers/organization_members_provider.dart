import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';

class OrgMember {
  final String id;
  final String name;
  final String email;
  final String orgRole;
  final List<dynamic> projectRoles;

  OrgMember({
    required this.id,
    required this.name,
    required this.email,
    required this.orgRole,
    required this.projectRoles,
  });

  factory OrgMember.fromJson(Map<String, dynamic> json) {
    return OrgMember(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      orgRole: json['orgRole'] as String,
      projectRoles: json['projectRoles'] as List<dynamic>? ?? [],
    );
  }
}

final organizationMembersProvider = FutureProvider.family<List<OrgMember>, String>((ref, orgId) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get('/organizations/$orgId/members');
  final List<dynamic> data = response.data['data'];
  return data.map((json) => OrgMember.fromJson(json)).toList();
});

final addOrganizationMemberProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return (String orgId, String email, String role) async {
    await dio.post('/organizations/$orgId/members', data: {
      'email': email,
      'role': role,
    });
    ref.invalidate(organizationMembersProvider(orgId));
  };
});

final updateOrganizationMemberRoleProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return (String orgId, String userId, String role) async {
    await dio.patch('/organizations/$orgId/members/$userId/role', data: {
      'role': role,
    });
    ref.invalidate(organizationMembersProvider(orgId));
  };
});

final removeOrganizationMemberProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return (String orgId, String userId) async {
    await dio.delete('/organizations/$orgId/members/$userId');
    ref.invalidate(organizationMembersProvider(orgId));
  };
});

