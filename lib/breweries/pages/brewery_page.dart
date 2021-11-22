import 'package:flutter_backends/beers/widgets/beer_list.dart';
import 'package:flutter_backends/breweries/bloc/brewery_beers_cubit.dart';
import 'package:backend_repository/backend_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          if (brewery.description != null && brewery.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(brewery.description!),
            ),
          Expanded(
            child: BlocBuilder<BreweryBeersCubit, BreweryBeersState>(
              builder: (_, state) {
                if (state is BreweryBeersLoadInProgress) {
                  return const CircularProgressIndicator();
                } else if (state is BreweryBeersLoadFailure) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Unable to load beers, please try again later',
                    ),
                  );
                }
                final beers = (state as BreweryBeersLoadSuccess).beers;
                return BeerList(beers: beers);
              },
            ),
          ),
        ],
      ),
    );
  }
}
