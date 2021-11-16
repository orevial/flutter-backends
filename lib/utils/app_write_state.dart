import 'package:appwrite/appwrite.dart';

class AppWriteState {
  late final Client _client;
  Account? _account;
  Database? _db;
  Realtime? _realtime;

  AppWriteState({required Client client}) {
    _client = client
        .setEndpoint('http://192.168.1.41:8080/v1')
        .setProject('619234a0788f4')
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
}
