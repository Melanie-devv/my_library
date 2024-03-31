import 'package:flutter/material.dart';

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
          icon: buildIcon(Icons.all_inclusive_rounded, context, 1, 'Librairie'),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: buildIcon(Icons.shop_two_outlined, context, 2, 'Mes Livres'),
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
            page = '/my_showrooms';
            break;
          case 2:
            page = '/flashtaps';
            break;
          case 3:
            page = '/profile';
            break;
        }
        Navigator.pushNamed(context, page);
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