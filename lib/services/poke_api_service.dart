import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class PokeApiService {
  static const String _baseUrl = 'https://pokeapi.co/api/v2';

  Future<List<Pokemon>> fetchPokemon({int limit = 30}) async {
    final response = await http.get(Uri.parse('$_baseUrl/pokemon?limit=$limit'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];
      
      return results.map((json) => Pokemon.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Pokémon. Status code: ${response.statusCode}');
    }
  }
}