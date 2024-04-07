import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_library/extensions.dart';
import 'package:my_library/models/livre.dart';
import 'package:my_library/services/livre_services.dart';
import 'package:my_library/views/pdf_view.dart';
import 'package:my_library/views/reservation_view.dart';
import 'package:my_library/widget/bottom_navigation_bar.dart';

import '../models/auteur.dart';
import '../routes.dart';
import '../services/auteur_services.dart';
import '../services/stock_services.dart';
import '../services/utilisateur_services.dart';
import 'auteur_detail_view.dart';

class LivreDetailView extends StatefulWidget {
  final String livreId;

  const LivreDetailView({required this.livreId});

  @override
  _LivreDetailViewState createState() => _LivreDetailViewState();
}

class _LivreDetailViewState extends State<LivreDetailView> {
  bool _estDejaFavori = false;

  @override
  void initState() {
    super.initState();
    _checkFavori();
  }

  Future<void> _checkFavori() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String utilisateurId = user!.uid;
    final estDejaFavori = await UtilisateurServices().isFavori(utilisateurId, widget.livreId);
    setState(() {
      _estDejaFavori = estDejaFavori;
    });
  }

  @override
  Widget build(BuildContext context) {
    final LivreServices livreServices = LivreServices();
    final AuteurServices auteurServices = AuteurServices();
    final StockServices stockServices = StockServices();

    return FutureBuilder<Livre>(
      future: livreServices.getLivreById(widget.livreId),
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
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                livre.titre,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.favorite,
                                color: _estDejaFavori ? Colors.red : Colors.grey,
                                size: 40,
                              ),
                              onPressed: () async {
                                final User? user = FirebaseAuth.instance.currentUser;
                                final String utilisateurId = user!.uid;
                                if (_estDejaFavori) {
                                  await UtilisateurServices().removeFavori(utilisateurId, widget.livreId);
                                } else {
                                  await UtilisateurServices().addFavori(utilisateurId, widget.livreId);
                                }
                                setState(() {
                                  _estDejaFavori = !_estDejaFavori;
                                });
                              },
                            ),
                          ],
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
                                    'Catégorie : ${livre.categorie}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    'Edition ${livre.editeur}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
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
                                    'Nombre de pages : ${livre.nombreDePages}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: FutureBuilder<int>(
                                      future: stockServices.getQuantiteEnStock(livre.id),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final int quantiteEnStock = snapshot.data!;
                                          return Text(
                                            'Quantité en stock : $quantiteEnStock',
                                            style: const TextStyle(
                                              color: Colors.green,
                                              fontSize: 18,
                                            ),
                                          );
                                        } else if (snapshot.hasError) {
                                          return const Text(
                                            'En rupture de stock !',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 18,
                                            ),
                                          );
                                        }
                                        return const SizedBox();
                                      },
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
                          livre.resume,
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
                              onPressed: () async {
                                final String pdfUrl = await LivreServices().getPdfUrl(livre.id);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PdfView(
                                      url: pdfUrl,
                                    ),
                                  ),
                                );
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
                              onPressed: () async {
                                final String livreId = livre.id;
                                final bool filePath = await LivreServices().downloadPdf(livreId);
                                if (filePath) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Le livre a été téléchargé avec succès'),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Erreur lors du téléchargement du livre'),
                                    ),
                                  );
                                }
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
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            FutureBuilder<int>(
                              future: stockServices.getQuantiteEnStock(livre.id),
                              builder: (context, snapshot) {
                                final int quantiteEnStock = snapshot.data ?? 0;
                                if (snapshot.hasData) {
                                  return ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ReservationView(livreId: livre.id),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    child:  Container(
                                      width: MediaQuery.of(context).size.width * 0.8,
                                      height: 50,
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'Réserver le livre',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text(
                                    'Rupture de stock !',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: quantiteEnStock > 0 ? Colors.green : Colors.red,
                                    ),
                                  );
                                }
                                return const SizedBox();
                              },
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
                                      child: SizedBox(
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
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}