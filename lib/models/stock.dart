import 'livre.dart';

class Stock {
  String id;
  String adresse;
  String ville;
  String codePostal;
  String description;

  Stock({required this.id, required this.adresse, required this.ville, required this.codePostal, required this.description});

  factory Stock.fromMap(Map<String, dynamic> data) {
    final String id = data['id'];
    final String adresse = data['adresse'];
    final String ville = data['ville'];
    final String codePostal = data['code_postal'];
    final String description = data['description'];

    return Stock(
      id: id,
      adresse: adresse,
      ville: ville,
      codePostal: codePostal,
      description: description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'adresse': adresse,
      'ville': ville,
      'code_postal': codePostal,
      'description': description,
    };
  }
}
