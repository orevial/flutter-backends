import 'package:appwrite_app/breweries/models/brewery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../beers_cubit.dart';

class BeersListPage extends StatelessWidget {
  final Brewery brewery;

  const BeersListPage({
    required this.brewery,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${brewery.name} (${brewery.country})'),
      ),
      body: Column(
        children: [
          if (brewery.description != null) Padding(
            padding: const EdgeInsets.all(16),
            child: Text(brewery.description!),
          ),
          Expanded(
            child: BlocBuilder<BeersCubit, BeersState>(
              builder: (_, state) {
                if (state is BeersLoadInProgress) {
                  return const CircularProgressIndicator();
                } else if (state is BeersLoadFailure) {
                  return const Text(
                      'Unable to load beers, please try again later');
                }
                final beers = (state as BeersLoadSuccess).beers;
                return ListView.builder(
                  itemCount: beers.length,
                  itemBuilder: (_, i) {
                    final beer = beers[i];
                    return ListTile(
                      title: Text(beers[i].name),
                      subtitle: Text(
                        '${beer.type} ',
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
