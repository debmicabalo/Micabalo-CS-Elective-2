import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pokemon.dart';
import '../services/poke_api_service.dart';

// 1. Define the complete State Object
class PokedexState {
  final List<Pokemon> pokemonList;
  final bool isLoading;
  final String errorMessage;
  
  // New Feature States
  final Set<int> favoriteIds;
  final Map<int, String> nicknames;
  final String? selectedTypeFilter;

  PokedexState({
    this.pokemonList = const [],
    this.isLoading = false,
    this.errorMessage = '',
    this.favoriteIds = const {},
    this.nicknames = const {},
    this.selectedTypeFilter,
  });

  // copyWith allows us to update specific fields while keeping the rest unchanged
  PokedexState copyWith({
    List<Pokemon>? pokemonList,
    bool? isLoading,
    String? errorMessage,
    Set<int>? favoriteIds,
    Map<int, String>? nicknames,
    String? selectedTypeFilter,
  }) {
    return PokedexState(
      pokemonList: pokemonList ?? this.pokemonList,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      nicknames: nicknames ?? this.nicknames,
      selectedTypeFilter: selectedTypeFilter != null 
          ? (selectedTypeFilter == 'ALL' ? null : selectedTypeFilter) 
          : this.selectedTypeFilter,
    );
  }
}

// 2. Create the Notifier containing all your logic
class PokedexNotifier extends Notifier<PokedexState> {
  final PokeApiService _apiService = PokeApiService();

  @override
  PokedexState build() {
    // Trigger the initial fetch as soon as the provider initializes
    Future.microtask(() => fetch());
    return PokedexState(); // Initial empty state
  }

  // --- FEATURE: List Management & Refresh ---
  Future<void> fetch() async {
    state = state.copyWith(isLoading: true, errorMessage: '');
    try {
      final list = await _apiService.fetchPokemon(limit: 30);
      state = state.copyWith(isLoading: false, pokemonList: list);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  // --- FEATURE: Favorites ---
  void toggleFavorite(int id) {
    final newFavs = Set<int>.from(state.favoriteIds);
    if (newFavs.contains(id)) {
      newFavs.remove(id);
    } else {
      newFavs.add(id);
    }
    state = state.copyWith(favoriteIds: newFavs);
  }

  // --- FEATURE: Nickname Editor ---
  void setNickname(int id, String nickname) {
    final newNicknames = Map<int, String>.from(state.nicknames);
    if (nickname.trim().isEmpty) {
      newNicknames.remove(id);
    } else {
      newNicknames[id] = nickname.trim();
    }
    state = state.copyWith(nicknames: newNicknames);
  }

  void removeNickname(int id) {
    setNickname(id, ''); // Setting to empty removes it
  }

  // --- FEATURE: Type Filter ---
  void setTypeFilter(String type) {
    state = state.copyWith(selectedTypeFilter: type);
  }
}

// 3. Expose the Provider globally
final pokedexProvider = NotifierProvider<PokedexNotifier, PokedexState>(() {
  return PokedexNotifier();
});