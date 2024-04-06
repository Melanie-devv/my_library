import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_library/models/utilisateur.dart';
import 'package:my_library/services/utilisateur_services.dart';

class ProfilInformationsView extends StatefulWidget {
  @override
  _ProfilInformationsViewState createState() => _ProfilInformationsViewState();
}

class _ProfilInformationsViewState extends State<ProfilInformationsView> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  DateTime _dateNaissance = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    setState(() {
      _isLoading = true;
    });
    final utilisateur = await UtilisateurServices().getUserById((await UtilisateurServices().getCurrentUid())!);
    setState(() {
      _nomController.text = utilisateur!.nom;
      _prenomController.text = utilisateur.prenom;
      _emailController.text = utilisateur.email;
      _dateNaissance = utilisateur.dateNaissance.toDate();
      _isLoading = false;
    });
  }

  Future<void> _updateUserInfo() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      final utilisateur = Utilisateur(
        id: (await UtilisateurServices().getCurrentUid())!,
        nom: _nomController.text,
        prenom: _prenomController.text,
        email: _emailController.text,
        dateNaissance: Timestamp.fromDate(_dateNaissance),
      );
      await UtilisateurServices().updateUtilisateur(utilisateur);
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Informations mises à jour avec succès')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes informations'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nomController,
                decoration: InputDecoration(labelText: 'Nom'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer votre nom';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _prenomController,
                decoration: InputDecoration(labelText: 'Prénom'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer votre prénom';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer votre email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ListTile(
                title: Text('Date de naissance'),
                subtitle: Text(DateFormat.yMMMMd().format(_dateNaissance)),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _dateNaissance,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null && picked != _dateNaissance) {
                      setState(() {
                        _dateNaissance = picked;
                      });
                    }
                  },
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _isLoading ? null : _updateUserInfo,
                child: Text('Enregistrer les modifications'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
