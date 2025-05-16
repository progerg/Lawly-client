import 'package:shared_preferences/shared_preferences.dart';

class InitLocalDataSource {
  static const _isFirstLaunchKey = 'isFirstLaunch';

  // static const _is

  final SharedPreferences _prefs;

  InitLocalDataSource(this._prefs);

  bool get isFirstLaunch => _prefs.getBool(_isFirstLaunchKey) ?? true;

  Future<void> setFirstLaunch(bool value) async {
    await _prefs.setBool(_isFirstLaunchKey, value);
  }
}
