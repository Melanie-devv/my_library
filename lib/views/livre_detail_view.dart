import 'package:flutter/material.dart';
import 'package:my_library/models/livre.dart';
import 'package:my_library/services/livre_services.dart';
import 'package:my_library/widget/bottom_navigation_bar.dart';

import '../models/auteur.dart';
import '../routes.dart';
import '../services/auteur_services.dart';
import 'auteur_detail_view.dart';

extension DateFormatter on DateTime {
  String formatDate() {
    final List<String> months = [
      'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
    ];

    return '${day} ${months[month - 1]} $year';
  }
}

class LivreDetailView extends StatelessWidget {
  final String livreId;

  const LivreDetailView({required this.livreId});

  @override
  Widget build(BuildContext context) {
    final LivreServices livreServices = LivreServices();
    final AuteurServices auteurServices = AuteurServices();

    return FutureBuilder<Livre>(
      future: livreServices.getLivreById(livreId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final Livre livre = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text(livre.titre),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.network(
                    livre.couverture,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.3,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: Text(
                            livre.titre,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        FutureBuilder<Auteur>(
                          future: auteurServices.getAuteurById(livre.auteurId),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final Auteur auteur = snapshot.data!;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AuteurDetailView(auteurId: auteur.id),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        const Text(
                                          'De ',
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${auteur.prenom} ${auteur.nom}',
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    'Publié le ${livre.datePublication.formatDate()}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    'Catégorie : ${livre.categorie}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              );
                            } else if (snapshot.hasError) {
                              return Text(
                                'Erreur lors de la récupération de l\'auteur : ${snapshot.error}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${livre.resume}',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                // Ajoutez votre logique pour télécharger le livre
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.62,
                                height: 50,
                                alignment: Alignment.center,
                                child: const Text(
                                  'Lire le livre',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Ajoutez votre logique pour télécharger le livre
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.05,
                                height: 50,
                                alignment: Alignment.center,
                                child: const Icon(Icons.download, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 26),
                        const Text(
                          'D\'autres livres du même auteur',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        FutureBuilder<List<Livre>>(
                          future: auteurServices.getAuteurById(livre.auteurId).then((auteur) => livreServices.getLivresByAuteur(auteur.id)),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final List<Livre> livres = snapshot.data!;
                              return SizedBox(
                                height: 130,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: livres.length,
                                  itemBuilder: (context, index) {
                                    final Livre livre = livres[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Routes.router.navigateTo(context, '/livre/${livre.id}');
                                      },
                                      child: Container(
                                        width: 120,
                                        child: Column(
                                          children: <Widget>[
                                            Image.network(
                                              livre.couverture,
                                              width: 100,
                                              height: 130,
                                              fit: BoxFit.cover,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text(
                                'Erreur lors de la récupération des livres : ${snapshot.error}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              );
                            }
                            return const CircularProgressIndicator();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: const BottomNavigationBarWidget(1),
          );
        } else if (snapshot.hasError) {
          return Text(
              'Erreur lors de la récupération du livre : ${snapshot.error}');
        }
        return const SizedBox();
      },
    );
  }
}