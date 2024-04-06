class Don {
  String id;
  String utilisateur;
  double montant;
  DateTime dateDonnation;

  Don({required this.id, required this.utilisateur, required this.montant, required this.dateDonnation});

  factory Don.fromMap(Map<String, dynamic> data) {
    final String id = data['id'];
    final String utilisateur = data['utilisateur'];
    final double montant = data['montant'];
    final DateTime dateDonnation = DateTime.fromMillisecondsSinceEpoch(data['date_donnation']);

    return Don(
      id: id,
      utilisateur: utilisateur,
      montant: montant,
      dateDonnation: dateDonnation,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'utilisateur': utilisateur,
      'montant': montant,
      'date_donnation': dateDonnation.millisecondsSinceEpoch,
    };
  }
}