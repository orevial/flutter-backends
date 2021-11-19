import 'package:appwrite/appwrite.dart';

const _appWriteEndpoint = 'http://192.168.1.13:8080/v1';
const _appWriteProject = '619234a0788f4';
const breweryCollectionId = '61976f7693b87';
const beersCollectionId = '61976f7684a41';

class AppWriteState {
  late final Client _client;
  Account? _account;
  Database? _db;
  Realtime? _realtime;

  AppWriteState({required Client client}) {
    _client = client
        .setEndpoint(_appWriteEndpoint)
        .setProject(_appWriteProject)
        .setSelfSigned(status: true);
  }

  Account get account {
    return _account ??= Account(_client);
  }

  Database get database {
    return _db ??= Database(_client);
  }

  Realtime get realtime {
    return _realtime ??= Realtime(_client);
  }

  String imageUrl(String imageId) =>
      '$_appWriteEndpoint/storage/files/$imageId/download?project=$_appWriteProject';
}
