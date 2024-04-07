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
  List<Livre> _searchResults = [];

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
      final List<Auteur> auteurs = await _auteurServices.getAuteurs();
      setState(() {
        _auteurs = auteurs;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur lors de la récupération des auteurs'),
        ),
      );
    }
  }

  void _searchLivres(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    _livreServices.searchLivres(query).listen((snapshot) {
      setState(() {
        _searchResults = snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return Livre.fromMap(data);
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('My Library'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) {
                _searchLivres(query);
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
            child: _searchResults.isEmpty
                ? FutureBuilder<List<Livre>>(
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
                      if (_auteurs.isEmpty) {
                        return const Center(
                          child: SizedBox(),
                        );
                      }
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
            )
                : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.6,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final Livre livre = _searchResults[index];
                if (_auteurs.isEmpty) {
                  return const Center(
                    child: SizedBox(),
                  );
                }
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
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(0),
    );
  }
}
