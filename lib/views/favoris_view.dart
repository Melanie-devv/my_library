import 'package:flutter/material.dart';
import 'package:my_library/models/livre.dart';
import 'package:my_library/services/utilisateur_services.dart';
import 'package:my_library/widget/bottom_navigation_bar.dart';

import '../models/auteur.dart';
import '../routes.dart';
import '../services/auteur_services.dart';

class FavorisView extends StatefulWidget {
  @override
  _FavorisViewState createState() => _FavorisViewState();
}

class _FavorisViewState extends State<FavorisView> {
  List<Livre> _favoris = [];

  @override
  void initState() {
    super.initState();
    _getFavoris();
  }

  Future<void> _getFavoris() async {
    final String? utilisateurId = await UtilisateurServices().getCurrentUid();
    if (utilisateurId == null) {
      return;
    }

    final favoris = await UtilisateurServices().getFavoris(utilisateurId);
    setState(() {
      _favoris = favoris;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Mes livres favoris'),
        centerTitle: true,
      ),
      body: _favoris.isEmpty
          ? const Center(
              child: Text(
                'Vous n\'avez pas encore de favoris',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey
                ),
              ),
            )
          : ListView.builder(
              itemCount: _favoris.length,
              itemBuilder: (context, index) {
                final livre = _favoris[index];
                return Column(
                  children: <Widget>[
                    const SizedBox(height: 10),
                    FutureBuilder<Auteur>(
                      future: AuteurServices().getAuteurById(livre.auteurId),
                      builder: (BuildContext context, AsyncSnapshot<Auteur> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else {
                          if (snapshot.hasError) {
                            return Text('Erreur: ${snapshot.error}');
                          } else {
                            final auteur = snapshot.data;
                            return InkWell(
                              onTap: () {
                                Routes.router.navigateTo(context, '/livre/${livre.id}');
                              },
                              child: ListTile(
                                leading: Image.network(
                                  livre.couverture,
                                  width: 70,
                                  height: 100,
                                ),
                                title: Text(livre.titre),
                                subtitle: Text('${auteur?.prenom} ${auteur?.nom}'),
                                trailing: const Icon(Icons.arrow_forward_ios),
                              ),
                            );
                          }
                        }
                      },
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
      bottomNavigationBar: const BottomNavigationBarWidget(1),
    );
  }
}