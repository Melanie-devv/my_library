import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_library/widget/bottom_navigation_bar.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('utilisateurs').doc(userId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }
          final userData = snapshot.data?.data() as Map<String, dynamic>?;
          if (userData == null) {
            return const Center(child: Text('Aucune donnée utilisateur trouvée'));
          }
          return ListView(
            children: [
              ListTile(
                title: const Text('Nom'),
                subtitle: Text('${userData['nom']}'),
              ),
              const Divider(),
              ListTile(
                title: const Text('Prénom'),
                subtitle: Text('${userData['prenom']}'),
              ),
              const Divider(),
              ListTile(
                title: const Text('Date de naissance'),
                subtitle: Text('${userData['date_naissance']}'),
              ),
              const Divider(),
              ListTile(
                title: const Text('Adresse e-mail'),
                subtitle: Text('${user?.email}'),
              ),
              const Divider(),
              const SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text('Déconnexion'),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(3),
    );
  }
}