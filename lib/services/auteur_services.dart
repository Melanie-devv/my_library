import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_library/models/auteur.dart';

class AuteurServices {
  final CollectionReference _auteurs = FirebaseFirestore.instance.collection('auteurs');

  Future<List<Auteur>> getAuteurs() async {
    final QuerySnapshot snapshot = await _auteurs.get();
    return snapshot.docs.map((doc) => Auteur.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  //region CRUD

  Future<void> addAuteur(Auteur auteur) async {
    _validateAuteur(auteur);
    await _auteurs.add(auteur.toMap());
  }

  Future<void> updateAuteur(Auteur auteur) async {
    _validateAuteur(auteur);
    await _auteurs.doc(auteur.id).update(auteur.toMap());
  }

  Future<void> deleteAuteur(String id) async {
    await _auteurs.doc(id).delete();
  }
  //endregion

  //region Validation

  void _validateAuteur(Auteur auteur) {
    if (auteur.nom.isEmpty || auteur.prenom.isEmpty || auteur.biographie.isEmpty || auteur.image.isEmpty) {
      throw Exception('Tous les champs sont obligatoires pour un auteur');
    }
    if (auteur.dateNaissance.isAfter(DateTime.now())) {
      throw Exception('La date de naissance ne peut pas être dans le futur');
    }
  }
  //endregion

  //region Autres méthodes

  //endregion
}
