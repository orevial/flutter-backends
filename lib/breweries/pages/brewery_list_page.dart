import 'package:flutter_backends/breweries/bloc/brewery_beers_cubit.dart';
import 'package:flutter_backends/breweries/bloc/brewery_cubit.dart';
import 'package:backend_repository/backend_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'brewery_page.dart';

class BreweryListPage extends StatelessWidget {
  const BreweryListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Breweries'),
      ),
      body: BlocBuilder<BreweryCubit, BreweriesState>(
        builder: (_, state) {
          if (state is BreweriesLoadInProgress) {
            return const CircularProgressIndicator();
          } else if (state is BreweriesLoadFailure) {
            return const Text(
                'Unable to load breweries, please try again later');
          }
          final breweries = (state as BreweriesLoadSuccess).breweries;
          return ListView.builder(
            itemCount: breweries.length,
            itemBuilder: (_, i) {
              final brewery = breweries[i];
              return Slidable(
                key: ValueKey<String>(brewery.id),
                endActionPane: ActionPane(
                  motion: const BehindMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) {
                        context.read<BreweryCubit>().deleteBrewery(brewery);
                      },
                      backgroundColor: const Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(brewery.name),
                  subtitle: brewery.country != null
                      ? Text(
                          brewery.country!,
                          style: const TextStyle(fontSize: 12),
                        )
                      : null,
                  onTap: () {
                    Navigator.of(context).push<void>(
                      MaterialPageRoute<void>(
                        builder: (_) => BlocProvider(
                          create: (_) => BreweryBeersCubit(
                            context.read<BeersRepository>(),
                            brewery,
                          ),
                          child: BeersListPage(brewery: brewery),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
