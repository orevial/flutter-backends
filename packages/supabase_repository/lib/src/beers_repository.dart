import 'dart:async';

import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_repository/src/settings.dart';
import 'package:backend_repository/backend_repository.dart';

class SupabaseBeersRepository extends BeersRepository {
  final SupabaseClient client;
  final SupabaseSettings settings;

  SupabaseBeersRepository(this.client, this.settings);

  @override
  Future<List<Beer>> loadBreweryBeers(Brewery brewery) {
    return client
        .from(settings.beersCollectionId)
        .select()
        .eq('brewery_id', brewery.id)
        .execute()
        .then((response) => response.data as List<dynamic>)
        .then((beers) => beers
            .map((b) => b as Map<String, dynamic>)
            .map(parseBeer)
            .toList());
  }

  @override
  Future<List<Beer>> loadStyleBeers(String style) {
    return client
        .from(settings.beersCollectionId)
        .select()
        .eq('type', style)
        .execute()
        .then((response) => response.data as List<dynamic>)
        .then((beers) => beers
            .map((b) => b as Map<String, dynamic>)
            .map(parseBeer)
            .toList());
  }

  Beer parseBeer(Map<String, dynamic> doc) {
    return Beer(
        id: (doc['name'] as String).toLowerCase().replaceAll(' ', '-'),
        name: doc['name'],
        type: doc['type'],
        abv: doc['abv'],
        imageId: doc['imageinternalid']);
  }

  @override
  Future<String?> beerImageUrl(Beer beer) async {
    try {
      final url = await client.storage
          .from('beer-images')
          .createSignedUrl('${beer.imageId}.jpg', 60)
          .then((response) => response.data);
      return url;
    } catch (_) {
      return null;
    }
  }
}
