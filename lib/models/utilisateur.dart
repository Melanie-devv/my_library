class Utilisateur {
  String id;
  String nom;
  String prenom;
  String email;
  DateTime dateNaissance;

  Utilisateur({required this.id, required this.nom, required this.prenom, required this.email, required this.dateNaissance});

  factory Utilisateur.fromMap(Map<String, dynamic> data) {
    final String id = data['id'];
    final String nom = data['nom'];
    final String prenom = data['prenom'];
    final String email = data['email'];
    final DateTime dateNaissance = DateTime.fromMillisecondsSinceEpoch(data['date_naissance']);

    return Utilisateur(
      id: id,
      nom: nom,
      prenom: prenom,
      email: email,
      dateNaissance: dateNaissance,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'date_naissance': dateNaissance.millisecondsSinceEpoch,
    };
  }
}
