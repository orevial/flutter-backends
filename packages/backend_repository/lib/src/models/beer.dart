import 'package:equatable/equatable.dart';

class Beer extends Equatable {
  final String id;
  final String name;
  final String type;
  final double abv;
  final String? imageId;

  const Beer({
    required this.id,
    required this.name,
    required this.type,
    required this.abv,
    this.imageId,
  });

  @override
  List<Object?> get props => throw UnimplementedError();

  bool get hasImage {
    print(imageId);
    return imageId != null && imageId!.isNotEmpty;
  }
}
