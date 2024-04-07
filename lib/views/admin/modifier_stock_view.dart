import 'package:flutter/material.dart';
import 'package:my_library/models/stock.dart';
import 'package:my_library/services/stock_services.dart';

class ModifierStockView extends StatefulWidget {
  final Stock stock;

  const ModifierStockView({required this.stock});

  @override
  _ModifierStockViewState createState() => _ModifierStockViewState();
}

class _ModifierStockViewState extends State<ModifierStockView> {
  final _formKey = GlobalKey<FormState>();
  final StockServices _stockServices = StockServices();

  String _adresse = '';
  String _ville = '';
  String _codePostal = '';
  String _description = '';

  @override
  void initState() {
    super.initState();
    _adresse = widget.stock.adresse;
    _ville = widget.stock.ville;
    _codePostal = widget.stock.codePostal;
    _description = widget.stock.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier un stock'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                initialValue: _adresse,
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
                initialValue: _ville,
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
                initialValue: _codePostal,
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
                initialValue: _description,
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
                maxLines: 5,
                keyboardType: TextInputType.multiline,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final Stock stock = Stock(
                      id: widget.stock.id,
                      adresse: _adresse,
                      ville: _ville,
                      codePostal: _codePostal,
                      description: _description,
                    );
                    _stockServices.updateStock(stock);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Modifier'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}