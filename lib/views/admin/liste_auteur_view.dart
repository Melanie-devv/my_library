import 'package:flutter/material.dart';
import 'package:my_library/models/auteur.dart';
import 'package:my_library/services/auteur_services.dart';

import 'ajouter_auteur_view.dart';
import 'modifier_auteur_view.dart';

class ListeAuteursView extends StatefulWidget {
  @override
  _ListeAuteursViewState createState() => _ListeAuteursViewState();
}

class _ListeAuteursViewState extends State<ListeAuteursView> {
  late List<Auteur> _auteurs;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAuteurs();
  }

  Future<void> _fetchAuteurs() async {
    final auteurs = await AuteurServices().getAuteurs();
    setState(() {
      _auteurs = auteurs;
      _isLoading = false;
    });
  }

  Future<void> _deleteAuteur(String id) async {
    await AuteurServices().deleteAuteur(id);
    setState(() {
      _auteurs.removeWhere((auteur) => auteur.id == id);
    });
  }

  Future<void> _showConfirmationDialog(String id) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Supprimer un auteur'),
          content: const Text('Êtes-vous sûr de vouloir supprimer cet auteur ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                _deleteAuteur(id);
                Navigator.of(context).pop();
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

 @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Gestion des auteurs',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _auteurs.length,
              itemBuilder: (context, index) {
                final auteur = _auteurs[index];
                return ListTile(
                  title: Text('${auteur.prenom} ${auteur.nom}'),
                  subtitle: Text(auteur.id),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ModifierAuteurView(auteur: auteur),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _showConfirmationDialog(auteur.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AjouterAuteurView()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}