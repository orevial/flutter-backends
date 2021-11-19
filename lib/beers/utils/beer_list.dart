import 'package:appwrite_app/beers/beer.dart';
import 'package:appwrite_app/utils/app_write_state.dart';
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
    final appWriteState = context.read<AppWriteState>();
    return ListView.builder(
      itemCount: beers.length,
      itemBuilder: (_, i) {
        final beer = beers[i];
        return ListTile(
          leading: beer.hasImage
              ? CachedNetworkImage(
                  width: 50,
                  height: 50,
                  imageUrl: appWriteState.imageUrl(beer.imageId!),
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
