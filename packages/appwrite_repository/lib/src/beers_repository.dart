import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite_repository/src/settings.dart';
import 'package:backend_repository/backend_repository.dart';

class AppwriteBeersRepository extends BeersRepository {
  final Database database;
  final AppWriteSettings settings;

  AppwriteBeersRepository(this.database, this.settings);

  @override
  Future<List<Beer>> loadBreweryBeers(Brewery brewery) {
    return database
        .getDocument(
          collectionId: settings.breweryCollectionId,
          documentId: brewery.id,
        )
        .then((doc) => doc.data['beers'] as List<dynamic>)
        .then(
          (docs) => docs
              .map((d) => d as Map<String, dynamic>)
              .map(parseBeer)
              .toList(),
        );
  }

  @override
  Future<List<Beer>> loadStyleBeers(String style) {
    return database
        .listDocuments(
          collectionId: settings.beersCollectionId,
          filters: ['type=$style'],
          limit: 10,
          orderType: '',
        )
        .then((docList) => docList.documents)
        .then(
          (docs) => docs.map((d) => d.data).map(parseBeer).toList(),
        );
  }

  Beer parseBeer(Map<String, dynamic> doc) {
    return Beer(
      id: doc[r'$id'],
      name: doc['name'],
      type: doc['type'],
      abv: doc['abv'],
      imageId: doc['internal_image_id'],
    );
  }

  @override
  Future<String?> beerImageUrl(Beer beer) async =>
      '${settings.endpoint}/storage/files/${beer.imageId}/download?project=${settings.projectId}';
}
