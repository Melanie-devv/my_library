class Livre {
  String id;
  String titre;
  String categorie;
  String description;
  int nombreDePages;
  DateTime datePublication;

  Livre({required this.id, required this.titre, required this.categorie, required this.description, required this.nombreDePages, required this.datePublication});

  factory Livre.fromMap(Map<String, dynamic> data) {
    final String id = data['id'];
    final String titre = data['titre'];
    final String categorie = data['categorie'];
    final String description = data['description'];
    final int nombreDePages = data['nombre_de_pages'];
    final DateTime datePublication = DateTime.fromMillisecondsSinceEpoch(data['date_publication']);

    return Livre(
      id: id,
      titre: titre,
      categorie: categorie,
      description: description,
      nombreDePages: nombreDePages,
      datePublication: datePublication,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titre': titre,
      'categorie': categorie,
      'description': description,
      'nombre_de_pages': nombreDePages,
      'date_publication': datePublication.millisecondsSinceEpoch,
    };
  }
}
