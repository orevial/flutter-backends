import 'dart:math';

import 'package:appwrite/models.dart';
import 'package:appwrite_app/utils/app_write_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'authentication/authentication_cubit.dart';
import 'breweries/pages/brewery_list_page.dart';
import 'main.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Bl
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.read<AuthenticationCubit>().logout(),
              child: const Text('Logout'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<AppWriteState>().database.createDocument(
                  collectionId: breweryCollectionId,
                  data: {
                    'name': getRandomString(15),
                  },
                );
              },
              child: const Text('Create random brewery'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => const BreweryListPage(),
                  ),
                );
              },
              child: const Text('> Breweries'),
            ),
          ],
        ),
      ),
    );
  }
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

extension SessionUtils on Session {
  String toString2() {
    return 'Session[UserId: $userId, Provider: $provider, Provider Uid: $providerUid, Provider token: $providerToken]';
  }
}
