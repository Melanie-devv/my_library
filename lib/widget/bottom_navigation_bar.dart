import 'package:flutter/material.dart';

import '../routes.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final int indexSelected;

  const BottomNavigationBarWidget(this.indexSelected, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: indexSelected,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Theme.of(context).colorScheme.onBackground,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: buildIcon(Icons.home_rounded, context, 0, 'Accueil'),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: buildIcon(Icons.menu_book_rounded, context, 1, 'Favoris'),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: buildIcon(Icons.handshake_rounded, context, 2, 'Soutenez-nous'),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: buildIcon(Icons.person_rounded, context, 3, 'Mon Profil'),
          label: '',
        ),
      ],
      onTap: (index) async {
        if (indexSelected == index) {
          return;
        }

        String page = '/';
        switch (index) {
          case 0:
            page = '/home';
            break;
          case 1:
            page = '/login';
            break;
          case 2:
            page = '/donnation';
            break;
          case 3:
            page = '/profile';
            break;
        }
        Routes.router.navigateTo(context, page);
      },
    );
  }
  Widget buildIcon(IconData icon, BuildContext context, int index, String label) {
    bool isSelected = index == indexSelected;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: isSelected ? BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(0.1),
          ) : null,
          child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: isSelected ? 35.0 : 24.0),
        ),
        if (!isSelected) Text(label),
      ],
    );
  }
}