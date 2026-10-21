import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pokemon.dart';
import '../providers/pokedex_provider.dart';
import '../widgets/favorites_drawer.dart';
import '../main.dart'; // Import this to access themeNotifier

class DetailsScreen extends ConsumerWidget {
  final Pokemon pokemon;
  const DetailsScreen({super.key, required this.pokemon});

  // Nickname Editor Dialog
  void _showNicknameDialog(BuildContext context, WidgetRef ref, String? currentNickname) {
    final controller = TextEditingController(text: currentNickname);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Nickname'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter new nickname'),
        ),
        actions: [
          if (currentNickname != null)
            TextButton(
              onPressed: () {
                ref.read(pokedexProvider.notifier).removeNickname(pokemon.id);
                Navigator.pop(context);
              },
              child: const Text('Remove', style: TextStyle(color: Colors.red)),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(pokedexProvider.notifier).setNickname(pokemon.id, controller.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = ref.watch(pokedexProvider);
    
    final isFavorite = state.favoriteIds.contains(pokemon.id);
    final nickname = state.nicknames[pokemon.id];

    return Scaffold(
      appBar: AppBar(
        title: Text(nickname ?? pokemon.name.toUpperCase()),
        actions: [
          // 1. ADDED: Theme Toggle Button
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark,
          ),
          
          // 2. Favorite Toggle Button
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.red : null),
            onPressed: () => ref.read(pokedexProvider.notifier).toggleFavorite(pokemon.id),
          ),
          
          // 3. Favorites Drawer Menu Button
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: const FavoritesDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                color: pokemon.baseColor.withOpacity(isDark ? 0.3 : 0.2),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Image.network(pokemon.imageUrl, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              '#${pokemon.id.toString().padLeft(3, '0')}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 24),
            ),
            const SizedBox(height: 8),
            
            // Nickname Display & Edit Action
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    if (nickname != null)
                      Text('"$nickname"', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 36, fontStyle: FontStyle.italic)),
                    Text(
                      pokemon.name.toUpperCase(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: nickname != null ? 18 : 36),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showNicknameDialog(context, ref, nickname),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Types Chips
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: pokemon.types.map((type) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Chip(
                    backgroundColor: pokemon.baseColor,
                    label: Text(type.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}