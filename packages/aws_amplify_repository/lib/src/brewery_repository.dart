import 'dart:async';

import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/categories/amplify_categories.dart';
import 'package:backend_repository/backend_repository.dart';
import 'package:backend_repository/src/models/brewery.dart';

import '../aws_amplify_repository.dart' as aws_models;

class AwsAmplifyBreweryRepository extends BreweryRepository {
  final DataStoreCategory datastore;

  AwsAmplifyBreweryRepository(
    this.datastore,
  );

  late final Stream<SubscriptionEvent<aws_models.Brewery>> _stream =
      datastore.observe(aws_models.Brewery.classType);

  Stream<BreweryEvent> get breweryChanges => _stream.map((event) {
        print('GOt event: ${event}');
        switch (event.eventType) {
          case EventType.create:
            return BreweryCreatedEvent();
          case EventType.update:
            return BreweryUpdatedEvent();
          case EventType.delete:
            return BreweryDeletedEvent(event.item.id);
        }
      });

  @override
  Future<List<Brewery>> loadBreweries() {
    return datastore.query(aws_models.Brewery.classType).then((breweries) {
      print('Got ${breweries.length} breweries');
      return breweries
          .map((b) => Brewery(
                id: b.id,
                name: b.name!,
                description: b.description,
                country: b.country,
              ))
          .toList();
    }).catchError((Object e) {
      print('Error: $e');
    });
  }

  @override
  Future<void> deleteBrewery(Brewery brewery) {
    return datastore
        .query(
      aws_models.Brewery.classType,
      where: aws_models.Brewery.ID.eq(brewery.id),
    )
        .then((breweries) async {
      if (breweries.isNotEmpty) {
        return datastore.delete(breweries.first);
      }
      return;
    });
  }
}
