import 'dart:async';

import 'package:supabase/supabase.dart';
import 'package:supabase_repository/supabase_repository.dart';
import 'package:backend_repository/backend_repository.dart';
import 'package:backend_repository/src/models/brewery.dart';

class SupabaseBreweryRepository extends BreweryRepository {
  final SupabaseClient client;
  final SupabaseSettings settings;

  SupabaseBreweryRepository(this.client, this.settings);

  // TODO: implement breweryChanges
  // late final Stream<RealtimeMessage> _stream = realtime.subscribe(
  //     ['collections.${settings.breweryCollectionId}.documents']).stream;

  // Stream<BreweryEvent> get breweryChanges => _stream.map((message) {
  //       switch (message.event) {
  //         case 'database.documents.create':
  //           return BreweryCreatedEvent();
  //         case 'database.documents.update':
  //           return BreweryUpdatedEvent();
  //         case 'database.documents.delete':
  //           return BreweryDeletedEvent(message.payload[r'$id']);
  //       }
  //       throw 'Unknown event type';
  //     });

  Stream<BreweryEvent> get breweryChanges => Stream.empty();


  @override
  Future<List<Brewery>> loadBreweries() {
    return client
        .from(settings.breweryCollectionId)
        .select()
        .execute()
        .then((response) => response.data as List<dynamic>)
        .then((breweriesDocs) => breweriesDocs
            .map((b) => b as Map<String, dynamic>)
            .map((b) => Brewery(
                  id: b['id'],
                  name: b['name'],
                  description: b['description'],
                  country: b['country'],
                ))
            .toList());
  }

  @override
  Future<void> deleteBrewery(Brewery brewery) async {
    // Delete brewery beers
    await client
        .from(settings.beersCollectionId)
        .delete()
        .eq('brewery_id', brewery.id)
        .execute();
    // Delete brewery itself
    await client
        .from(settings.breweryCollectionId)
        .delete()
        .eq('id', brewery.id)
        .execute();
  }
}
