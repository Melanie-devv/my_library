class Don {
  String id;
  double montant;
  DateTime dateDonnation;

  Don({required this.id, required this.montant, required this.dateDonnation});

  factory Don.fromMap(Map<String, dynamic> data) {
    final String id = data['id'];
    final double montant = data['montant'];
    final DateTime dateDonnation = DateTime.fromMillisecondsSinceEpoch(data['date_donnation']);

    return Don(
      id: id,
      montant: montant,
      dateDonnation: dateDonnation,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'montant': montant,
      'date_donnation': dateDonnation.millisecondsSinceEpoch,
    };
  }
}