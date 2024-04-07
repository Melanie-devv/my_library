import 'package:flutter/material.dart';
import 'package:my_library/models/livre.dart';
import 'package:my_library/services/livre_services.dart';
import 'package:my_library/services/stock_services.dart';

import 'ajouter_livre_stock_view.dart';

class LivreStockView extends StatefulWidget {
  final String stockId;

  const LivreStockView({super.key, required this.stockId});

  @override
  _LivreStockViewState createState() => _LivreStockViewState();
}

class _LivreStockViewState extends State<LivreStockView> {
  final StockServices _stockServices = StockServices();
  final LivreServices _livreServices = LivreServices();
  Map<String, int> _livres = {};

  @override
  void initState() {
    super.initState();
    _getLivres();
  }

  Future<void> _getLivres() async {
    final livres = await _stockServices.getLivres(widget.stockId);
    for (final livre in livres) {
      final Livre livreInfo = await _livreServices.getLivreById(livre);
      _livres[livreInfo.id] = await _stockServices.getQuantiteEnStock(livreInfo.id, widget.stockId);
    }
    setState(() {
      _livres = _livres;
    });
  }

  Future<Livre> _getLivreInfo(String livreId) async {
    return await _livreServices.getLivreById(livreId);
  }

  Future<void> _modifierQuantite(String livreId, int quantite) async {
    if (quantite > 0) {
      await _stockServices.ajouterLivre(widget.stockId, livreId, quantite);
    } else {
      await _stockServices.retirerLivre(widget.stockId, livreId, quantite);
    }
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
          return FutureBuilder<Livre>(
            future: _getLivreInfo(livreId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              } else if (snapshot.hasError) {
                return Text('Erreur: ${snapshot.error}');
              } else {
                if (snapshot.data == null) {
                  return const Text('Erreur: Livre non trouvé');
                }
                final Livre livreInfo = snapshot.data!;
                return ListTile(
                  title: Text(livreInfo.titre),
                  subtitle: Text('ID : $livreId \nQuantité : $quantite'),
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
              }
            },
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
