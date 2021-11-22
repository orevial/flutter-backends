import 'package:flutter_backends/utils/repository_utils.dart';
import 'package:backend_repository/backend_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BeerList extends StatelessWidget {
  final List<Beer> beers;

  const BeerList({
    Key? key,
    required this.beers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: beers.length,
      itemBuilder: (_, i) {
        final beer = beers[i];
        return ListTile(
          leading: beer.hasImage
              ? CachedNetworkImage(
                  width: 50,
                  height: 50,
                  imageUrl: imageUrl(beer.imageId!),
                  placeholder: (_, __) => _placeholderImage(),
                )
              : _placeholderImage(),
          title: Text(beers[i].name),
          subtitle: Text(
            '${beer.type} - ${beer.abv}',
            style: const TextStyle(fontSize: 12),
          ),
        );
      },
    );
  }

  Widget _placeholderImage() => const Image(
        image: AssetImage(
          'assets/images/beer-placeholder.png',
        ),
      );
}
