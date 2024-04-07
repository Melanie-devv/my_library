import 'package:flutter/material.dart';
import 'package:my_library/views/admin/ajouter_livre_view.dart';
import 'package:my_library/views/admin/ajouter_stock_view.dart';
import 'package:my_library/views/admin/liste_livre_view.dart';
import 'package:my_library/views/admin/liste_stock_view.dart';

class AdministrationView extends StatefulWidget {
  @override
  _AdministrationViewState createState() => _AdministrationViewState();
}

class _AdministrationViewState extends State<AdministrationView> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    ListeLivresView(),
    ListeStocksView(),
    const Center(child: Text('Auteurs')),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administration'),
        centerTitle: true,
      ),
      body: _children[_currentIndex],
      floatingActionButton: (_currentIndex == 0)
          ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AjouterLivreView()),
          );
        },
        child: const Icon(Icons.add),
      )
          : (_currentIndex == 1)
          ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AjouterStockView()),
          );
        },
        child: const Icon(Icons.add),
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Livres',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Stocks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Auteurs',
          ),
        ],
      ),
    );
  }
}
