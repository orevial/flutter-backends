import 'dart:async';

import 'package:amplify_flutter/categories/amplify_categories.dart';
import 'package:backend_repository/backend_repository.dart';

import '../aws_amplify_repository.dart' as aws_models;

class AwsAmplifyBeersRepository extends BeersRepository {
  final DataStoreCategory datastore;

  AwsAmplifyBeersRepository(
    this.datastore,
  );

  @override
  Future<List<Beer>> loadBreweryBeers(Brewery brewery) {
    return datastore
        .query(
          aws_models.Beer.classType,
          where: aws_models.Beer.BREWERYID.eq(brewery.id),
        )
        .then((beers) => beers.map(parseBeer).toList())
        .catchError((Object e) {
      print(e);
    });
  }

  @override
  Future<List<Beer>> loadStyleBeers(String style) {
    return datastore
        .query(
          aws_models.Beer.classType,
          where: aws_models.Beer.TYPE.eq(style),
        )
        .then((beers) => beers.map(parseBeer).toList())
        .catchError((Object e) {
      print(e);
    });
  }

  Beer parseBeer(aws_models.Beer beer) {
    return Beer(
      id: beer.id,
      name: beer.name,
      type: beer.type,
      abv: beer.abv!,
      imageId: beer.imageInternalId,
    );
  }

  @override
  Future<String?> beerImageUrl(Beer beer) async {
    return null;
    // try {
    //   final url = await storage.ref('${beer.imageId}.jpg').getDownloadURL();
    //   return url;
    // } catch (_) {
    //   print('No image found ?!');
    //   return null;
    // }
  }
}
