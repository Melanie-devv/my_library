import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_library/models/reservation.dart';

class ReservationServices {
  final CollectionReference _reservations = FirebaseFirestore.instance.collection('reservations');

  //region CRUD

  Future<List<Reservation>> getReservations() async {
    final QuerySnapshot snapshot = await _reservations.get();
    return snapshot.docs.map((doc) =>
        Reservation.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> addReservation(String idLivre) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    final Reservation reservation = Reservation(
      id: '',
      utilisateur: user.uid,
      livre: idLivre,
      dateDebutReservation: Timestamp.now(),
      dateFinReservation: Timestamp.fromDate(DateTime.now().add(const Duration(days: 30))),
    );

    _validateReservation(reservation);
    await _reservations.add(reservation.toMap());
  }

  Future<void> updateReservation(Reservation reservation) async {
    _validateReservation(reservation);
    await _reservations.doc(reservation.id).update(reservation.toMap());
  }

  Future<void> deleteReservation(String id) async {
    await _reservations.doc(id).delete();
  }

  //endregion

  //region Validation

  void _validateReservation(Reservation reservation) {
    if (reservation.utilisateur.isEmpty) {
      throw Exception('L\'identifiant de l\'utilisateur ne peut pas être vide');
    }
    if (reservation.livre.isEmpty) {
      throw Exception('L\'identifiant du livre ne peut pas être vide');
    }
    if (reservation.dateDebutReservation.toDate().isAfter(DateTime.now())) {
      throw Exception(
          'La date de début de réservation ne peut pas être dans le futur');
    }
    if (reservation.dateFinReservation.toDate().isBefore(
        reservation.dateDebutReservation.toDate())) {
      throw Exception(
          'La date de fin de réservation ne peut pas être avant la date de début de réservation');
    }
  }

  //endregion

  //region Autres méthodes

  Future<List<Reservation>> getReservationsByUser(String userId) async {
    final QuerySnapshot snapshot = await _reservations
        .where('utilisateur', isEqualTo: userId)
        .orderBy('date_debut_reservation', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return Reservation.fromMap(data);
    }).toList();
  }
}