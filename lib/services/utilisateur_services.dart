import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_library/models/utilisateur.dart';

import '../models/don.dart';
import 'don_services.dart';

class UtilisateurServices {
  final CollectionReference _utilisateurs = FirebaseFirestore.instance.collection('utilisateurs');

  Future<List<Utilisateur>> getUtilisateurs() async {
    final QuerySnapshot snapshot = await _utilisateurs.get();
    return snapshot.docs.map((doc) => Utilisateur.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  //region CRUD

  Future<void> addUtilisateur (Utilisateur user) async {
    try {
      _validateUtilisateur(user);
      await _utilisateurs.doc(user.id).set(user.toMap());
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout de l\'utilisateur : $e');
    }
  }


  Future<void> updateUtilisateur(Utilisateur utilisateur) async {
    _validateUtilisateur(utilisateur);
    await _utilisateurs.doc(utilisateur.id).update(utilisateur.toMap());
  }

  Future<void> deleteUtilisateur(String id) async {
    await _utilisateurs.doc(id).delete();
  }
  //endregion

  //region Validation

  Future<void> _validateUtilisateur(Utilisateur utilisateur) async {
    if (utilisateur.nom.isEmpty || utilisateur.prenom.isEmpty || utilisateur.email.isEmpty) {
      throw Exception('Tous les champs sont obligatoires pour un utilisateur');
    }
    if (await _utilisateurExisteDeja(utilisateur.email)) {
      throw Exception('Cet email est déjà utilisé');
    }
    if (_estMineur(utilisateur.dateNaissance)) {
      throw Exception('Vous devez avoir au moins 18 ans pour vous inscrire');
    }
  }

  Future<bool> _utilisateurExisteDeja(String email) async {
    final QuerySnapshot result = await _utilisateurs.where('email', isEqualTo: email).get();
    return result.size > 0;
  }

  bool _estMineur(Timestamp dateNaissanceTimestamp) {
  final DateTime now = DateTime.now();
  final DateTime dateNaissance = dateNaissanceTimestamp.toDate();
  final int age = now.year - dateNaissance.year;
  if (now.month < dateNaissance.month || (now.month == dateNaissance.month && now.day < dateNaissance.day)) {
    return true;
  }
  return age < 18;
}
  //endregion

  //region Autres méthodes

  Future<String?> getCurrentUid() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    return user?.uid;
  }

  Future<Utilisateur?> getUserById(String userId) async {
    final DocumentSnapshot doc = await _utilisateurs.doc(userId).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return Utilisateur.fromMap(data);
    } else {
      return null;
    }
  }

  Future<double> getMontantTotalDons(String userId) async {
    final List<Don> dons = await DonServices().getDonsByUser(userId);
    double montantTotal = 0.0;
    for (final Don don in dons) {
      montantTotal += don.montant;
    }
    return montantTotal;
  }
  //endregion
}
