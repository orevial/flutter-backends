import 'package:flutter_backends/beers/bloc/beers_by_style_cubit.dart';
import 'package:flutter_backends/beers/pages/beers_by_style_page.dart';
import 'package:backend_repository/backend_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const styles = ['IPA', 'DDH IPA', 'Milkshake IPA', 'Session IPA'];

class BeersStylesPage extends StatelessWidget {
  const BeersStylesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beers styles'),
      ),
      body: ListView.builder(
        itemCount: styles.length,
        itemBuilder: (_, i) {
          return ListTile(
            title: Text(styles[i]),
            onTap: () => {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => BlocProvider(
                      create: (_) => BeersByStyleCubit(
                            context.read<BeersRepository>(),
                            styles[i],
                          ),
                      child: const BeersByStylePage()),
                ),
              ),
            },
          );
        },
      ),
    );
  }
}
