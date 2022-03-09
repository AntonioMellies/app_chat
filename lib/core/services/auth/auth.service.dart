import 'dart:io';

import 'package:chat/core/models/auth.user.dart';
import 'package:chat/core/services/auth/auth.service.firebase.dart';
//import 'package:chat/core/services/auth/auth.service.mock.dart';

abstract class AuthService {
  AuthUser? get currentUser;
  Stream<AuthUser?> get userChanges;

  Future<void> signup(
    String name,
    String email,
    String password,
    File? image,
  );
  Future<void> login(String email, String password);
  Future<void> logout();

  factory AuthService() {
    // return AuthServiceMock();
    return AuthServiceFirebase();
  }
}
