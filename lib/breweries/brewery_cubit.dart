import 'package:appwrite/appwrite.dart';
import 'package:appwrite_app/breweries/models/brewery.dart';
import 'package:appwrite_app/main.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'brewery_state.dart';

class BreweryCubit extends Cubit<BreweriesState> {
  final Database database;
  final Realtime realtime;

  late final Stream<RealtimeMessage> _stream =
      realtime.subscribe(['collections.$breweryCollectionId.documents']).stream;

  BreweryCubit(
    this.database,
    this.realtime,
  ) : super(BreweriesLoadInProgress()) {
    _loadBreweries();
    _stream.listen((message) {
      if (state is BreweriesLoadSuccess) {
        switch (message.event) {
          case 'database.documents.create':
          case 'database.documents.update':
            _loadBreweries();
            break;
          case 'database.documents.delete':
            emit(
              BreweriesLoadSuccess(
                (state as BreweriesLoadSuccess)
                    .breweries
                    .where((b) => b.id != message.payload[r'$id'])
                    .toList(),
              ),
            );
            break;
        }
      }
    });
  }

  void _loadBreweries() async {
    await database
        .listDocuments(collectionId: breweryCollectionId)
        .then((listDocs) {
      final breweries = listDocs.documents
          .map((d) => Brewery(
                id: d.$id,
                name: d.data['name'],
                description: d.data['description'],
                country: d.data['country'],
              ))
          .toList();
      emit(BreweriesLoadSuccess(breweries));
    }).catchError((Object e) {
      emit(BreweriesLoadFailure());
    });
  }

  void deleteBrewery(Brewery brewery) async {
    await database.deleteDocument(
      collectionId: breweryCollectionId,
      documentId: brewery.id,
    );
    emit(
      BreweriesLoadSuccess(
        (state as BreweriesLoadSuccess)
            .breweries
            .where((b) => b.id != brewery.id)
            .toList(),
      ),
    );
  }
}
