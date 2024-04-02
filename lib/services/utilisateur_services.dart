import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_library/models/utilisateur.dart';

class UtilisateurServices {
  final CollectionReference _utilisateurs = FirebaseFirestore.instance.collection('utilisateurs');

  Future<List<Utilisateur>> getUtilisateurs() async {
    final QuerySnapshot snapshot = await _utilisateurs.get();
    return snapshot.docs.map((doc) => Utilisateur.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

  //region CRUD

  Future<void> addUtilisateur(Utilisateur utilisateur) async {
    _validateUtilisateur(utilisateur);
    await _utilisateurs.add(utilisateur.toMap());
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

  bool _estMineur(DateTime dateNaissance) {
    final DateTime now = DateTime.now();
    final int age = now.year - dateNaissance.year;
    if (now.month < dateNaissance.month || (now.month == dateNaissance.month && now.day < dateNaissance.day)) {
      return true;
    }
    return age < 18;
  }
  //endregion

  //region Autres méthodes

  //endregion
}
