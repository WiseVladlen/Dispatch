import 'package:flutter/material.dart';

class AuthenticationPageModel with ChangeNotifier {
  bool _isLoginPage = true;

  bool get isLoginPage => _isLoginPage;

  void onNavigateToLoginPage() {
    _isLoginPage = true;
    notifyListeners();
  }

  void onNavigateToSignUpPage() {
    _isLoginPage = false;
    notifyListeners();
  }
}
