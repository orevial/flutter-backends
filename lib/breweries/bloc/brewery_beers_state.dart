part of 'brewery_beers_cubit.dart';

abstract class BreweryBeersState extends Equatable {
  const BreweryBeersState();

  @override
  List<Object> get props => [];
}

class BreweryBeersLoadInProgress extends BreweryBeersState {}

class BreweryBeersLoadSuccess extends BreweryBeersState {
  final List<Beer> beers;

  const BreweryBeersLoadSuccess([this.beers = const []]);

  @override
  List<Object> get props => [beers];
}

class BreweryBeersLoadFailure extends BreweryBeersState {}
