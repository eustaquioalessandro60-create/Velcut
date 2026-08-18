import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  // Estado global simples — expanda conforme necessário
  String _userName = '';
  bool get loggedIn => _userName.isNotEmpty;
  String get userName => _userName;

  void login(String name) {
    _userName = name;
    notifyListeners();
  }

  void logout() {
    _userName = '';
    notifyListeners();
  }
}
