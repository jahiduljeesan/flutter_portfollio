import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden in main()');
});

class AuthNotifier extends Notifier<bool> {
  static const _authKey = 'is_authenticated';

  @override
  bool build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getBool(_authKey) ?? false;
  }

  void login() {
    state = true;
    ref.read(sharedPreferencesProvider).setBool(_authKey, true);
  }

  void logout() {
    state = false;
    ref.read(sharedPreferencesProvider).setBool(_authKey, false);
  }
}

final authProvider = NotifierProvider<AuthNotifier, bool>(AuthNotifier.new);
