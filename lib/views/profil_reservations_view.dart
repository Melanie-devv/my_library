import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_library/models/reservation.dart';
import 'package:my_library/services/livre_services.dart';
import 'package:my_library/services/reservation_services.dart';

import '../services/stock_services.dart';

class ProfilReservationsView extends StatefulWidget {
  @override
  _ProfilReservationsViewState createState() => _ProfilReservationsViewState();
}

class _ProfilReservationsViewState extends State<ProfilReservationsView> {
  final ReservationServices _reservationServices = ReservationServices();
  List<Reservation> _reservationsEnCours = [];
  List<Reservation> _reservationsPassees = [];

  @override
  void initState() {
    super.initState();
    _getReservations();
  }

  Future<void> _getReservations() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    final List<Reservation> reservations = await _reservationServices.getReservationsByUser(user.uid);
    setState(() {
      _reservationsEnCours = reservations.where((reservation) => reservation.isEnCours()).toList();
      _reservationsPassees = reservations.where((reservation) => !reservation.isEnCours()).toList();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vos réservations'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_reservationsEnCours.isNotEmpty) ...[
              Text('Vous avez ${_reservationsEnCours.length} réservation${_reservationsEnCours.length > 1 ? 's' : ''} en cours :'),
              ..._reservationsEnCours.map((reservation) {
                return FutureBuilder<Widget>(
                  future: _buildReservationCard(reservation, true),
                  builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return snapshot.data ?? const SizedBox.shrink(); // widget to display
                      }
                    }
                  },
                );
              }).toList(),
            ] else ...[
              const Text('Vous n\'avez aucune réservation en cours.'),
            ],
            if (_reservationsPassees.isNotEmpty) ...[
              const SizedBox(height: 16.0),
              const Text('Vos réservations passées :'),
              ..._reservationsPassees.map((reservation) {
                return FutureBuilder<Widget>(
                  future: _buildReservationCard(reservation, false),
                  builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return snapshot.data ?? const SizedBox.shrink();
                      }
                    }
                  },
                );
              }).toList(),
            ] else ...[
              const SizedBox(height: 16.0),
              const Text('Vous n\'avez aucune réservation passée.'),
            ],
          ],
        ),
      ),
    );
  }

  Future<Widget> _buildReservationCard(Reservation reservation, bool isEnCours) async {
    final livre = await LivreServices().getLivreById(reservation.livre);
    final stock = await StockServices().getStockById(reservation.stock);
    final dateDebut = reservation.dateDebutReservation.toDate();
    final dateFin = reservation.dateFinReservation.toDate();
    final nbJoursRestants = dateFin.difference(DateTime.now()).inDays;

    return Card(
      color: isEnCours ? Colors.green[100] : null,
      child: ListTile(
        leading: Image.network(
            livre.couverture,
            fit: BoxFit.fill,
            width: 40,
          ),
        title: Text('${livre.titre}'),
        subtitle: Text('Réservé du ${dateDebut.day}/${dateDebut.month}/${dateDebut.year} au ${dateFin.day}/${dateFin.month}/${dateFin.year} \n${stock.adresse} à ${stock.ville} ${isEnCours ? '\n$nbJoursRestants jours restants' : ''}'),
      ),
    );
  }
}