import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../routes.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscription'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildEmailField(),
          const SizedBox(height: 16.0),
          _buildPasswordField(),
          _buildConfirmPasswordField(),
          const SizedBox(height: 16.0),
          _buildRegisterButton(),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez entrer votre adresse e-mail';
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: 'Adresse e-mail',
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez entrer votre mot de passe';
        }
        if (value.length < 8) {
          return 'Le mot de passe doit contenir au moins 8 caractères';
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: 'Mot de passe',
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez confirmer votre mot de passe';
        }
        if (value != _passwordController.text) {
          return 'Les mots de passe ne correspondent pas';
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: 'Confirmer le mot de passe',
      ),
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _register,
      child: _isLoading ? const CircularProgressIndicator() : const Text('Inscription'),
    );
  }

  Future<void> _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      try {
        final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        final User? user = userCredential.user;
        if (user != null) {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );
          Routes.router.navigateTo(context, '/welcome');
        }
      } catch (e) {
        String message;
        if (e is FirebaseAuthException) {
          if (e.code == 'email-already-in-use') {
            message = 'L\'adresse e-mail est déjà utilisée';
          } else if (e.code == 'weak-password') {
            message = 'Le mot de passe est trop faible';
          } else {
            message = 'Erreur d\'inscription : $e';
          }
        } else {
          message = 'Erreur d\'inscription : $e';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}