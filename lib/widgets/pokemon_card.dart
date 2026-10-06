import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pokemon.dart';
import '../providers/pokemon_provider.dart';
import '../screens/details_screen.dart';

class PokemonCard extends StatefulWidget {
  final Pokemon pokemon;

  const PokemonCard({super.key, required this.pokemon});

  @override
  State<PokemonCard> createState() => _PokemonCardState();
}

class _PokemonCardState extends State<PokemonCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        context.read<PokemonProvider>().selectPokemon(widget.pokemon);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DetailsScreen()),
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
                        color: widget.pokemon.baseColor.withOpacity(0.5), // Colored shadow
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
                child: Column(
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
                            errorBuilder: (context, error, stackTrace) => 
                              const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.pokemon.name.toUpperCase(),
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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