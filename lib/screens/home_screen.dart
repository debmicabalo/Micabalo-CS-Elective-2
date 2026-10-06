import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pokemon_provider.dart';
import '../widgets/pokemon_card.dart';
import '../main.dart'; 

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final provider = context.watch<PokemonProvider>(); 

    return Scaffold(
      appBar: AppBar(
        title: const Text('POKÉDEX'),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
            },
          )
        ],
      ),
      // RefreshIndicator
      body: RefreshIndicator(
        onRefresh: provider.fetchPokemon, 
        child: _buildBody(provider),
      ),
    );
  }

  Widget _buildBody(PokemonProvider provider) {
    // b. Loading State
    if (provider.isLoading && provider.pokemonList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    } 
    
    // c. Error State
    if (provider.errorMessage.isNotEmpty && provider.pokemonList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            Text('Error: ${provider.errorMessage}', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: provider.fetchPokemon,
              child: const Text('Retry'),
            )
          ],
        ),
      );
    } 
    
    // Empty State
    if (provider.pokemonList.isEmpty) {
      return ListView(
        children: const [
           SizedBox(height: 300),
           Center(child: Text('No Pokémon found. Pull down to refresh.')),
        ],
      );
    }

    // a. Success State (Info Display)[cite: 1]
    return GridView.builder(
      padding: const EdgeInsets.all(48), 
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.75, 
        crossAxisSpacing: 24, 
        mainAxisSpacing: 24,
      ),
      itemCount: provider.pokemonList.length,
      itemBuilder: (context, index) {
        return PokemonCard(pokemon: provider.pokemonList[index]);
      },
    );
  }
}