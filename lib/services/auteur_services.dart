import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_library/models/auteur.dart';

class AuteurServices {
  final CollectionReference _auteurs = FirebaseFirestore.instance.collection('auteurs');

  Future<List<Auteur>> getAuteurs() async {
    final QuerySnapshot snapshot = await _auteurs.get();
    return snapshot.docs.map((doc) {
      return Auteur.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  //CRUD
  Future<void> addAuteur(Auteur auteur) async {
    await _auteurs.add(auteur.toMap());
  }

  Future<void> updateAuteur(Auteur auteur) async {
    await _auteurs.doc(auteur.id).update(auteur.toMap());
  }

  Future<void> deleteAuteur(String id) async {
    await _auteurs.doc(id).delete();
  }

  //AUTRES METHODES
}
