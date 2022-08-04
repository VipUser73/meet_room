import 'dart:convert';
import 'package:flutter/services.dart';

class UserRepository {
  Map<String, dynamic> _loginAndPassword = {};

  Future<bool> checkLogin(String _username, String _password) async {
    if (_loginAndPassword.isEmpty) {
      await readLogins();
    }
    bool check = false;
    _loginAndPassword.forEach((key, value) {
      if (key.toLowerCase() == _username.toLowerCase() &&
          value.toString() == _password) {
        check = true;
      }
    });
    return check;
  }

  Future<Map<String, dynamic>> readLogins() async {
    final _loadedData = await rootBundle.loadString('assets/login.json');
    _loginAndPassword = json.decode(_loadedData);
    return _loginAndPassword;
  }
}
