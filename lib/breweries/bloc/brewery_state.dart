part of 'brewery_cubit.dart';

abstract class BreweriesState extends Equatable {
  const BreweriesState();

  @override
  List<Object> get props => [];
}

class BreweriesLoadInProgress extends BreweriesState {}

class BreweriesLoadSuccess extends BreweriesState {
  final List<Brewery> breweries;

  const BreweriesLoadSuccess([this.breweries = const []]);

  @override
  List<Object> get props => [breweries];
}

class BreweriesLoadFailure extends BreweriesState {}
