import 'package:flutter/material.dart';

import '../../routes.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyLibrary'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30, top: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Inscription réussie',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 20),
                Text(
                  'Bienvenue de la part de notre équipe MyLibrary !',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  'Maintenant, complétons votre profil',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () => {
                Routes.router.navigateTo(context, '/setup'),
              },
              child: const Text('Continuer'),
            )
          ],
        ),
      ),
    );
  }
}