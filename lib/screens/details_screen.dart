import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pokemon_provider.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pokemon = context.watch<PokemonProvider>().selectedPokemon;

    if (pokemon == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No Pokémon selected.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.name.toUpperCase()),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 500,
              width: 500,
              decoration: BoxDecoration(
                color: pokemon.baseColor.withOpacity(isDark ? 0.3 : 0.2),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Image.network(
                  pokemon.imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              '#${pokemon.id.toString().padLeft(3, '0')}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 24),
            ),
            const SizedBox(height: 8),
            Text(
              pokemon.name.toUpperCase(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 36),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}