import 'package:chat/components/auth.form.dart';
import 'package:chat/core/models/auth.form.data.dart';
import 'package:chat/core/services/auth/auth.service.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLoading = false;

  Future<void> _handleSubmit(AuthFormData authFormData) async {
    try {
      setState(() => _isLoading = true);
      if (authFormData.isLogin) {
        await AuthService().login(authFormData.email, authFormData.password);
      } else {
        await AuthService().signup(authFormData.name, authFormData.email, authFormData.password, authFormData.image);
      }
    } catch (error) {
      // Tratar error
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: AuthForm(onSubmit: _handleSubmit),
            ),
          ),
          if (_isLoading)
            Container(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.5),
              ),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
        ],
      ),
    );
  }
}
