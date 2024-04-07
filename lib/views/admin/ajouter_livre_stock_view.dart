import 'package:flutter/material.dart';
import 'package:my_library/services/stock_services.dart';

class AjouterLivreStockView extends StatefulWidget {
  final String stockId;

  const AjouterLivreStockView({super.key, required this.stockId});

  @override
  _AjouterLivreStockViewState createState() => _AjouterLivreStockViewState();
}

class _AjouterLivreStockViewState extends State<AjouterLivreStockView> {
  final TextEditingController _livreIdController = TextEditingController();
  final TextEditingController _quantiteController = TextEditingController();
  final StockServices _stockServices = StockServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un livre au stock'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _livreIdController,
              decoration: const InputDecoration(labelText: 'ID du livre'),
            ),
            TextField(
              controller: _quantiteController,
              decoration: const InputDecoration(labelText: 'Quantité'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              child: const Text('Ajouter'),
              onPressed: () async {
                final livreId = _livreIdController.text;
                final quantite = int.tryParse(_quantiteController.text) ?? 0;
                await _stockServices.ajouterLivre(widget.stockId, livreId, quantite);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
