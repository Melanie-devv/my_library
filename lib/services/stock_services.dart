import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_library/models/stock.dart';

class StockServices {
  final CollectionReference _stocks = FirebaseFirestore.instance.collection('stocks');

  Future<List<Stock>> getStocks() async {
    final QuerySnapshot snapshot = await _stocks.get();
    return snapshot.docs.map((doc) => Stock.fromMap(doc.data() as Map<String, dynamic>)).toList();
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

  Future<List<String>> getLivres(String stockId) async {
    DocumentSnapshot snapshot = await _stocks.doc(stockId).get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      List<String> livres = data['livres'].keys.toList();
      return livres;
    } else {
      throw Exception('Stock non trouvé');
    }
  }


  Future<int> getQuantiteEnStock(String livreId) async {
    int quantiteTotal = 0;
    QuerySnapshot querySnapshot = await _stocks.get();
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      CollectionReference stockLivresCollection = FirebaseFirestore.instance.collection('stocks').doc(doc.id).collection('livres');
      DocumentSnapshot<Object?> documentSnapshot = await stockLivresCollection.doc(livreId).get();
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      int quantite = (data['quantite']);
      quantiteTotal += quantite;
    }
    return quantiteTotal;
  }


  Future<List<Stock>> getStockContenantLivre(String livreid) async {
    List<Stock> stocksContenantLivre = [];
    QuerySnapshot querySnapshot = await _stocks.where('livres.$livreid', isGreaterThan: 0).get();
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
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
    return stocksContenantLivre;
  }


  Future<void> ajouterLivre(String stockId, String livreId, int quantite) async {
    DocumentReference stockRef = _stocks.doc(stockId);
    DocumentSnapshot stockSnapshot = await stockRef.get();

    if (stockSnapshot.exists) {
      if (stockSnapshot.data() is Map<String, dynamic>) {
        Map<String, dynamic> stockData = stockSnapshot.data() as Map<String, dynamic>;
        Map<String, int> livres = stockData['livres'];

        if (livres.containsKey(livreId)) {
          livres[livreId] = (livres[livreId] ?? 0) + quantite;
        } else {
          livres[livreId] = quantite;
        }

        await stockRef.update({'livres': livres});
      }
    } else {
      throw Exception('Le stock n\'existe pas');
    }
  }

  Future<void> retirerLivre(String stockId, String livreId, int quantite) async {
    DocumentReference stockRef = _stocks.doc(stockId);
    DocumentSnapshot stockSnapshot = await stockRef.get();

    if (stockSnapshot.exists) {
      Map<String, dynamic> stockData = stockSnapshot.data() as Map<String, dynamic>;
      int currentQuantity = stockData['livres'][livreId] ?? 0;

      if (currentQuantity >= quantite) {
        await stockRef.update({
          'livres.$livreId': currentQuantity - quantite,
        });
      } else {
        throw Exception('La quantité restante est insuffisante pour effectuer cette opération.');
      }
    } else {
      throw Exception('Le stock spécifié n\'existe pas.');
    }
  }
  //endregion
}