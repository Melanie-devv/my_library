import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_library/models/stock.dart';

class StockServices {
  final CollectionReference _stocks = FirebaseFirestore.instance.collection('stocks');

  Future<List<Stock>> getStocks() async {
  final QuerySnapshot snapshot = await _stocks.get();
  return snapshot.docs.map((doc) {
    final data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    return Stock.fromMap(data);
  }).toList();
}

  //region CRUD
  Future<void> addStock(Stock stock) async {
    _validateStock(stock);
    await _stocks.add(stock.toMap());
  }

  Future<void> updateStock(Stock stock) async {
    _validateStock(stock);
    await _stocks.doc(stock.id).update(stock.toMap());
  }

  Future<void> deleteStock(String id) async {
    await _stocks.doc(id).delete();
  }
  //endregion

  //region Validation

  void _validateStock(Stock stock) {
    if (stock.adresse.isEmpty || stock.ville.isEmpty || stock.codePostal.isEmpty || stock.description.isEmpty) {
      throw Exception('Tous les champs sont obligatoires pour un stock');
    }
  }
  //endregion

  //region Autres méthodes

  Future<Stock> getStockById(String stockId) async {
    final DocumentSnapshot snapshot = await _stocks.doc(stockId).get();
    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      data['id'] = snapshot.id;
      return Stock.fromMap(data);
    } else {
      throw Exception('Stock introuvable');
    }
  }

  Future<List<String>> getLivres(String stockId) async {
    final QuerySnapshot snapshot = await _stocks.doc(stockId).collection('livres').get();
    if (snapshot.docs.isNotEmpty) {
      List<String> livres = snapshot.docs.map((doc) => doc.id).toList();
      return livres;
    } else {
      throw Exception('Aucun livre trouvé dans ce stock');
    }
  }


  Future<int> getQuantiteTotaleEnStock(String livreId) async {
    int quantiteTotal = 0;
    QuerySnapshot querySnapshot = await _stocks.get();
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      CollectionReference stockLivresCollection = FirebaseFirestore.instance.collection('stocks').doc(doc.id).collection('livres');
      DocumentSnapshot<Object?> documentSnapshot = await stockLivresCollection.doc(livreId).get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        int quantite = (data['quantite']);
        quantiteTotal += quantite;
      }
    }
    return quantiteTotal;
  }

  Future<int> getQuantiteEnStock(String livreId, String stockId) async {
    DocumentReference livreRef = _stocks.doc(stockId).collection('livres').doc(livreId);
    DocumentSnapshot livreSnapshot = await livreRef.get();

    if (livreSnapshot.exists) {
      Map<String, dynamic> livreData = livreSnapshot.data() as Map<String, dynamic>;
      int quantite = livreData['quantite'] ?? 0;
      return quantite;
    } else {
      throw Exception('Le livre spécifié n\'existe pas dans ce stock.');
    }
  }


  Future<List<Stock>> getStockContenantLivre(String livreId) async {
    List<Stock> stocksContenantLivre = [];
    QuerySnapshot querySnapshot = await _stocks.get();
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      DocumentSnapshot livreSnapshot = await doc.reference.collection('livres').doc(livreId).get();
      if (livreSnapshot.exists) {
        Map<String, dynamic> livreData = livreSnapshot.data() as Map<String, dynamic>;
        if (livreData['quantite'] > 0) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          Stock stock = Stock(
            id: doc.id,
            adresse: data['adresse'],
            ville: data['ville'],
            codePostal: data['code_postal'],
            description: data['description'],
          );
          stocksContenantLivre.add(stock);
        }
      }
    }
    return stocksContenantLivre;
  }


  Future<void> ajouterLivre(String stockId, String livreId, int quantite) async {
    DocumentReference livreRef = _stocks.doc(stockId).collection('livres').doc(livreId);
    DocumentSnapshot livreSnapshot = await livreRef.get();

    if (livreSnapshot.exists) {
      Map<String, dynamic> livreData = livreSnapshot.data() as Map<String, dynamic>;
      int currentQuantity = livreData['quantite'] ?? 0;
      await livreRef.update({'quantite': currentQuantity + quantite});
    } else {
      await livreRef.set({'quantite': quantite});
    }
  }

  Future<void> retirerLivre(String stockId, String livreId, int quantite) async {
    DocumentReference livreRef = _stocks.doc(stockId).collection('livres').doc(livreId);
    DocumentSnapshot livreSnapshot = await livreRef.get();

    if (livreSnapshot.exists) {
      Map<String, dynamic> stockData = livreSnapshot.data() as Map<String, dynamic>;
      int currentQuantity = stockData['quantite'] ?? 0;

      if (currentQuantity + quantite < 0) {
        throw Exception('La quantité à retirer est supérieure à la quantité en stock.');
      }

      await livreRef.update({'quantite': currentQuantity + quantite});
    } else {
      throw Exception('Le stock spécifié n\'existe pas.');
    }
  }
  //endregion
}