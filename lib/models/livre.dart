import 'package:cloud_firestore/cloud_firestore.dart';

class Livre {
  String id;
  String auteurId;
  String titre;
  String categorie;
  String couverture;
  String resume;
  int nombreDePages;
  DateTime datePublication;
  String editeur;
  String pdfUrl;

  Livre({required this.id, required this.auteurId, required this.titre, required this.categorie, required this.couverture, required this.resume, required this.nombreDePages, required this.datePublication, required this.editeur, this.pdfUrl = ''});

  factory Livre.fromMap(Map<String, dynamic> data) {
    final String id = data['id'];
    final String auteurId = data['auteur_id'];
    final String titre = data['titre'];
    final String categorie = data['categorie'];
    final String couverture = data['couverture'];
    final String resume = data['resume'];
    final int nombreDePages = data['nombre_de_pages'];
    final DateTime datePublication = (data['date_publication'] as Timestamp).toDate();
    final String editeur = data['editeur'];

    return Livre(
      id: id,
      auteurId: auteurId,
      titre: titre,
      categorie: categorie,
      couverture: couverture,
      resume: resume,
      nombreDePages: nombreDePages,
      datePublication: datePublication,
      editeur: editeur,
      pdfUrl: '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'auteur_id': auteurId,
      'titre': titre,
      'categorie': categorie,
      'couverture': couverture,
      'resume': resume,
      'nombre_de_pages': nombreDePages,
      'date_publication': datePublication.millisecondsSinceEpoch,
      'editeur': editeur,
    };
  }
}
