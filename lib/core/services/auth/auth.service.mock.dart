import 'dart:async';
import 'dart:math';

import 'package:chat/core/models/auth.user.dart';
import 'dart:io';

import 'package:chat/core/services/auth/auth.service.dart';

class AuthServiceMock implements AuthService {
  static const _defaultUser = AuthUser(
    id: '456',
    name: 'Antonio',
    email: 'antonio@user.com.br',
    imageURL: 'assets/images/avatar.png',
  );

  static final Map<String, AuthUser> _users = {
    _defaultUser.email: _defaultUser,
  };
  static AuthUser? _currentUser;
  static MultiStreamController<AuthUser?>? _controller;
  static final _userStream = Stream<AuthUser?>.multi((controller) {
    _controller = controller;
    _updateUser(_defaultUser);
  });

  @override
  AuthUser? get currentUser {
    return _currentUser;
  }

  @override
  Stream<AuthUser?> get userChanges {
    return _userStream;
  }

  @override
  Future<void> login(String email, String password) async {
    _updateUser(_users[email]);
  }

  @override
  Future<void> logout() async {
    _updateUser(null);
  }

  @override
  Future<void> signup(
    String name,
    String email,
    String password,
    File? image,
  ) async {
    final newUser = AuthUser(
      id: Random().nextDouble().toString(),
      name: name,
      email: email,
      imageURL: image?.path ?? 'assets/images/avatar.png',
    );

    _users.putIfAbsent(email, () => newUser);
    _updateUser(newUser);
  }

  static void _updateUser(AuthUser? authUser) {
    _currentUser = authUser;
    _controller?.add(_currentUser);
  }
}
