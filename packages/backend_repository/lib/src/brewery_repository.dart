import 'dart:async';

import 'package:backend_repository/src/models/brewery.dart';

import 'events/brewery_events.dart';

abstract class BreweryRepository {
  Future<List<Brewery>> loadBreweries();

  Future<void> deleteBrewery(Brewery brewery);

  Stream<BreweryEvent> get breweryChanges;
}
