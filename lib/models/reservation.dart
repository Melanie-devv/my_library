import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {
  String id;
  String utilisateur;
  String livre;
  String stock;
  Timestamp dateDebutReservation;
  Timestamp dateFinReservation;

  Reservation({
    required this.id,
    required this.utilisateur,
    required this.livre,
    required this.stock,
    required this.dateDebutReservation,
    required this.dateFinReservation,
  });

  factory Reservation.fromMap(Map<String, dynamic> data) {
    return Reservation(
      id: data['id'],
      utilisateur: data['utilisateur'],
      livre: data['livre'],
      stock: data['stock'],
      dateDebutReservation: data['date_debut_reservation'],
      dateFinReservation: data['date_fin_reservation'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'utilisateur': utilisateur,
      'livre': livre,
      'stock': stock,
      'date_debut_reservation': dateDebutReservation,
      'date_fin_reservation': dateFinReservation,
    };
  }

  bool isEnCours() {
    final DateTime now = DateTime.now();
    return now.isAfter(dateDebutReservation.toDate()) && now.isBefore(dateFinReservation.toDate());
  }
}
