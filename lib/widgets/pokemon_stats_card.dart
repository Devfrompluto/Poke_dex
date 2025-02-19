import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poke_dex/providers/pokemon_data_providers.dart';

class PokemonStatsCard extends ConsumerWidget {
  final String pokemonUrl;

  PokemonStatsCard({
    super.key,
    required this.pokemonUrl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemon = ref.watch(pokemonDataProvider(pokemonUrl));

    return AlertDialog(
      title: Text("Statistics"),
      content: pokemon.when(
        data: (data) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: data?.stats?.map((s) {
                  return Text("${s.stat?.name?.toUpperCase()}: ${s.baseStat}");
                }).toList() ??
                [],
          );
        },
        error: (error, stackTrace) {
          return Text(error.toString());
        },
        loading: () {
          return CircularProgressIndicator(
            color: Colors.white,
          );
        },
      ),
    );
  }
}
