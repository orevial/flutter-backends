import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:backend_repository/backend_repository.dart';
import 'package:backend_repository/src/models/brewery.dart';

import 'appwrite_utils.dart';

class AppwriteBreweryRepository extends BreweryRepository {
  final Database database;
  final Realtime realtime;

  AppwriteBreweryRepository(this.database, this.realtime);

  late final Stream<RealtimeMessage> _stream =
      realtime.subscribe(['collections.$breweryCollectionId.documents']).stream;

  Stream<BreweryEvent> get breweryChanges => _stream.map((message) {
        switch (message.event) {
          case 'database.documents.create':
            return BreweryCreatedEvent();
          case 'database.documents.update':
            return BreweryUpdatedEvent();
          case 'database.documents.delete':
            return BreweryDeletedEvent(message.payload[r'$id']);
        }
        throw 'Unknown event type';
      });

  @override
  Future<List<Brewery>> loadBreweries() {
    return database
        .listDocuments(collectionId: breweryCollectionId)
        .then((listDocs) {
      return listDocs.documents
          .map((d) => Brewery(
                id: d.$id,
                name: d.data['name'],
                description: d.data['description'],
                country: d.data['country'],
              ))
          .toList();
    });
  }

  @override
  Future<void> deleteBrewery(Brewery brewery) {
    return database.deleteDocument(
      collectionId: breweryCollectionId,
      documentId: brewery.id,
    );
  }
}
