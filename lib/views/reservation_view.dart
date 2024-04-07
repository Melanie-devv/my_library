import 'package:flutter/material.dart';
import 'package:my_library/extensions.dart';
import 'package:my_library/models/livre.dart';
import 'package:my_library/models/stock.dart';
import 'package:my_library/services/livre_services.dart';
import 'package:my_library/services/stock_services.dart';
import 'package:my_library/widget/bottom_navigation_bar.dart';

import '../services/reservation_services.dart';

class ReservationView extends StatefulWidget {
  final String livreId;

  const ReservationView({required this.livreId});

  @override
  _ReservationViewState createState() => _ReservationViewState();
}

class _ReservationViewState extends State<ReservationView> {
  late Livre _livre;
  late List<Stock> _stocks;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _livre = await LivreServices().getLivreById(widget.livreId);
    _stocks = await StockServices().getStockContenantLivre(_livre.id);
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _showConfirmationDialog(Stock stock) async {
    final DateTime now = DateTime.now();
    final DateTime reservationDate = DateTime(now.year, now.month + 1, now.day);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirmation de réservation',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          content: Wrap(
            children: [
              const Center(
                child: Text('Etes vous sur de vouloir réserver ce livre ?',),
              ),
              Center(
                child: Text(
                  'du ${now.formatDate()} au ${reservationDate.formatDate()}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: const Text('Quitter'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(width: 16),
                TextButton(
                  child: const Text('Confirmer'),
                  onPressed: () async {
                    try {
                      await ReservationServices().addReservation(_livre.id);
                      Navigator.of(context).pop();
                      // TODO: rediriger vers la page info reservation
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Le livre a été réservé avec succès.'),
                          backgroundColor: Colors.green,
                        )
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_livre.titre),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Reserver votre livre',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const Text(
            'Vous ne pouvez reserver qu\'un livre à la fois.',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _stocks.length,
              itemBuilder: (BuildContext context, int index) {
                final Stock stock = _stocks[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      title: Text(stock.adresse),
                      subtitle: Text('${stock.ville} ${stock.codePostal}'),
                      leading: const Icon(
                          Icons.warehouse_rounded,
                          size: 40,
                      ),
                      trailing: ElevatedButton(
                        onPressed: () async {
                          _showConfirmationDialog(stock);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Réserver',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                          stock.description,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 15,
                          ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(1),
    );
  }
}
