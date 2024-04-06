import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_library/models/utilisateur.dart';
import 'package:my_library/services/utilisateur_services.dart';
import '../../routes.dart';

class SetupView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _prenomController = TextEditingController();
  final _dateNaissanceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulaire utilisateur')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_nameController, 'Nom'),
              _buildTextField(_prenomController, 'Prénom'),
              _buildTextField(_emailController, 'Adresse e-mail'),
              _buildDateField(context),
              ElevatedButton(onPressed: () => _register(context), child: const Text('Enregistrer')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      validator: (value) => value == null || value.isEmpty ? 'Veuillez entrer votre $label' : null,
      decoration: InputDecoration(labelText: label),
    );
  }

  Widget _buildDateField(BuildContext context) {
    return InkWell(
      onTap: () => showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
      ).then((pickedDate) {
        if (pickedDate != null) {
          _dateNaissanceController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
        }
      }),
      child: AbsorbPointer(
        child: _buildTextField(_dateNaissanceController, 'Date de naissance'),
      ),
    );
  }

  Future<void> _register(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final User? user = FirebaseAuth.instance.currentUser;
        final String userId = user?.uid ?? '';
        final DateTime dateNaissance = DateFormat('yyyy-MM-dd').parse(_dateNaissanceController.text);
        final DateTime eighteenYearsAgo = DateTime.now().subtract(const Duration(days: 18 * 365));
        if (dateNaissance.isAfter(eighteenYearsAgo)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vous devez avoir au moins 18 ans pour vous inscrire.')),
          );
          return;
        }
        final Utilisateur utilisateur = Utilisateur.fromMap({
          'id': userId,
          'nom': _nameController.text,
          'prenom': _prenomController.text,
          'email': _emailController.text,
          'date_naissance': Timestamp.fromDate(dateNaissance),
          'dons': [],
          'est_admin': false,
        });
        await UtilisateurServices().addUtilisateur(utilisateur);
        Routes.router.navigateTo(context, '/login');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur d\'enregistrement : $e')));
      }
    }
  }
}