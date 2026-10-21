import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/pokedex_provider.dart';

class FavoritesDrawer extends ConsumerWidget {
  const FavoritesDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pokedexProvider);
    
    // Filter the global list to only include favorite IDs
    final favoritePokemon = state.pokemonList
        .where((p) => state.favoriteIds.contains(p.id))
        .toList();

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
            child: const Center(
              child: Text(
                'My Favorites',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: favoritePokemon.isEmpty
                ? const Center(child: Text('No favorites yet! Tap the heart icon.'))
                : ListView.builder(
                    itemCount: favoritePokemon.length,
                    itemBuilder: (context, index) {
                      final pokemon = favoritePokemon[index];
                      final nickname = state.nicknames[pokemon.id];
                      
                      return ListTile(
                        leading: Image.network(pokemon.imageUrl, width: 50),
                        title: Text(nickname ?? pokemon.name.toUpperCase()),
                        subtitle: nickname != null ? Text(pokemon.name.toUpperCase()) : null,
                        trailing: IconButton(
                          icon: const Icon(Icons.favorite, color: Colors.red),
                          onPressed: () {
                            ref.read(pokedexProvider.notifier).toggleFavorite(pokemon.id);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}