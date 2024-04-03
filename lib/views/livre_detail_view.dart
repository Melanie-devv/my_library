import 'package:flutter/material.dart';
import 'package:my_library/services/auteur_services.dart';
import 'package:my_library/models/auteur.dart';
import 'package:my_library/models/livre.dart';
import 'package:my_library/services/livre_services.dart';

class LivreDetailView extends StatelessWidget {
  final String livreId;

  const LivreDetailView({required this.livreId});

  @override
  Widget build(BuildContext context) {
    final AuteurServices auteurServices = AuteurServices();
    final LivreServices livreServices = LivreServices();
    final Livre livre = livreServices.getLivreById(livreId) as Livre;
    final Auteur auteur = auteurServices.getAuteurById(livre.auteurId) as Auteur;

    return Scaffold(
      appBar: AppBar(
        title: Text(livre.titre),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(livre.couverture),
            SizedBox(height: 16.0),
            Text('Titre : ${livre.titre}'),
            SizedBox(height: 8.0),
            Text('Auteur : ${auteur.nom}'),
            SizedBox(height: 8.0),
            Text('Catégorie : ${livre.categorie}'),
            SizedBox(height: 8.0),
            Text('Nombre de pages : ${livre.nombreDePages}'),
            SizedBox(height: 8.0),
            Text('Date de publication : ${livre.datePublication}'),
            SizedBox(height: 8.0),
            Text('Editeur : ${livre.editeur}'),
            SizedBox(height: 16.0),
            Text('Résumé : ${livre.resume}'),
          ],
        ),
      ),
    );
  }
}
