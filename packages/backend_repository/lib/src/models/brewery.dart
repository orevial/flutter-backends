import 'package:equatable/equatable.dart';

import 'beer.dart';

class Brewery extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? country;
  final List<Beer>? beers;

  const Brewery({
    required this.id,
    required this.name,
    required this.description,
    required this.country,
    this.beers,
  });

  @override
  List<Object?> get props => [id, name, description, country];
}
