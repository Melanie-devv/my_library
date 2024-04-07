import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../routes.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<UserCredential?> _signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      return null;
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    if (userCredential.user != null) {
      if (userCredential.additionalUserInfo?.isNewUser == true) {
        Routes.router.navigateTo(context, '/welcome');
      } else {
        Routes.router.navigateTo(context, '/profil');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion'),
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
          _buildGoogleSignInButton(),
          _buildEmailField(),
          const SizedBox(height: 16.0),
          _buildPasswordField(),
          const SizedBox(height: 16.0),
          _buildLoginButton(),
          _buildResetPasswordButton(),
          _buildRegisterButton(),
        ],
      ),
    );
  }

  Widget _buildGoogleSignInButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _signInWithGoogle,
      child: _isLoading ? const CircularProgressIndicator() : const Text('Connexion avec Google'),
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
        return null;
      },
      decoration: const InputDecoration(
        labelText: 'Mot de passe',
      ),
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _login,
      child: _isLoading ? const CircularProgressIndicator() : const Text('Connexion'),
    );
  }

  Widget _buildResetPasswordButton() {
    return TextButton(
      onPressed: _isLoading ? null : _resetPassword,
      child: const Text('Mot de passe oublié ?'),
    );
  }

  Widget _buildRegisterButton() {
    return TextButton(
      child: const Text('Vous n\'avez pas encore de compte ? Inscription'),
      onPressed: () {
        Routes.router.navigateTo(context, '/register');
      },
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      try {
        Routes.router.navigateTo(context, '/home');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de connexion : $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _resetPassword() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer votre adresse e-mail')),
      );
    } else {
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Un e-mail de réinitialisation du mot de passe a été envoyé à ${_emailController.text}')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'envoi de l\'e-mail de réinitialisation du mot de passe : $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}