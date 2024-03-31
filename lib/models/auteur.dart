class Auteur {
  String id;
  String nom;
  String prenom;
  DateTime dateNaissance;

  Auteur({required this.id, required this.nom, required this.prenom, required this.dateNaissance});

  factory Auteur.fromMap(Map<String, dynamic> data) {
    final String id = data['id'];
    final String nom = data['nom'];
    final String prenom = data['prenom'];
    final DateTime dateNaissance = DateTime.fromMillisecondsSinceEpoch(data['date_naissance']);

    return Auteur(
      id: id,
      nom: nom,
      prenom: prenom,
      dateNaissance: dateNaissance,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'date_naissance': dateNaissance.millisecondsSinceEpoch,
    };
  }
}
