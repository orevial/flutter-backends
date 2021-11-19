import 'dart:async';

import 'package:backend_repository/src/models/brewery.dart';

import 'models/beer.dart';

abstract class BeersRepository {
  Future<List<Beer>> loadBreweryBeers(Brewery brewery);
  Future<List<Beer>> loadStyleBeers(String style);
}
