import 'package:backend_repository/backend_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'brewery_state.dart';

class BreweryCubit extends Cubit<BreweriesState> {
  final BreweryRepository breweryRepository;

  BreweryCubit(this.breweryRepository) : super(BreweriesLoadInProgress()) {
    _loadBreweries();
    breweryRepository.breweryChanges.listen((event) {
      if (state is BreweriesLoadSuccess) {
        switch (event.runtimeType) {
          case BreweryCreatedEvent:
          case BreweryUpdatedEvent:
            _loadBreweries();
            break;
          case BreweryDeletedEvent:
            emit(
              BreweriesLoadSuccess(
                (state as BreweriesLoadSuccess)
                    .breweries
                    .where((b) => b.id != (event as BreweryDeletedEvent).id)
                    .toList(),
              ),
            );
            break;
        }
      }
    });
  }

  void _loadBreweries() async {
    await breweryRepository
        .loadBreweries()
        .then((breweries) => emit(BreweriesLoadSuccess(breweries)))
        .catchError((Object e) => emit(BreweriesLoadFailure()));
  }

  void deleteBrewery(Brewery brewery) async {
    await breweryRepository.deleteBrewery(brewery);
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
