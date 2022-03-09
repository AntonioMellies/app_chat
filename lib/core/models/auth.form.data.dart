import 'dart:io';

import 'package:chat/core/models/enums/auth.mode.dart';

class AuthFormData {
  String name = 'Antonio Neto';
  String email = 'a@a.com.br';
  String password = '123456';
  File? image;
  AuthMode _mode = AuthMode.Login;

  bool get isLogin {
    return _mode == AuthMode.Login;
  }

  bool get isSignup {
    return _mode == AuthMode.Signup;
  }

  void toggleAuthMode() {
    _mode = isLogin ? AuthMode.Signup : AuthMode.Login;
  }
}
