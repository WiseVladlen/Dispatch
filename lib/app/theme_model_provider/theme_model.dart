import 'package:dispatch/data/cache_storage.dart';
import 'package:dispatch/data/preference_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeModel with ChangeNotifier {
  bool _isLightTheme;

  ThemeModel() : _isLightTheme = CacheStorage().isLightTheme ?? true;

  bool get isLightTheme => _isLightTheme;

  void onThemeSwitched() async {
    _isLightTheme = !isLightTheme;

    Future.microtask(() async => await PreferenceStorage().setIsLightTheme(isLightTheme));

    notifyListeners();
  }
}

class S extends ValueNotifier<bool> {
  S(super.value);
}
