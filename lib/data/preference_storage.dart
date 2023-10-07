import 'package:shared_preferences/shared_preferences.dart';

const _isLightThemeKey = 'is_light_theme_key';

class PreferenceStorage {
  static final PreferenceStorage _instance = PreferenceStorage._internal();

  PreferenceStorage._internal();

  factory PreferenceStorage() => _instance;

  SharedPreferences? _nullablePreferences;

  Future<SharedPreferences> get _preferences async {
    return _nullablePreferences ??= await SharedPreferences.getInstance();
  }

  Future<bool?> get isLightTheme async {
    return (await _preferences).getBool(_isLightThemeKey);
  }

  Future<void> setIsLightTheme(bool value) async {
    (await _preferences).setBool(_isLightThemeKey, value);
  }
}
