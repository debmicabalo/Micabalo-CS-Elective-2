import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/pokedex_provider.dart';
import '../widgets/pokemon_card.dart';
import '../widgets/favorites_drawer.dart';
import '../main.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pokedexProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Filter the list based on the selected type
    final displayList = state.selectedTypeFilter == null
        ? state.pokemonList
        : state.pokemonList.where((p) => p.types.contains(state.selectedTypeFilter)).toList();

    // Extract all unique types from the fetched Pokémon for the dropdown
    final allTypes = {'ALL', ...state.pokemonList.expand((p) => p.types).toSet()}.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('POKÉDEX'),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark,
          ),
          // Builder used so Scaffold.of(context) finds the right context to open the drawer
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: const FavoritesDrawer(), // The retractable panel
      body: Column(
        children: [
          // TYPE FILTER
          if (state.pokemonList.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                children: [
                  const Text('Filter by Type: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: state.selectedTypeFilter ?? 'ALL',
                      items: allTypes.map((type) {
                        return DropdownMenuItem(value: type, child: Text(type.toUpperCase()));
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) ref.read(pokedexProvider.notifier).setTypeFilter(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
            
          // MAIN GRID
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.read(pokedexProvider.notifier).fetch(),
              child: _buildBody(state, displayList, ref),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(PokedexState state, List displayList, WidgetRef ref) {
    if (state.isLoading && state.pokemonList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    } 
    
    if (state.errorMessage.isNotEmpty && state.pokemonList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            Text('Error: ${state.errorMessage}', textAlign: TextAlign.center),
            ElevatedButton(
              onPressed: () => ref.read(pokedexProvider.notifier).fetch(),
              child: const Text('Retry'),
            )
          ],
        ),
      );
    } 

    if (displayList.isEmpty) {
      return ListView(
        children: const [
          SizedBox(height: 300),
          Center(child: Text('No Pokémon found. Pull to refresh or clear filter.')),
        ],
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), 
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.75, 
        crossAxisSpacing: 50, 
        mainAxisSpacing: 50,
      ),
      itemCount: displayList.length,
      itemBuilder: (context, index) {
        return PokemonCard(pokemon: displayList[index]);
      },
    );
  }
}