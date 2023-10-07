import 'package:dispatch/domain/model/user_model.dart';

const _isLightThemeKey = 'is_light_theme_key';

const _userKey = 'user_key';

const _accessTokenKey = 'access_token_key';

class CacheStorage {
  static final CacheStorage _instance = CacheStorage._internal();

  CacheStorage._internal();

  factory CacheStorage() => _instance;

  final Map<String, dynamic> _cache = <String, dynamic>{};

  bool? get isLightTheme => _cache[_isLightThemeKey];

  set isLightTheme(bool? value) => _cache[_isLightThemeKey] = value;

  UserModel? readUser() => _cache[_userKey];

  writeUser(UserModel? value) => _cache[_userKey] = value;

  String? readAccessToken() => _cache[_accessTokenKey];

  writeAccessToken(String? value) => _cache[_accessTokenKey] = value;
}
