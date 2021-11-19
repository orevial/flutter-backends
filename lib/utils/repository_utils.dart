import 'package:appwrite/appwrite.dart';
import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:backend_repository/backend_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _appWriteEndpoint = 'http://192.168.1.13:8080/v1';
const _appWriteProject = '619234a0788f4';

enum Backend {
  appwrite,
}

late Backend _backend;

List<RepositoryProvider> backendRepositories(Backend backend) {
  _backend = backend;
  switch (backend) {
    case Backend.appwrite:
      return _appwriteRepositories();
  }
}

List<RepositoryProvider> _appwriteRepositories() {
  final client = Client()
    ..setEndpoint(_appWriteEndpoint)
    ..setProject(_appWriteProject)
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
      ),
    ),
    RepositoryProvider<BreweryRepository>(
      create: (_) => AppwriteBreweryRepository(
        Database(client),
        Realtime(client),
      ),
    ),
  ];
}

String imageUrl(String imageId) {
  switch (_backend) {
    case Backend.appwrite:
      return '$_appWriteEndpoint/storage/files/$imageId/download?project=$_appWriteProject';
  }
}
