import 'package:flutter/material.dart';
import 'package:my_library/models/livre.dart';
import 'package:my_library/services/livre_services.dart';

class ModifierLivreView extends StatefulWidget {
  final Livre livre;

  const ModifierLivreView({required this.livre});

  @override
  _ModifierLivreViewState createState() => _ModifierLivreViewState();
}

class _ModifierLivreViewState extends State<ModifierLivreView> {
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
  void initState() {
    super.initState();
    _titre = widget.livre.titre;
    _auteur = widget.livre.auteurId;
    _categorie = widget.livre.categorie;
    _couverture = widget.livre.couverture;
    _resume = widget.livre.resume;
    _nombreDePages = widget.livre.nombreDePages;
    _datePublication = widget.livre.datePublication;
    _editeur = widget.livre.editeur;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier un livre'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                initialValue: _titre,
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
                initialValue: _auteur,
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
                initialValue: _categorie,
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
                initialValue: _couverture,
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
                initialValue: _resume,
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
                initialValue: _nombreDePages.toString(),
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
                initialValue: _datePublication.toString(),
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
                initialValue: _editeur,
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
                      id: widget.livre.id,
                      titre: _titre,
                      auteurId: _auteur,
                      categorie: _categorie,
                      couverture: _couverture,
                      resume: _resume,
                      nombreDePages: _nombreDePages,
                      datePublication: _datePublication,
                      editeur: _editeur,
                    );
                    _livreServices.updateLivre(livre);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Modifier'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
