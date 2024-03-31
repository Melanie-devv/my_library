class Stock {
  String id;
  String adresse;
  String ville;
  String codePostal;
  String description;
  Map<String, int> livres;

  Stock({required this.id, required this.adresse, required this.ville, required this.codePostal, required this.description, required this.livres});

  factory Stock.fromMap(Map<String, dynamic> data) {
    final String id = data['id'];
    final String adresse = data['adresse'];
    final String ville = data['ville'];
    final String codePostal = data['code_postal'];
    final String description = data['description'];
    final Map<String, int> livres = Map<String, int>.from(data['livres']);

    return Stock(
      id: id,
      adresse: adresse,
      ville: ville,
      codePostal: codePostal,
      description: description,
      livres: livres,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'adresse': adresse,
      'ville': ville,
      'code_postal': codePostal,
      'description': description,
      'livres': livres,
    };
  }
}
