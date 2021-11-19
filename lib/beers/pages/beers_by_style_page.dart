import 'package:appwrite_app/beers/bloc/beers_by_style_cubit.dart';
import 'package:appwrite_app/beers/utils/beer_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BeersByStylePage extends StatelessWidget {
  const BeersByStylePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = context.read<BeersByStyleCubit>().style;
    return Scaffold(
      appBar: AppBar(
        title: Text('$style beers'),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<BeersByStyleCubit, BeersByStyleState>(
              builder: (_, state) {
                if (state is BeersByStyleLoadInProgress) {
                  return const CircularProgressIndicator();
                } else if (state is BeersByStyleLoadFailure) {
                  return const Text(
                      'Unable to load beers, please try again later');
                }
                final beers = (state as BeersByStyleLoadSuccess).beers;
                return BeerList(beers: beers);
              },
            ),
          ),
        ],
      ),
    );
  }
}
