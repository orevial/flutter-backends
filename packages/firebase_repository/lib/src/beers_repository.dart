import 'dart:async';

import 'package:backend_repository/backend_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../firebase_repository.dart';

class FirebaseBeersRepository extends BeersRepository {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;
  final FirebaseSettings settings;

  FirebaseBeersRepository(
    this.firestore,
    this.storage,
    this.settings,
  );

  @override
  Future<List<Beer>> loadBreweryBeers(Brewery brewery) {
    return firestore
        .collection(settings.breweryCollectionId)
        .doc(brewery.id)
        .collection(settings.beerCollectionId)
        .get()
        .then(
          (snapshot) =>
              snapshot.docs.map((d) => parseBeer(d.id, d.data())).toList(),
        );
  }

  @override
  Future<List<Beer>> loadStyleBeers(String style) {
    return firestore
        .collectionGroup(settings.beerCollectionId)
        .where('style', isEqualTo: style)
        .get()
        .then(
          (snapshot) =>
              snapshot.docs.map((d) => parseBeer(d.id, d.data())).toList(),
        )
        .catchError((Object e) {
      print(e);
    });
  }

  Beer parseBeer(String id, Map<String, dynamic> doc) {
    return Beer(
      id: id,
      name: doc['name'],
      type: doc['type'],
      abv: doc['abv'],
      imageId:
          doc.containsKey('imageInternalId') ? doc['imageInternalId'] : null,
    );
  }

  @override
  Future<String?> beerImageUrl(Beer beer) async {
    try {
      final url = await storage.ref('${beer.imageId}.jpg').getDownloadURL();
      return url;
    } catch (_) {
      print('No image found ?!');
      return null;
    }
  }
}
