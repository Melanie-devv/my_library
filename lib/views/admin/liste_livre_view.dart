import 'package:flutter/material.dart';
import 'package:my_library/models/livre.dart';
import 'package:my_library/services/livre_services.dart';
import 'package:my_library/views/admin/modifier_livre_view.dart';

class ListeLivresView extends StatefulWidget {
  @override
  _ListeLivresViewState createState() => _ListeLivresViewState();
}

class _ListeLivresViewState extends State<ListeLivresView> {
  final LivreServices _livreServices = LivreServices();

  List<Livre> _livres = [];

  @override
  void initState() {
    super.initState();
    _getLivres();
  }

  Future<void> _getLivres() async {
    final List<Livre> livres = await _livreServices.getLivres();
    setState(() {
      _livres = livres;
    });
  }

  Future<void> _deleteLivre(String id) async {
    await _livreServices.deleteLivre(id);
    _getLivres();
  }

  Future<void> _showConfirmationDialog(String id) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Suppression d\'un livre'),
          content: Text('Êtes-vous sûr de vouloir supprimer ce livre ?'),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Supprimer'),
              onPressed: () {
                _deleteLivre(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Gestion des livres',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _livres.length,
              itemBuilder: (context, index) {
                final Livre livre = _livres[index];
                return ListTile(
                  title: Text(livre.titre),
                  subtitle: Text(livre.auteurId),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ModifierLivreView(livre: livre),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _showConfirmationDialog(livre.id);
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
    );
  }
}
