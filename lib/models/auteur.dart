import 'package:cloud_firestore/cloud_firestore.dart';

class Auteur {
  String id;
  String nom;
  String prenom;
  DateTime dateNaissance;
  String biographie;
  String image;

  Auteur({required this.id, required this.nom, required this.prenom, required this.dateNaissance, required this.biographie, required this.image});

  factory Auteur.fromMap(Map<String, dynamic> data) {
    final String id = data['id'];
    final String nom = data['nom'];
    final String prenom = data['prenom'];
    final DateTime dateNaissance = (data['date_naissance'] as Timestamp).toDate();
    final String biographie = data['biographie'];
    final String image = data['image'];

    return Auteur(
      id: id,
      nom: nom,
      prenom: prenom,
      dateNaissance: dateNaissance,
      biographie: biographie,
      image: image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'prenom': prenom,
      'date_naissance': dateNaissance.millisecondsSinceEpoch,
      'biographie': biographie,
      'image': image,
    };
  }
}
