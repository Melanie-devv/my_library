import 'don.dart';

class Utilisateur {
  String id;
  String nom;
  String prenom;
  String email;
  DateTime dateNaissance;
  List<Don> dons = [];
  bool est_admin = false;

  Utilisateur({required this.id, required this.nom, required this.prenom, required this.email, required this.dateNaissance, required this.dons, this.est_admin = false});

  factory Utilisateur.fromMap(Map<String, dynamic> data) {
    final String id = data['id'];
    final String nom = data['nom'];
    final String prenom = data['prenom'];
    final String email = data['email'];
    final DateTime dateNaissance = DateTime.fromMillisecondsSinceEpoch(data['date_naissance']);
    final List<Don> dons = (data['dons'] as List).map((don) => Don.fromMap(don)).toList();
    final bool est_admin = data['est_admin'];

    return Utilisateur(
      id: id,
      nom: nom,
      prenom: prenom,
      email: email,
      dateNaissance: dateNaissance,
      dons: dons,
      est_admin: est_admin,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'date_naissance': dateNaissance.millisecondsSinceEpoch,
      'dons': dons.map((don) => don.toMap()).toList(),
      'est_admin': est_admin,
    };
  }

  // METHODES

  List<Don> getDons() {
    return dons;
  }

  double getMontantTotalDons() {
    double montantTotal = 0;
    dons.forEach((don) {
      montantTotal += don.montant;
    });
    return montantTotal;
  }
}
