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

  //endregion
}
