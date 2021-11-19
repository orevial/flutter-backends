import 'package:appwrite_app/beers/bloc/beers_by_style_cubit.dart';
import 'package:appwrite_app/beers/pages/beers_by_style_page.dart';
import 'package:appwrite_app/utils/app_write_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const styles = ['IPA', 'DDH IPA', 'Milkshake IPA', 'Session IPA'];

class BeersStylesPage extends StatelessWidget {
  const BeersStylesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appWriteState = context.read<AppWriteState>();
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
                            appWriteState.database,
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
