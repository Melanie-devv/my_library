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
    if (stock.adresse.isEmpty || stock.ville.isEmpty || stock.codePostal.isEmpty || stock.description.isEmpty || stock.livres.isEmpty) {
      throw Exception('Tous les champs sont obligatoires pour un stock');
    }
  }
  //endregion

  //region Autres méthodes

  Future<int> GetQuantiteEnStock(String livreId) async {
    int quantiteTotal = 0;
    QuerySnapshot querySnapshot = await _stocks.get();
    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      Stock stock = Stock.fromMap(documentSnapshot.data() as Map<String, dynamic>);
      if (stock.livres.containsKey(livreId)) {
        quantiteTotal += stock.livres[livreId] ?? 0;
      }
    }
    return quantiteTotal;
  }

  Future<List<Stock>> getStockContenantLivre(String livreid) async {
    List<Stock> stocksContenantLivre = [];
    List<Stock> stocks = await getStocks();

    for (Stock stock in stocks) {
      if (stock.livres.containsKey(livreid) && stock.livres[livreid]! > 0) {
        stocksContenantLivre.add(stock);
      }
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