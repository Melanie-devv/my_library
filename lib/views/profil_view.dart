import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_library/models/utilisateur.dart';
import 'package:my_library/services/utilisateur_services.dart';
import 'package:my_library/widget/bottom_navigation_bar.dart';

import '../routes.dart';

class ProfilView extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signOut(BuildContext context) async {
    await _auth.signOut();
    Routes.router.navigateTo(context, '/login', clearStack: true);
  }

  @override
  Widget build(BuildContext context) {
    final UtilisateurServices utilisateurService = UtilisateurServices();

    return FutureBuilder<String>(
      future: utilisateurService.getCurrentUid().then((value) => value ?? ''),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text('Erreur lors de la récupération de l\'ID utilisateur');
        } else {
          final String currentUid = snapshot.data!;
          return FutureBuilder<Utilisateur?>(
            future: utilisateurService.getUserById(currentUid),
            builder: (BuildContext context, AsyncSnapshot<Utilisateur?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Text('Erreur lors de la récupération de l\'utilisateur');
              } else {
                final Utilisateur? user = snapshot.data;
                if (user == null) {
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('Profil'),
                    ),
                    body: const Center(
                      child: Text('Utilisateur non trouvé'),
                    ),
                  );
                }

                return Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    title: const Text('Page de profil'),
                    centerTitle: true,
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.logout),
                        color: Colors.red,
                        onPressed: () => _signOut(context),
                      ),
                    ],
                  ),
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Bienvenue sur MyLibrary',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${user.prenom} ${user.nom}',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 32),
                      ListTile(
                        title: const Text('Mes informations'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Routes.router.navigateTo(context, '/profil-informations');
                        },
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text('Mes favoris'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Routes.router.navigateTo(context, '/favoris');
                        },
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text('Donations'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Routes.router.navigateTo(context, '/profil-donations');
                        },
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text('Réservations'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Routes.router.navigateTo(context, '/profil-reservations');
                        },
                      ),
                      const Divider(),
                      if (user.isAdmin())
                        ...[
                          ListTile(
                            title: const Text('Administration'),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              Routes.router.navigateTo(context, '/administration');
                            },
                          ),
                          const Divider(),
                        ],
                      const SizedBox(height: 60),
                      ElevatedButton(
                        onPressed: () {
                          Routes.router.navigateTo(context, '/donation');
                        },
                        child: Text('En savoir plus'),
                      ),
                    ],
                  ),
                  bottomNavigationBar: const BottomNavigationBarWidget(3),
                );
              }
            },
          );
        }
      },
    );
  }
}