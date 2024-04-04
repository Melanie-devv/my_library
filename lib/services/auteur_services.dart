import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_library/models/auteur.dart';

import '../models/livre.dart';

class AuteurServices {
  final CollectionReference _auteurs = FirebaseFirestore.instance.collection('auteurs');

  Future<List<Auteur>> getAuteurs() async {
    final QuerySnapshot snapshot = await _auteurs.get();
    List<Auteur> auteurs = snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      Auteur auteur = Auteur.fromMap(data);
      return auteur;
    }).toList();
    return auteurs;
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

  Future<Auteur> getAuteurById(String id) async {
    final DocumentSnapshot doc = await _auteurs.doc(id).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return Auteur.fromMap(data);
    } else {
      throw Exception('Auteur non trouvé');
    }
  }

  Future<int> getNombreLivresParAuteur(String id) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('livres')
        .where('auteurId', isEqualTo: id)
        .get();
    return result.size;
  }

  Future<int> getNombrePagesEcritesParAuteur(String id) async {
    int nombrePages = 0;
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('livres')
        .where('auteurId', isEqualTo: id)
        .get();
    for (final QueryDocumentSnapshot doc in result.docs) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      final Livre livre = Livre.fromMap(data);
      nombrePages += livre.nombreDePages;
    }
    return nombrePages;
  }

//endregion
}
