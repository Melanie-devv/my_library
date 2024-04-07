import 'package:flutter/material.dart';
import 'package:my_library/services/stock_services.dart';

import 'ajouter_livre_stock_view.dart';

class LivreStockView extends StatefulWidget {
  final String stockId;

  const LivreStockView({required this.stockId});

  @override
  _LivreStockViewState createState() => _LivreStockViewState();
}

class _LivreStockViewState extends State<LivreStockView> {
  final StockServices _stockServices = StockServices();
  Map<String, int> _livres = {};

  @override
  void initState() {
    super.initState();
    _getLivres();
  }

  Future<void> _getLivres() async {
    final livres = await _stockServices.getLivres(widget.stockId);
    for (final livre in livres) {
      _livres[livre] = await _stockServices.getQuantiteEnStock(livre, widget.stockId);
    }
    setState(() {
      _livres = _livres;
    });
  }

  Future<void> _modifierQuantite(String livreId, int quantite) async {
    await _stockServices.ajouterLivre(widget.stockId, livreId, quantite);
    setState(() {
      _livres[livreId] = (_livres[livreId] ?? 0) + quantite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Livres du stock'),
      ),
      body: ListView.builder(
        itemCount: _livres.length,
        itemBuilder: (context, index) {
          final livreId = _livres.keys.elementAt(index);
          final quantite = _livres[livreId] ?? 0;
          return ListTile(
            title: Text(livreId),
            subtitle: Text('Quantité : $quantite'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    _modifierQuantite(livreId, -1);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    _modifierQuantite(livreId, 1);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AjouterLivreStockView(stockId: widget.stockId),
            ),
          );
        },
      ),
    );
  }
}
