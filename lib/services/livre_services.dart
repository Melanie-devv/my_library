import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_library/models/livre.dart';

class LivreServices {
  final CollectionReference _livres = FirebaseFirestore.instance.collection('livres');

  Future<List<Livre>> getLivres() async {
    final QuerySnapshot snapshot = await _livres.get();
    List<Livre> livres = snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      Livre livre = Livre.fromMap(data);
      return livre;
    }).toList();
    return livres;
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

  Stream<QuerySnapshot> searchLivres(String query) {
    return _livres
        .where('titre', isGreaterThanOrEqualTo: query)
        .where('titre', isLessThan: query + 'z')
        .snapshots();
  }

  Future<List<Livre>> getLivresByAuteur(String auteurId) async {
    final QuerySnapshot snapshot = await _livres.where('auteur_id', isEqualTo: auteurId).get();
    return snapshot.docs.map((doc) => Livre.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<Livre> getLivreById(String livreId) async {
    final DocumentSnapshot doc = await FirebaseFirestore.instance.collection('livres').doc(livreId).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      final livre = Livre.fromMap(data);
      return livre;
    } else {
      throw Exception('Livre non trouvé');
    }
  }
//endregion
}
