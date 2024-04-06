import 'package:flutter/material.dart';
import 'package:my_library/models/don.dart';
import 'package:my_library/services/don_services.dart';
import 'package:my_library/services/utilisateur_services.dart';

import '../routes.dart';

class ProfilDonationsView extends StatefulWidget {
  @override
  _ProfilDonationsViewState createState() => _ProfilDonationsViewState();
}

class _ProfilDonationsViewState extends State<ProfilDonationsView> {
  List<Don> _dons = [];
  double _montantTotal = 0.0;

  @override
  void initState() {
    super.initState();
    _getDons();
  }

  Future<void> _getDons() async {
    final String? currentUid = await UtilisateurServices().getCurrentUid();
    if (currentUid == null) {
      return;
    }
    final List<Don> dons = await DonServices().getDonsByUser(currentUid);
    final double montantTotal = await UtilisateurServices().getMontantTotalDons(currentUid);
    setState(() {
      _dons = dons;
      _montantTotal = montantTotal;
    });
  }

  Future<double> _getMontantTotalParMois() async {
    final String? currentUid = await UtilisateurServices().getCurrentUid();
    if (currentUid == null) {
      return 0.0;
    }
    return await DonServices().getMontantTotalParMois(DateTime.now().month, DateTime.now().year, currentUid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes donations'),
      ),
      body: Center(
        child: _dons.isEmpty
            ? FractionallySizedBox(
                widthFactor: 0.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    const Text(
                      'Vous n\'avez pas encore fait de donnation, si vous souhaitez nous soutenir, cliquez sur le bouton ci dessous. Merci :).',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        Routes.router.navigateTo(context, '/donation');
                      },
                      child: const Text('Faire un don'),
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Vous nous avez donné au total',
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${_montantTotal.toStringAsFixed(2)} €',
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  const SizedBox(height: 16),
                  const FractionallySizedBox(
                    widthFactor: 0.9,
                    child: Text(
                      'Nous vous remercions pour votre soutient et vous souhaitons une agréable utilisation de notre application. Merci :)',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  FutureBuilder<double>(
                    future: _getMontantTotalParMois(),
                    builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text('Erreur lors de la récupération du montant total des dons de ce mois');
                      } else {
                        final double montantTotal = snapshot.data!;
                        return Text('Montant donné ce mois ci : ${montantTotal.toStringAsFixed(2)} €', style: const TextStyle(fontSize: 18));
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  ..._dons.map((don) =>
                      ListTile(
                        title: Row(
                          children: [
                            const Icon(Icons.price_check_rounded),
                            const SizedBox(width: 8.0),
                            Text('Vous nous avez donné ${don.montant.toStringAsFixed(2)} €'),
                          ],
                        ),
                        subtitle: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                              'le ${don.dateDonation.toDate().day}/${don.dateDonation.toDate().month}/${don.dateDonation.toDate().year}'
                          ),
                        ),
                      )),
                ],
              ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(50.0),
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
            Routes.router.navigateTo(context, '/donation');
          },
          child: const Text('Faire un don'),
        ),
      ),
    );
  }
}