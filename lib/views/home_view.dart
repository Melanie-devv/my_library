import 'package:flutter/material.dart';
import 'package:my_library/models/livre.dart';
import 'package:my_library/services/livre_services.dart';
import 'package:my_library/widget/bottom_navigation_bar.dart';

import '../models/auteur.dart';
import '../routes.dart';
import '../services/auteur_services.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final LivreServices _livreServices = LivreServices();
  final AuteurServices _auteurServices = AuteurServices();
  List<Livre> _livres = [];
  List<Auteur> _auteurs = [];

  @override
  void initState() {
    super.initState();
    _getLivres();
    _getAuteurs();
  }

  Future<void> _getLivres() async {
    try {
      _livres = await _livreServices.getLivres();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur lors de la récupération des livres'),
        ),
      );
    }
  }

  Future<void> _getAuteurs() async {
    try {
      _auteurs = await _auteurServices.getAuteurs();
    } catch (e) {
      print('Erreur lors de la récupération des auteurs : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur lors de la récupération des auteurs'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ma bibliothèque'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextField(
              onChanged: (query) {
                _livreServices.searchLivres(query).listen((snapshot) {
                  setState(() {
                    _livres = snapshot.docs.map((doc) => Livre.fromMap(doc.data() as Map<String, dynamic>)).toList();
                  });
                });
              },
              decoration: const InputDecoration(
                hintText: 'Rechercher un livre',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Nos livres',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Livre>>(
              future: _livreServices.getLivres(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Erreur lors de la récupération des livres'),
                  );
                } else {
                  final List<Livre> livres = snapshot.data!;
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.6,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                    ),
                    itemCount: livres.length,
                    itemBuilder: (context, index) {
                      final Livre livre = livres[index];
                      final Auteur auteur = _auteurs.firstWhere((a) => a.id == livre.auteurId);
                      return GestureDetector(
                        onTap: () {
                          Routes.router.navigateTo(context, '/livre/${livre.id}');
                        },
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Image.network(
                                  livre.couverture,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      livre.titre,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    Text(
                                      '${auteur.prenom} ${auteur.nom}',
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(0),
    );
  }
}
