import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poke_dex/models/pokemon.dart';
import 'package:poke_dex/providers/pokemon_data_providers.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'pokemon_stats_card.dart';

class PokemonListTile extends ConsumerWidget {
  final String pokemonUrl;

  late FavoritePokemonsProvider _favoritePokemonsProvider;
  late List<String> _favoritePokemon;

  PokemonListTile({required this.pokemonUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _favoritePokemonsProvider = ref.watch(favoritePokemonsProvider.notifier);
    _favoritePokemon = ref.watch(favoritePokemonsProvider);
    final pokemon = ref.watch(
      pokemonDataProvider(pokemonUrl),
    );
    return pokemon.when(data: (data) {
      return _tile(
        context,
        false,
        data,
      );
    }, error: (error, stackTrace) {
      return Text("Error: $error");
    }, loading: () {
      return _tile(
        context,
        true,
        null,
      );
    });
  }

  Widget _tile(
    BuildContext context,
    bool isLoading,
    Pokemon? pokemon,
  ) {
    return Skeletonizer(
      enabled: isLoading,
      child: GestureDetector(
        onTap: () {
          if (!isLoading) {
            showDialog(
                context: context,
                builder: (_) {
                  return PokemonStatsCard(pokemonUrl: pokemonUrl);
                });
          }
        },
        child: ListTile(
          leading: pokemon != null
              ? CircleAvatar(
                  backgroundImage: NetworkImage(pokemon.sprites!.frontDefault!),
                )
              : CircleAvatar(),
          title: Text(pokemon != null
              ? pokemon.name!.toUpperCase()
              : "Currently loading name for pokemon"),
          subtitle: Text("Has ${pokemon?.moves?.length.toString() ?? 0} moves"),
          trailing: IconButton(
            onPressed: () {
              if (_favoritePokemon.contains(pokemonUrl)) {
                _favoritePokemonsProvider.removeFavoritePokemon(pokemonUrl);
              } else {
                _favoritePokemonsProvider.addFavoritePokemon(pokemonUrl);
              }
            },
            icon: Icon(
              _favoritePokemon.contains(pokemonUrl)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
