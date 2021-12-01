import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:aws_amplify_repository/aws_amplify_repository.dart';
import 'package:backend_repository/backend_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_repository/firebase_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_backends/amplifyconfiguration.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_repository/supabase_repository.dart';

enum Backend {
  appwrite,
  awsAmplify,
  firebase,
  supabase,
}

Future<List<RepositoryProvider>> backendRepositories(Backend backend) {
  switch (backend) {
    case Backend.appwrite:
      return _appwriteRepositories();
    case Backend.awsAmplify:
      return _awsAmplifyRepositories();
    case Backend.firebase:
      return _firebaseRepositories();
    case Backend.supabase:
      return _supabaseRepositories();
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

Future<List<RepositoryProvider>> _supabaseRepositories() async {
  final _supabaseSettings = SupabaseSettings(
    endpoint: 'https://mebukugmpmblkomnmjit.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYzNzY3NTA1OSwiZXhwIjoxOTUzMjUxMDU5fQ.eo2udr7c9Qx2QNicz9FGjL01h2EzTqHvwVbJzGldPvc',
    breweryCollectionId: 'breweries',
    beersCollectionId: 'beers',
  );

  final supabase = await Supabase.initialize(
    url: _supabaseSettings.endpoint,
    anonKey: _supabaseSettings.anonKey,
  );

  return [
    RepositoryProvider<AuthenticationRepository>(
      create: (_) => SupabaseAuthenticationRepository(
        supabase.client.auth,
      ),
    ),
    RepositoryProvider<BeersRepository>(
      create: (_) => SupabaseBeersRepository(
        supabase.client,
        _supabaseSettings,
      ),
    ),
    RepositoryProvider<BreweryRepository>(
      create: (_) => SupabaseBreweryRepository(
        supabase.client,
        _supabaseSettings,
      ),
    ),
  ];
}

Future<List<RepositoryProvider>> _awsAmplifyRepositories() async {
  await Amplify.addPlugin(AmplifyAuthCognito());
  await Amplify.addPlugin(
    AmplifyDataStore(modelProvider: ModelProvider.instance),
  );
  await Amplify.configure(amplifyconfig);
  return [
    RepositoryProvider<AuthenticationRepository>(
      create: (_) => AwsAmplifyAuthenticationRepository(
        Amplify.Auth,
        Amplify.Hub,
      ),
    ),
    RepositoryProvider<BeersRepository>(
      create: (_) => AwsAmplifyBeersRepository(
        Amplify.DataStore,
      ),
    ),
    RepositoryProvider<BreweryRepository>(
      create: (_) => AwsAmplifyBreweryRepository(
        Amplify.DataStore,
      ),
    ),
  ];
}
