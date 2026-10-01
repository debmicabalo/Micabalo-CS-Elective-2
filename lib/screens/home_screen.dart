import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../services/poke_api_service.dart';
import '../widgets/pokemon_card.dart';
import '../main.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PokeApiService _apiService = PokeApiService();
  late Future<List<Pokemon>> _pokemonFuture;

  @override
  void initState() {
    super.initState();
    _pokemonFuture = _apiService.fetchPokemon(limit: 30);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
      body: FutureBuilder<List<Pokemon>>(
        future: _pokemonFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } 
          else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}', textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _pokemonFuture = _apiService.fetchPokemon(limit: 30);
                      });
                    },
                    child: const Text('Retry'),
                  )
                ],
              ),
            );
          } 
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Pokémon found.'));
          }

          final pokemonList = snapshot.data!;
          return GridView.builder(
            // 1. INCREASED PADDING: Pushes the grid further away from the screen edges
            padding: const EdgeInsets.all(48), 
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75, 
              // 2. INCREASED SPACING: Pushes the cards further away from each other
              crossAxisSpacing: 24, 
              mainAxisSpacing: 24,
            ),
            itemCount: pokemonList.length,
            itemBuilder: (context, index) {
              return PokemonCard(pokemon: pokemonList[index]);
            },
          );
        },
      ),
    );
  }
}