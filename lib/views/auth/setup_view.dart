import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_library/models/utilisateur.dart';
import 'package:my_library/services/utilisateur_services.dart';
import 'package:intl/intl.dart';

import '../../routes.dart';

class SetupView extends StatefulWidget {
  @override
  _SetupViewState createState() => _SetupViewState();
}

class _SetupViewState extends State<SetupView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _prenomController = TextEditingController();
  final _dateNaissanceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulaire utilisateur'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre nom';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Nom',
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _prenomController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre prénom';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Prénom',
                ),
              ),
              const SizedBox(height: 16.0),
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
              InkWell(
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  ).then((pickedDate) {
                    if (pickedDate != null) {
                      _dateNaissanceController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                    }
                  });
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _dateNaissanceController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre date de naissance';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Date de naissance',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    try {
                      final User? user = FirebaseAuth.instance.currentUser;
                      final String userId = user?.uid ?? '';
                      final Map<String, dynamic> userData = {
                        'id': userId,
                        'nom': _nameController.text,
                        'prenom': _prenomController.text,
                        'email': _emailController.text,
                        'date_naissance': _dateNaissanceController.text,
                        'dons': [],
                        'est_admin': false,
                      };
                      final Utilisateur utilisateur = Utilisateur.fromMap(userData);
                      await UtilisateurServices().addUtilisateur(utilisateur);
                      Routes.router.navigateTo(context, '/login');
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erreur d\'enregistrement : $e')),
                      );
                    }
                  }
                },
                child: const Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}