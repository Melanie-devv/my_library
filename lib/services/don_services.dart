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
      dateDonnation: DateTime.now(),
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
    if (don.dateDonnation.isAfter(DateTime.now())) {
      throw Exception('La date du don ne peut pas être dans le futur');
    }
  }
  //endregion

  //region Autres méthodes

  //endregion
}
