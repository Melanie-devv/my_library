import 'package:flutter/material.dart';
import 'package:my_library/widget/bottom_navigation_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/don_services.dart';

class DonationView extends StatefulWidget {
  @override
  _DonationViewState createState() => _DonationViewState();
}

class _DonationViewState extends State<DonationView> {
  final TextEditingController _amountController = TextEditingController();
  final String paymentLink = 'https://donate.stripe.com/test_00g7vY0Is0c14wM9AA';

  Future<void> _saveDonationAmount() async {
    final amount = double.tryParse(_amountController.text);
    await DonServices().addDon(amount!);
    _amountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Qui sommes nous'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network('https://images.ladepeche.fr/api/v1/images/view/6048468ed286c26a9808f59a/large/image.jpg?v=1'),
            const SizedBox(height: 16.0),
            const Text(
              'MyLibrary est une bibliothèque en ligne qui a pour but de promouvoir la lecture et la culture. Nous offrons un accès gratuit à des milliers de livres numériques, ainsi qu\'à des ressources pédagogiques pour les enseignants et les étudiants.',
              style: TextStyle(fontSize: 18.0, fontFamily: 'YourCustomFont'),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 30.0),
            const Text(
              'Votre don nous aidera à maintenir et à améliorer notre plateforme, ainsi qu\'à ajouter de nouveaux livres et ressources pour nos utilisateurs.',
              style: TextStyle(fontSize: 18.0, fontFamily: 'YourCustomFont'),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 40.0),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Montant du don',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.euro),
                  onPressed: _saveDonationAmount,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                  shadowColor: Colors.blueAccent,
                  elevation: 10,
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  _saveDonationAmount();
                  launchUrl(Uri.parse(paymentLink));
                },
                child: const Text('Faire un don'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(2),
    );
  }
}
