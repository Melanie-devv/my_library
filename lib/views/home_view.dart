import 'package:flutter/material.dart';
import 'package:my_library/models/livre.dart';
import 'package:my_library/services/livre_services.dart';
import 'package:my_library/widget/bottom_navigation_bar.dart';

import '../routes.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final LivreServices _livreServices = LivreServices();
  List<Livre> _livres = [];

  @override
  void initState() {
    super.initState();
    _getLivres();
  }

  Future<void> _getLivres() async {
    try {
      _livres = await _livreServices.getLivres();
    } catch (e) {
      print('Erreur lors de la récupération des livres : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur lors de la récupération des livres'),
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
            padding: const EdgeInsets.all(8.0),
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
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
              itemCount: _livres.length,
              itemBuilder: (context, index) {
                final Livre livre = _livres[index];
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
                          child: Text(
                            livre.titre,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
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
