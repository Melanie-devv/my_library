import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_library/models/livre.dart';

class LivreServices {
  final CollectionReference _livres = FirebaseFirestore.instance.collection('livres');

  Future<List<Livre>> getLivres() async {
    final QuerySnapshot snapshot = await _livres.get();
    return snapshot.docs.map((doc) {
      return Livre.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  // CRUD
  Future<void> addLivre(Livre livre) async {
    await _livres.add(livre.toMap());
  }

  Future<void> updateLivre(Livre livre) async {
    await _livres.doc(livre.id).update(livre.toMap());
  }

  Future<void> deleteLivre(String id) async {
    await _livres.doc(id).delete();
  }

  // AUTRES METHODES
}