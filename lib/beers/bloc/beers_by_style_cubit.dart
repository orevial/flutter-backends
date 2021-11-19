import 'package:appwrite/appwrite.dart';
import 'package:appwrite_app/beers/beer.dart';
import 'package:appwrite_app/utils/app_write_state.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'beers_by_style_state.dart';

class BeersByStyleCubit extends Cubit<BeersByStyleState> {
  final Database database;
  final String style;

  BeersByStyleCubit(
    this.database,
    this.style,
  ) : super(BeersByStyleLoadInProgress()) {
    _loadBeers();
  }

  void _loadBeers() async {
    await database
        .listDocuments(
      collectionId: beersCollectionId,
      filters: ['type=$style'],
      limit: 10,
      orderType: '',
    )
        .then((listDocs) {
      final beers = listDocs.documents.map((d) => d.data).map((d) {
        return Beer(
          id: d[r'$id'],
          name: d['name'],
          type: d['type'],
          abv: d['abv'],
          imageId: d['internal_image_id'],
        );
      }).toList();
      emit(BeersByStyleLoadSuccess(beers));
    }).catchError((Object e) {
      emit(BeersByStyleLoadFailure());
    });
  }
}
