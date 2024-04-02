import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_library/models/don.dart';

class DonServices {
  final CollectionReference _dons = FirebaseFirestore.instance.collection('dons');

  Future<List<Don>> getDons() async {
    final QuerySnapshot snapshot = await _dons.get();
    return snapshot.docs.map((doc) {
      return Don.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  // CRUD
  Future<void> addDon(Don don) async {
    await _dons.add(don.toMap());
  }

  Future<void> updateDon(Don don) async {
    await _dons.doc(don.id).update(don.toMap());
  }

  Future<void> deleteDon(String id) async {
    await _dons.doc(id).delete();
  }

  // AUTRES METHODES
}
