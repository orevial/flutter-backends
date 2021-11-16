import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:appwrite_app/breweries/models/brewery.dart';
import 'package:appwrite_app/main.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'beer.dart';

part 'beers_state.dart';

class BeersCubit extends Cubit<BeersState> {
  final Database database;
  final Brewery brewery;

  BeersCubit(
    this.database,
    this.brewery,
  ) : super(BeersLoadInProgress()) {
    _loadBeers();
  }

  void _loadBeers() async {
    await database
        .getDocument(
      collectionId: breweryCollectionId,
      documentId: brewery.id,
    )
        .then((listDocs) {
      // TODO Will probably fail
      final beers = (listDocs.data['beers'] as List<dynamic>)
          .map((d) => d as Map<String, dynamic>)
          .map((d) => Beer(
                id: d[r'$id'],
                name: d['name'],
                type: d['type'],
                abv: 5.5,
                // TODO Fix this
                // abv: d['abv'] as dynamic,
              ))
          .toList();
      emit(BeersLoadSuccess(beers));
    }).catchError((Object e) {
      print(e);
      emit(BeersLoadFailure());
    });
  }
}
