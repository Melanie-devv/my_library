import 'package:flutter/material.dart';
import 'package:my_library/extensions.dart';
import 'package:my_library/models/livre.dart';
import 'package:my_library/services/livre_services.dart';

import '../models/auteur.dart';
import '../services/auteur_services.dart';
import 'livre_detail_view.dart';

class AuteurDetailView extends StatelessWidget {
  final String auteurId;

  const AuteurDetailView({required this.auteurId});

  @override
  Widget build(BuildContext context) {
    final LivreServices livreServices = LivreServices();
    final AuteurServices auteurServices = AuteurServices();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de l\'auteur'),
      ),
      body: FutureBuilder<Auteur>(
        future: auteurServices.getAuteurById(auteurId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final Auteur auteur = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(auteur.image),
                          ),
                          const SizedBox(width: 16.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${auteur.nom} ${auteur.prenom}',
                                style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16.0),
                              FutureBuilder<int>(
                                future: AuteurServices().getNombreLivresParAuteur(auteur.id),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final int nombreLivres = snapshot.data!;
                                    return Text('$nombreLivres livres');
                                  } else if (snapshot.hasError) {
                                    return Text('Erreur : ${snapshot.error}');
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                              const SizedBox(height: 16.0),
                              FutureBuilder<int>(
                                future: AuteurServices().getNombrePagesEcritesParAuteur(auteur.id),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final int nombrePages = snapshot.data!;
                                    return Text('$nombrePages pages');
                                  } else if (snapshot.hasError) {
                                    return Text('Erreur : ${snapshot.error}');
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text('Né le ${auteur.dateNaissance.formatDate()}'),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Biographie :',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    auteur.biographie,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 26.0),
                  const Text(
                    'Livres de cet auteur :',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16.0),
                  FutureBuilder<List<Livre>>(
                    future: livreServices.getLivresByAuteur(auteur.id),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final List<Livre> livres = snapshot.data!;
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            mainAxisSpacing: 16.0,
                            crossAxisSpacing: 16.0,
                          ),
                          itemCount: livres.length,
                          itemBuilder: (context, index) {
                            final Livre livre = livres[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LivreDetailView(
                                      livreId: livre.id,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Image.network(
                                    livre.couverture,
                                    height: 130,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    livre.titre,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return const Text('Erreur : {snapshot.error}');
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return const Text('Erreur : {snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}