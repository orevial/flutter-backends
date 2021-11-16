part of 'beers_cubit.dart';

abstract class BeersState extends Equatable {
  const BeersState();

  @override
  List<Object> get props => [];
}

class BeersLoadInProgress extends BeersState {}

class BeersLoadSuccess extends BeersState {
  final List<Beer> beers;

  const BeersLoadSuccess([this.beers = const []]);

  @override
  List<Object> get props => [beers];
}

class BeersLoadFailure extends BeersState {}
