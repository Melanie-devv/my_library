import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordView extends StatefulWidget {
  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mot de passe oublié'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
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
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _isLoading ? null : _sendResetEmail, // Désactive le bouton pendant le chargement
                child: _isLoading ? CircularProgressIndicator() : const Text('Envoyer l\'e-mail de réinitialisation'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendResetEmail() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _emailController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('E-mail de réinitialisation envoyé')),
        );
      } catch (e) {
        String message;
        if (e is FirebaseAuthException) {
          if (e.code == 'user-not-found') {
            message = 'Aucun utilisateur trouvé avec cet e-mail';
          } else if (e.code == 'invalid-email') {
            message = 'Le format de l\'e-mail est incorrect';
          } else {
            message = 'Erreur d\'envoi de l\'e-mail : $e';
          }
        } else {
          message = 'Erreur d\'envoi de l\'e-mail : $e';
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