import 'package:equatable/equatable.dart';

abstract class BreweryEvent extends Equatable {}

class BreweryCreatedEvent extends BreweryEvent {
  @override
  List<Object?> get props => [];
}

class BreweryUpdatedEvent extends BreweryEvent {
  @override
  List<Object?> get props => [];
}

class BreweryDeletedEvent extends BreweryEvent {
  final String id;

  BreweryDeletedEvent(this.id);

  @override
  List<Object?> get props => [id];
}
