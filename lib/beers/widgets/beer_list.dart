import 'package:backend_repository/backend_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        final beerRepository = context.read<BeersRepository>();
        final beer = beers[i];
        return ListTile(
          leading: beer.hasImage
              ? FutureBuilder<String?>(
                  future: beerRepository.beerImageUrl(beer),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      return CachedNetworkImage(
                        width: 50,
                        height: 50,
                        imageUrl: snapshot.data!,
                        placeholder: (_, __) => _placeholderImage(),
                      );
                    }
                    return _placeholderImage();
                  },
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
