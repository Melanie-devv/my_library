import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_library/models/stock.dart';

class StockServices {
  final CollectionReference _stocks = FirebaseFirestore.instance.collection('stocks');

  Future<List<Stock>> getStocks() async {
    final QuerySnapshot snapshot = await _stocks.get();
    return snapshot.docs.map((doc) {
      return Stock.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  // CRUD
  Future<void> addStock(Stock stock) async {
    await _stocks.add(stock.toMap());
  }

  Future<void> updateStock(Stock stock) async {
    await _stocks.doc(stock.id).update(stock.toMap());
  }

  Future<void> deleteStock(String id) async {
    await _stocks.doc(id).delete();
  }

  // AUTRES METHODES
}
