import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:my_library/models/livre.dart';

class LivreServices {
  final CollectionReference _livres = FirebaseFirestore.instance.collection('livres');
  final storageRef = FirebaseStorage.instance.ref();

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
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return Livre.fromMap(data);
    }).toList();
  }

  Future<Livre> getLivreById(String livreId) async {
    final doc = await _livres.doc(livreId).get();
    final data = doc.data() as Map<String, dynamic>;
    final pdfUrl = await getPdfUrl(livreId);
    return Livre(
      id: livreId,
      titre: data['titre'],
      auteurId: data['auteur_id'],
      categorie: data['categorie'],
      couverture: data['couverture'],
      resume: data['resume'],
      nombreDePages: data['nombre_de_pages'],
      editeur: data['editeur'],
      datePublication: data['date_publication'].toDate(),
      pdfUrl: pdfUrl,
    );
  }

  Future<String> getPdfUrl(String livreId) async {
    final pdfRef = storageRef.child('pdf/$livreId/livre.pdf');
    final url = await pdfRef.getDownloadURL();
    return url;
  }

  Future<bool> downloadPdf(String livreId) async {
    try {
      final pdfUrl = await getPdfUrl(livreId);
      final response = await http.get(Uri.parse(pdfUrl));
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$livreId.pdf');
      await file.writeAsBytes(response.bodyBytes);
      return true;
    } catch (e) {
      return false;
    }
  }

//endregion
}
