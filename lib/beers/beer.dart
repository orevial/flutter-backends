import 'package:equatable/equatable.dart';

class Beer extends Equatable {
  final String id;
  final String name;
  final String type;
  final double abv;

  const Beer({
    required this.id,
    required this.name,
    required this.type,
    required this.abv,
  });

  @override
  List<Object?> get props => throw UnimplementedError();
}
