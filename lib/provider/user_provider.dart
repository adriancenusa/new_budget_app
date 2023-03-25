import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  String? _name;
  bool _setupCompleted = false;

  User? get user => _user;

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  set setupCompleted(bool value) {
    _setupCompleted = value;
    notifyListeners();
  }

  set name(String value) {
    _name = value;
    notifyListeners();
  }
}
