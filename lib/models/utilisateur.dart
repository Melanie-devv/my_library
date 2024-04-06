import 'package:cloud_firestore/cloud_firestore.dart';

class Utilisateur {
  String id;
  String nom;
  String prenom;
  String email;
  Timestamp dateNaissance;
  bool est_admin = false;

  Utilisateur({required this.id, required this.nom, required this.prenom, required this.email, required this.dateNaissance, this.est_admin = false});

  factory Utilisateur.fromMap(Map<String, dynamic> data) {
    final String id = data['id'];
    final String nom = data['nom'];
    final String prenom = data['prenom'];
    final String email = data['email'];
    final Timestamp dateNaissance = data['date_naissance'];
    final bool est_admin = data['est_admin'];

    return Utilisateur(
      id: id,
      nom: nom,
      prenom: prenom,
      email: email,
      dateNaissance: dateNaissance,
      est_admin: est_admin,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'date_naissance': dateNaissance,
      'est_admin': est_admin,
    };
  }
}
