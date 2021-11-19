import 'package:backend_repository/backend_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'beers_by_style_state.dart';

class BeersByStyleCubit extends Cubit<BeersByStyleState> {
  final BeersRepository beersRepository;
  final String style;

  BeersByStyleCubit(
    this.beersRepository,
    this.style,
  ) : super(BeersByStyleLoadInProgress()) {
    _loadBeers();
  }

  void _loadBeers() async {
    await beersRepository
        .loadStyleBeers(style)
        .then((beers) => emit(BeersByStyleLoadSuccess(beers)))
        .catchError((Object e) => emit(BeersByStyleLoadFailure()));
  }
}
