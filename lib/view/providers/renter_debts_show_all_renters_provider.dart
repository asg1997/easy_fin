import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _prefsKey = 'renter_debts_show_all_renters';

final renterDebtsShowAllRentersProvider =
    AsyncNotifierProvider<RenterDebtsShowAllRentersNotifier, bool>(
  RenterDebtsShowAllRentersNotifier.new,
);

class RenterDebtsShowAllRentersNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefsKey) ?? false;
  }

  Future<void> setVisible({required bool visible}) async {
    state = AsyncData(visible);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, visible);
  }
}
