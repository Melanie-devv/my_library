import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_library/models/utilisateur.dart';

class UtilisateurServices {
  final CollectionReference _utilisateurs = FirebaseFirestore.instance.collection('utilisateurs');

  Future<List<Utilisateur>> getUtilisateurs() async {
    final QuerySnapshot snapshot = await _utilisateurs.get();
    return snapshot.docs.map((doc) {
      return Utilisateur.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  // CRUD
  Future<void> addUtilisateur(Utilisateur utilisateur) async {
    await _utilisateurs.add(utilisateur.toMap());
  }

  Future<void> updateUtilisateur(Utilisateur utilisateur) async {
    await _utilisateurs.doc(utilisateur.id).update(utilisateur.toMap());
  }

  Future<void> deleteUtilisateur(String id) async {
    await _utilisateurs.doc(id).delete();
  }

  // AUTRES METHODES
}
