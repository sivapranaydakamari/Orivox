import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/secure_storage.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

class ActiveOrgNotifier extends StateNotifier<String?> {
  final SecureStorageService _storage;

  ActiveOrgNotifier(this._storage) : super(null) {
    _init();
  }

  Future<void> _init() async {
    final orgId = await _storage.read('active_org_id');
    if (orgId != null) {
      state = orgId;
    }
  }

  Future<void> setActiveOrg(String orgId) async {
    await _storage.write('active_org_id', orgId);
    state = orgId;
  }

  Future<void> clear() async {
    await _storage.delete('active_org_id');
    state = null;
  }
}

final activeOrgProvider = StateNotifierProvider<ActiveOrgNotifier, String?>((ref) {
  final storage = ref.watch(secureStorageProvider);
  final notifier = ActiveOrgNotifier(storage);
  
  ref.listen(authNotifierProvider, (previous, next) {
    next.maybeWhen(
      unauthenticated: () => notifier.clear(),
      orElse: () {},
    );
  });
  
  return notifier;
});
