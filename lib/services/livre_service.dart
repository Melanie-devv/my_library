import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_library/models/livre.dart';

class LivreServices {
  final CollectionReference _livres = FirebaseFirestore.instance.collection('livres');

  Future<List<Livre>> getLivres() async {
    final QuerySnapshot snapshot = await _livres.get();
    return snapshot.docs.map((doc) => Livre.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  //region CRUD

  Future<void> addLivre(Livre livre) async {
    _validateLivre(livre);
    await _livres.add(livre.toMap());
  }

  Future<void> updateLivre(Livre livre) async {
    _validateLivre(livre);
    await _livres.doc(livre.id).update(livre.toMap());
  }

  Future<void> deleteLivre(String id) async {
    await _livres.doc(id).delete();
  }
  //endregion

  //region Validation

  void _validateLivre(Livre livre) {
    if (livre.titre.isEmpty || livre.categorie.isEmpty || livre.couverture.isEmpty || livre.resume.isEmpty || livre.editeur.isEmpty) {
      throw Exception('Tous les champs sont obligatoires pour un livre');
    }
    if (livre.nombreDePages <= 0) {
      throw Exception('Le nombre de pages doit être supérieur à zéro');
    }
    if (livre.datePublication.isAfter(DateTime.now())) {
      throw Exception('La date de publication ne peut pas être dans le futur');
    }
  }
  //endregion

  //region Autres méthodes

  //endregion
}
