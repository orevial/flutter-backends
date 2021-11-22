import 'dart:async';

import 'package:backend_repository/backend_repository.dart';
import 'package:backend_repository/src/models/brewery.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase_repository.dart';

class FirebaseBreweryRepository extends BreweryRepository {
  final FirebaseFirestore firestore;
  final FirebaseSettings settings;

  FirebaseBreweryRepository(
    this.firestore,
    this.settings,
  );

  late final Stream<QuerySnapshot<Map<String, dynamic>>> _stream =
      firestore.collection(settings.breweryCollectionId).snapshots();

  Stream<BreweryEvent> get breweryChanges => _stream.expand((message) {
        return message.docChanges.map((e) {
          switch (e.type) {
            case DocumentChangeType.added:
              return BreweryCreatedEvent();
            case DocumentChangeType.modified:
              return BreweryUpdatedEvent();
            case DocumentChangeType.removed:
              return BreweryDeletedEvent(e.doc.id);
          }
        });
      });

  @override
  Future<List<Brewery>> loadBreweries() {
    return firestore
        .collection(settings.breweryCollectionId)
        .get()
        .then((snapshot) => snapshot.docs
            .map(
              (d) => Brewery(
                id: d.id,
                name: d.data()['name'],
                description: d.data()['description'],
                country: d.data()['country'],
              ),
            )
            .toList());
  }

  @override
  Future<void> deleteBrewery(Brewery brewery) {
    return firestore
        .collection(settings.breweryCollectionId)
        .doc(brewery.id)
        .delete();
  }
}
