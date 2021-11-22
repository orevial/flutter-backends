import 'package:appwrite/appwrite.dart';
import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:backend_repository/backend_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_repository/firebase_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum Backend {
  appwrite,
  firebase,
}

Future<List<RepositoryProvider>> backendRepositories(Backend backend) {
  switch (backend) {
    case Backend.appwrite:
      return _appwriteRepositories();
    case Backend.firebase:
      return _firebaseRepositories();
  }
}

Future<List<RepositoryProvider>> _appwriteRepositories() async {
  final _appWriteSettings = AppWriteSettings(
    endpoint: 'http://192.168.1.13:8080/v1',
    projectId: '619234a0788f4',
    breweryCollectionId: '61976f7693b87',
    beersCollectionId: '61976f7684a41',
  );

  final client = Client()
    ..setEndpoint(_appWriteSettings.endpoint)
    ..setProject(_appWriteSettings.projectId)
    ..setSelfSigned(status: true);

  return [
    RepositoryProvider<AuthenticationRepository>(
      create: (_) => AppwriteAuthenticationRepository(
        Account(client),
      ),
    ),
    RepositoryProvider<BeersRepository>(
      create: (_) => AppwriteBeersRepository(
        Database(client),
        _appWriteSettings,
      ),
    ),
    RepositoryProvider<BreweryRepository>(
      create: (_) => AppwriteBreweryRepository(
        Database(client),
        Realtime(client),
        _appWriteSettings,
      ),
    ),
  ];
}

Future<List<RepositoryProvider>> _firebaseRepositories() async {
  final _firebaseSettings = FirebaseSettings(
    breweryCollectionId: 'breweries',
    beerCollectionId: 'beers',
  );

  await Firebase.initializeApp();

  return [
    RepositoryProvider<AuthenticationRepository>(
      create: (_) => FirebaseAuthenticationRepository(
        FirebaseAuth.instance,
      ),
    ),
    RepositoryProvider<BeersRepository>(
      create: (_) => FirebaseBeersRepository(
        FirebaseFirestore.instance,
        FirebaseStorage.instance,
        _firebaseSettings,
      ),
    ),
    RepositoryProvider<BreweryRepository>(
      create: (_) => FirebaseBreweryRepository(
        FirebaseFirestore.instance,
        _firebaseSettings,
      ),
    ),
  ];
}
