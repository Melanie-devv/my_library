import 'package:flutter/material.dart';
import 'package:my_library/models/livre.dart';
import 'package:my_library/services/livre_services.dart';

import '../models/auteur.dart';
import '../services/auteur_services.dart';

class AuteurDetailView extends StatelessWidget {
  final String auteurId;

  const AuteurDetailView({required this.auteurId});

  @override
  Widget build(BuildContext context) {
    final LivreServices livreServices = LivreServices();

    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de l\'auteur'),
      ),
      body: FutureBuilder<Auteur>(
        future: AuteurServices().getAuteurById(auteurId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final Auteur auteur = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(auteur.image),
                  SizedBox(height: 16.0),
                  Text('Nom : ${auteur.nom}'),
                  SizedBox(height: 8.0),
                  Text('Biographie : ${auteur.biographie}'),
                  SizedBox(height: 16.0),
                  Text('Livres :'),
                  FutureBuilder<List<Livre>>(
                    future: livreServices.getLivresByAuteur(auteur.id),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final List<Livre> livres = snapshot.data!;
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: livres.length,
                          itemBuilder: (context, index) {
                            final Livre livre = livres[index];
                            return ListTile(
                              title: Text(livre.titre),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text('Erreur : ${snapshot.error}');
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Erreur : ${snapshot.error}');
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
