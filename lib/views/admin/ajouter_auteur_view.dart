import 'package:flutter/material.dart';
import 'package:my_library/models/auteur.dart';
import 'package:my_library/services/auteur_services.dart';

class AjouterAuteurView extends StatefulWidget {
  @override
  _AjouterAuteurViewState createState() => _AjouterAuteurViewState();
}

class _AjouterAuteurViewState extends State<AjouterAuteurView> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _imageController = TextEditingController();
  final _dateNaissanceController = TextEditingController();
  final _biographieController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un auteur')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _prenomController,
                decoration: const InputDecoration(labelText: 'Prénom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un prénom';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: 'Image'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer l\'URL de l\'image';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateNaissanceController,
                decoration: const InputDecoration(labelText: 'Date de naissance'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une date de naissance';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _biographieController,
                decoration: const InputDecoration(labelText: 'Biographie'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une biographie';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final auteur = Auteur(
                      id: '',
                      nom: _nomController.text,
                      prenom: _prenomController.text,
                      image: _imageController.text,
                      dateNaissance: DateTime.parse(_dateNaissanceController.text),
                      biographie: _biographieController.text,
                    );
                    AuteurServices().addAuteur(auteur);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Ajouter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
