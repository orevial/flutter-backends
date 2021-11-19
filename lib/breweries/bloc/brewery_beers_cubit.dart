import 'package:appwrite/appwrite.dart';
import 'package:appwrite_app/beers/beer.dart';
import 'package:appwrite_app/breweries/models/brewery.dart';
import 'package:appwrite_app/utils/app_write_state.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'brewery_beers_state.dart';

class BreweryBeersCubit extends Cubit<BreweryBeersState> {
  final Database database;
  final Brewery brewery;

  BreweryBeersCubit(
    this.database,
    this.brewery,
  ) : super(BreweryBeersLoadInProgress()) {
    _loadBeers();
  }

  void _loadBeers() async {
    await database
        .getDocument(
      collectionId: breweryCollectionId,
      documentId: brewery.id,
    )
        .then((listDocs) {
      final beers = (listDocs.data['beers'] as List<dynamic>)
          .map((d) => d as Map<String, dynamic>)
          .map((d) => Beer(
                id: d[r'$id'],
                name: d['name'],
                type: d['type'],
                abv: d['abv'],
                imageId: d['internal_image_id'],
                // TODO Fix this
                // abv: d['abv'] as dynamic,
              ))
          .toList();
      emit(BreweryBeersLoadSuccess(beers));
    }).catchError((Object e) {
      emit(BreweryBeersLoadFailure());
    });
  }
}
