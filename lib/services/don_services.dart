import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_library/models/don.dart';

class DonServices {
  final CollectionReference _dons = FirebaseFirestore.instance.collection('dons');

  //region CRUD

  Future<List<Don>> getDons() async {
    final QuerySnapshot snapshot = await _dons.get();
    return snapshot.docs.map((doc) => Don.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> addDon(double montant) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    final Don don = Don(
      id: '',
      montant: montant,
      dateDonation: Timestamp.now(),
      utilisateur: user.uid,
    );

    _validateDon(don);
    await _dons.add(don.toMap());
  }


  Future<void> updateDon(Don don) async {
    _validateDon(don);
    await _dons.doc(don.id).update(don.toMap());
  }

  Future<void> deleteDon(String id) async {
    await _dons.doc(id).delete();
  }
  //endregion

  //region Validation

   void _validateDon(Don don) {
    if (don.montant <= 0) {
      throw Exception('Le montant du don doit être supérieur à zéro');
    }
    if (don.dateDonation.toDate().isAfter(DateTime.now())) {
      throw Exception('La date du don ne peut pas être dans le futur');
    }
  }
  //endregion

  //region Autres méthodes

  Future<double> getMontantTotalParMois(int mois, int annee, String? userId) async {
    QuerySnapshot snapshot;
    if (userId == null || userId.isEmpty) {
      snapshot = await _dons.get();
    } else {
      snapshot = await _dons
          .where('utilisateur', isEqualTo: userId)
          .get();
    }
    double montantTotal = 0;
    for (final DocumentSnapshot doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      final Don don = Don.fromMap(data);
      final DateTime dateDonation = don.dateDonation.toDate();
      if (dateDonation.month == mois && dateDonation.year == annee) {
        montantTotal += don.montant;
      }
    }

    return montantTotal;
  }

  Future<List<Don>> getDonsByUser(String userId) async {
    final QuerySnapshot snapshot = await _dons
        .where('utilisateur', isEqualTo: userId)
        .orderBy('date_donation', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return Don.fromMap(data);
    }).toList();
  }


//endregion
}
