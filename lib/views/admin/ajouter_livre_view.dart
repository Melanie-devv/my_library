import 'package:flutter/material.dart';
import 'package:my_library/models/livre.dart';
import 'package:my_library/services/livre_services.dart';

class AjouterLivreView extends StatefulWidget {
  @override
  _AjouterLivreViewState createState() => _AjouterLivreViewState();
}

class _AjouterLivreViewState extends State<AjouterLivreView> {
  final _formKey = GlobalKey<FormState>();
  final LivreServices _livreServices = LivreServices();

  String _titre = '';
  String _auteur = '';
  String _categorie = '';
  String _couverture = '';
  String _resume = '';
  int _nombreDePages = 0;
  DateTime _datePublication = DateTime.now();
  String _editeur = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un livre'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Titre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un titre';
                  }
                  return null;
                },
                onSaved: (value) {
                  _titre = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Auteur'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un auteur';
                  }
                  return null;
                },
                onSaved: (value) {
                  _auteur = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Catégorie'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une catégorie';
                  }
                  return null;
                },
                onSaved: (value) {
                  _categorie = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Couverture'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une URL pour la couverture';
                  }
                  return null;
                },
                onSaved: (value) {
                  _couverture = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Résumé'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un résumé';
                  }
                  return null;
                },
                onSaved: (value) {
                  _resume = value!;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Nombre de pages'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nombre de pages';
                  }
                  return null;
                },
                onSaved: (value) {
                  _nombreDePages = int.parse(value!);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Date de publication'),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _datePublication,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null && picked != _datePublication) {
                    setState(() {
                      _datePublication = picked;
                    });
                  }
                },
                onSaved: (value) {
                  _datePublication = DateTime.parse(value!);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Editeur'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un éditeur';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editeur = value!;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final Livre livre = Livre(
                      id: '',
                      titre: _titre,
                      auteurId: _auteur,
                      categorie: _categorie,
                      couverture: _couverture,
                      resume: _resume,
                      nombreDePages: _nombreDePages,
                      datePublication: _datePublication,
                      editeur: _editeur,
                    );
                    _livreServices.addLivre(livre);
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
