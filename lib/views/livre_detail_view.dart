import 'package:flutter/material.dart';
import 'package:my_library/models/livre.dart';
import 'package:my_library/services/livre_services.dart';

import '../models/auteur.dart';
import '../services/auteur_services.dart';

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
            body: Stack(
              children: <Widget>[
                Image.network(
                  livre.couverture,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Colors.white.withAlpha(100),
                        Colors.white70,
                        Colors.white,
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.only(top: 280),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                livre.titre,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ListTile(
                                leading: Icon(Icons.person, color: Colors.black),
                                title: FutureBuilder<Auteur>(
                                  future: auteurServices.getAuteurById(livre.auteurId),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final Auteur auteur = snapshot.data!;
                                      return Text(
                                        'Auteur : ${auteur.nom} ${auteur.prenom}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text(
                                        'Erreur lors de la récupération de l\'auteur : ${snapshot.error}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                      );
                                    }
                                    return CircularProgressIndicator();
                                  },
                                ),
                              ),
                              ListTile(
                                leading: Icon(
                                    Icons.category, color: Colors.black),
                                title: Text(
                                  'Catégorie : ${livre.categorie}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              ListTile(
                                leading: Icon(Icons.pages, color: Colors.black),
                                title: Text(
                                  'Nombre de pages : ${livre.nombreDePages}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              ListTile(
                                leading: Icon(
                                    Icons.calendar_today, color: Colors.black),
                                title: Text(
                                  'Date de publication : ${livre.datePublication
                                      .toString()}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              ListTile(
                                leading: Icon(
                                    Icons.business, color: Colors.black),
                                title: Text(
                                  'Editeur : ${livre.editeur}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  'Résumé : ${livre.resume}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                  Icons.favorite_border, color: Colors.black),
                              onPressed: () {
                                // Ajoutez votre logique pour marquer le livre comme favori
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.share, color: Colors.black),
                              onPressed: () {
                                // Ajoutez votre logique pour partager le livre
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text(
              'Erreur lors de la récupération du livre : ${snapshot.error}');
        }
        return CircularProgressIndicator();
      },
    );
  }
}