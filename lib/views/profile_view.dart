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
        stream: FirebaseFirestore.instance.collection('users').doc(userId).snapshots(),
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
                subtitle: Text('${userData['name']}'),
              ),
              const Divider(),
              ListTile(
                title: const Text('Adresse e-mail'),
                subtitle: Text('${user?.email}'),
              ),
              const Divider(),
              ListTile(
                title: const Text('Numéro de téléphone'),
                subtitle: Text('${userData['phone']}'),
              ),
              const Divider(),
              ListTile(
                title: const Text('Adresse'),
                subtitle: Text('${userData['address']}'),
              ),
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
      bottomNavigationBar: const BottomNavigationBarWidget(4),
    );
  }
}