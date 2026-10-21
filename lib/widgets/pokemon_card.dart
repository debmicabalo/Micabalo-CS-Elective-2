import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pokemon.dart';
import '../providers/pokedex_provider.dart';
import '../screens/details_screen.dart';

class PokemonCard extends ConsumerStatefulWidget {
  final Pokemon pokemon;
  const PokemonCard({super.key, required this.pokemon});

  @override
  ConsumerState<PokemonCard> createState() => _PokemonCardState();
}

class _PokemonCardState extends ConsumerState<PokemonCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Read state for this specific card
    final state = ref.watch(pokedexProvider);
    final isFavorite = state.favoriteIds.contains(widget.pokemon.id);
    final nickname = state.nicknames[widget.pokemon.id];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailsScreen(pokemon: widget.pokemon)),
        );
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click, 
        child: AnimatedScale(
          scale: _isHovered ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: widget.pokemon.baseColor.withOpacity(0.5),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      )
                    ]
                  : [],
            ),
            child: Card(
              color: widget.pokemon.baseColor.withOpacity(isDark ? 0.3 : 0.15),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            '#${widget.pokemon.id.toString().padLeft(3, '0')}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: isDark ? Colors.black26 : Colors.white60, 
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                widget.pokemon.imageUrl,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        
                        // Display Nickname (if exists) and Original Name
                        if (nickname != null) ...[
                          Text('"$nickname"', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontStyle: FontStyle.italic)),
                          Text(widget.pokemon.name.toUpperCase(), style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12)),
                        ] else ...[
                          Text(widget.pokemon.name.toUpperCase(), style: Theme.of(context).textTheme.titleMedium),
                        ]
                      ],
                    ),
                    
                    // Fixed: Changed from -10 to 0 so the splash radius doesn't clip
                    Positioned(
                      right: 0,
                      top: 0,
                      child: IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          ref.read(pokedexProvider.notifier).toggleFavorite(widget.pokemon.id);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}