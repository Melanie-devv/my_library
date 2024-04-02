class Livre {
  String id;
  String titre;
  String categorie;
  String couverture;
  String resume;
  int nombreDePages;
  DateTime datePublication;
  String editeur;

  Livre({required this.id, required this.titre, required this.categorie, required this.couverture, required this.resume, required this.nombreDePages, required this.datePublication, required this.editeur});

  factory Livre.fromMap(Map<String, dynamic> data) {
    final String id = data['id'];
    final String titre = data['titre'];
    final String categorie = data['categorie'];
    final String couverture = data['couverture'];
    final String resume = data['resume'];
    final int nombreDePages = data['nombre_de_pages'];
    final DateTime datePublication = DateTime.fromMillisecondsSinceEpoch(data['date_publication']);
    final String editeur = data['editeur'];

    return Livre(
      id: id,
      titre: titre,
      categorie: categorie,
      couverture: couverture,
      resume: resume,
      nombreDePages: nombreDePages,
      datePublication: datePublication,
      editeur: editeur,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titre': titre,
      'categorie': categorie,
      'couverture': couverture,
      'resume': resume,
      'nombre_de_pages': nombreDePages,
      'date_publication': datePublication.millisecondsSinceEpoch,
      'editeur': editeur,
    };
  }
}
