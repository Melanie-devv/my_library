import 'package:flutter/material.dart';
import 'package:my_library/models/stock.dart';
import 'package:my_library/services/stock_services.dart';

class AjouterStockView extends StatefulWidget {
  @override
  _AjouterStockViewState createState() => _AjouterStockViewState();
}

class _AjouterStockViewState extends State<AjouterStockView> {
  final _formKey = GlobalKey<FormState>();
  final StockServices _stockServices = StockServices();

  String _adresse = '';
  String _ville = '';
  String _codePostal = '';
  String _description = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un stock'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Adresse'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une adresse';
                  }
                  return null;
                },
                onSaved: (value) {
                  _adresse = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Ville'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une ville';
                  }
                  return null;
                },
                onSaved: (value) {
                  _ville = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Code postal'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un code postal';
                  }
                  return null;
                },
                onSaved: (value) {
                  _codePostal = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final Stock stock = Stock(
                      id: '',
                      adresse: _adresse,
                      ville: _ville,
                      codePostal: _codePostal,
                      description: _description,
                    );
                    _stockServices.addStock(stock);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Ajouter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
