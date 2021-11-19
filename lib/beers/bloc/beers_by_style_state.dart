part of 'beers_by_style_cubit.dart';

abstract class BeersByStyleState extends Equatable {
  const BeersByStyleState();

  @override
  List<Object> get props => [];
}

class BeersByStyleLoadInProgress extends BeersByStyleState {}

class BeersByStyleLoadSuccess extends BeersByStyleState {
  final List<Beer> beers;

  const BeersByStyleLoadSuccess([this.beers = const []]);

  @override
  List<Object> get props => [beers];
}

class BeersByStyleLoadFailure extends BeersByStyleState {}
