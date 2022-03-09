import 'dart:async';

import 'package:chat/core/models/auth.user.dart';
import 'dart:io';

import 'package:chat/core/services/auth/auth.service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthServiceFirebase implements AuthService {
  static final DEFAULT_IMAGE = 'assets/images/avatar.png';

  static AuthUser? _currentUser;

  static final _userStream = Stream<AuthUser?>.multi((controller) async {
    final authChanges = FirebaseAuth.instance.authStateChanges();
    await for (final user in authChanges) {
      _currentUser = user == null ? null : _toAuthUser(user);
      controller.add(_currentUser);
    }
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
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> logout() async {
    FirebaseAuth.instance.signOut();
  }

  @override
  Future<void> signup(
    String name,
    String email,
    String password,
    File? image,
  ) async {
    final auth = FirebaseAuth.instance;
    UserCredential credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credential.user == null) return;

    final imageName = '${credential.user!.uid}.jpg';
    final imageUrl = await _uploadUserImage(image, imageName);

    await credential.user?.updateDisplayName(name);
    await credential.user?.updatePhotoURL(imageUrl);
    _currentUser = _toAuthUser(credential.user!, name, imageUrl);
    await _saveAuthUser(_currentUser!);
  }

  Future<String> _uploadUserImage(File? image, String imageName) async {
    if (image == null) return DEFAULT_IMAGE;

    final storage = FirebaseStorage.instance;
    final imageRef = storage.ref().child('user_images').child(imageName);

    await imageRef.putFile(image).whenComplete(() {});
    return await imageRef.getDownloadURL();
  }

  Future<void> _saveAuthUser(AuthUser authUser) {
    final store = FirebaseFirestore.instance;
    final docRef = store.collection('users').doc(authUser.id);

    return docRef.set({
      'name': authUser.name,
      'email': authUser.email,
      'imageURL': authUser.imageURL,
    });
  }

  static AuthUser _toAuthUser(User user, [String? name, String? imageURL]) {
    return AuthUser(
      id: user.uid,
      name: name ?? user.displayName ?? user.email!.split('#')[0],
      email: user.email!,
      imageURL: imageURL ?? user.photoURL ?? DEFAULT_IMAGE,
    );
  }
}
