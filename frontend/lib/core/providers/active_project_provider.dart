import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'active_org_provider.dart';

class ActiveProjectNotifier extends StateNotifier<String?> {
  ActiveProjectNotifier(this.ref) : super(null) {
    ref.listen<String?>(activeOrgProvider, (previous, next) {
      if (previous != next) {
        state = null;
      }
    });
  }
  
  final Ref ref;
  
  void setProject(String? projectId) {
    state = projectId;
  }
}

final activeProjectProvider = StateNotifierProvider<ActiveProjectNotifier, String?>((ref) {
  return ActiveProjectNotifier(ref);
});
