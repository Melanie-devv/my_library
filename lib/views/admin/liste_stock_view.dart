import 'package:flutter/material.dart';
import 'package:my_library/models/stock.dart';
import 'package:my_library/services/stock_services.dart';
import 'package:my_library/views/admin/modifier_stock_view.dart';

class ListeStocksView extends StatefulWidget {
  @override
  _ListeStocksViewState createState() => _ListeStocksViewState();
}

class _ListeStocksViewState extends State<ListeStocksView> {
  final StockServices _stockServices = StockServices();

  List<Stock> _stocks = [];

  @override
  void initState() {
    super.initState();
    _getStocks();
  }

  Future<void> _getStocks() async {
    final List<Stock> stocks = await _stockServices.getStocks();
    setState(() {
      _stocks = stocks;
    });
  }

  Future<void> _deleteStock(String id) async {
    await _stockServices.deleteStock(id);
    _getStocks();
  }

  Future<void> _showConfirmationDialog(String id) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Suppression d\'un stock'),
          content: const Text('Êtes-vous sûr de vouloir supprimer ce stock ?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Supprimer'),
              onPressed: () {
                _deleteStock(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Gestion des stocks',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _stocks.length,
              itemBuilder: (context, index) {
                final Stock stock = _stocks[index];
                return ListTile(
                  title: Text(stock.adresse),
                  subtitle: Text('${stock.ville} ${stock.codePostal}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ModifierStockView(stock: stock),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _showConfirmationDialog(stock.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
