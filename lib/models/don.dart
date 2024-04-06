import 'package:cloud_firestore/cloud_firestore.dart';

class Don {
  String id;
  String utilisateur;
  double montant;
  Timestamp dateDonation;

  Don({required this.id, required this.utilisateur, required this.montant, required this.dateDonation});

  factory Don.fromMap(Map<String, dynamic> data) {
    final String id = data['id'];
    final String utilisateur = data['utilisateur'];
    final double montant = data['montant'];
    final Timestamp dateDonation = data['date_donation'];

    return Don(
      id: id,
      utilisateur: utilisateur,
      montant: montant,
      dateDonation: dateDonation,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'utilisateur': utilisateur,
      'montant': montant,
      'date_donation': dateDonation,
    };
  }
}