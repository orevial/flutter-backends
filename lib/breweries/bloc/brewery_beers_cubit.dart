import 'package:backend_repository/backend_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'brewery_beers_state.dart';

class BreweryBeersCubit extends Cubit<BreweryBeersState> {
  final BeersRepository beersRepository;
  final Brewery brewery;

  BreweryBeersCubit(
    this.beersRepository,
    this.brewery,
  ) : super(BreweryBeersLoadInProgress()) {
    _loadBeers();
  }

  void _loadBeers() async {
    beersRepository
        .loadBreweryBeers(brewery)
        .then((beers) => emit(BreweryBeersLoadSuccess(beers)))
        .catchError((Object e) => emit(BreweryBeersLoadFailure()));
  }
}
