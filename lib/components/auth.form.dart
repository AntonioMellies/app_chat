import 'dart:io';

import 'package:chat/components/user.image.picker.dart';
import 'package:chat/core/models/auth.form.data.dart';
import 'package:chat/utils/validators/general/validator_email.dart';
import 'package:chat/utils/validators/general/validator_password_strong%20copy.dart';
import 'package:chat/utils/validators/general/validator_required.dart';
import 'package:chat/utils/validators/text/validator_min_length.dart';
import 'package:chat/utils/validators/validator_builder.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(AuthFormData) onSubmit;

  const AuthForm({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _authFormData = AuthFormData();

  void _handleImagePick(File image) {
    _authFormData.image = image;
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Theme.of(context).errorColor,
    ));
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    if (_authFormData.image == null && _authFormData.isSignup) {
      return _showError('Imagem não encontrada');
    }

    widget.onSubmit(_authFormData);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 15.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_authFormData.isSignup) UserImagePicker(onImagePick: _handleImagePick),
              if (_authFormData.isSignup)
                TextFormField(
                  key: const ValueKey('name'),
                  initialValue: _authFormData.name,
                  onChanged: (value) => _authFormData.name = value,
                  decoration: const InputDecoration(labelText: 'Nome'),
                  validator: (value) => ValidatorBuilder(value).addValidators([
                    ValidatorRequired(),
                    ValidatorMinLength(5),
                  ]).build(),
                ),
              TextFormField(
                key: const ValueKey('email'),
                initialValue: _authFormData.email,
                onChanged: (value) => _authFormData.email = value,
                decoration: const InputDecoration(labelText: 'E-mail'),
                validator: (value) => ValidatorBuilder(value).addValidators([
                  ValidatorRequired(),
                  ValidatorEmail(),
                ]).build(),
              ),
              TextFormField(
                key: const ValueKey('password'),
                initialValue: _authFormData.password,
                onChanged: (value) => _authFormData.password = value,
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) => ValidatorBuilder(value).addValidators([
                  ValidatorRequired(),
                  ValidatorPasswordStrong(6),
                ]).build(),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _submit,
                child: Text(_authFormData.isLogin ? 'Entrar' : 'Cadastrar'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _authFormData.toggleAuthMode();
                  });
                },
                child: Text(_authFormData.isLogin ? 'Criar uma nova conta ?' : 'Já possui conta ?'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
