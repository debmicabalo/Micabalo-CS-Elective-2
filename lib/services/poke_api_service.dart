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
      
      final detailedFutures = results.map((result) async {
        final detailResponse = await http.get(Uri.parse(result['url']));
        if (detailResponse.statusCode == 200) {
          return Pokemon.fromJson(jsonDecode(detailResponse.body));
        } else {
          throw Exception('Failed to load details for ${result['name']}');
        }
      });
      
      return await Future.wait(detailedFutures);
    } else {
      throw Exception('Failed to load Pokémon list. Status code: ${response.statusCode}');
    }
  }
}