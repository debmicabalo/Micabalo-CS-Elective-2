import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../services/poke_api_service.dart';

class PokemonProvider extends ChangeNotifier {
  final PokeApiService _apiService = PokeApiService();
  
  // App State Variables
  List<Pokemon> _pokemonList = [];
  bool _isLoading = false;
  String _errorMessage = '';
  Pokemon? _selectedPokemon;

  List<Pokemon> get pokemonList => _pokemonList;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  Pokemon? get selectedPokemon => _selectedPokemon;

  PokemonProvider() {
    fetchPokemon();
  }

  Future<void> fetchPokemon() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _pokemonList = await _apiService.fetchPokemon(limit: 30);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectPokemon(Pokemon pokemon) {
    _selectedPokemon = pokemon;
    notifyListeners();
  }
}