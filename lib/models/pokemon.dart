class Pokemon {
  final int id;
  final String name;
  final String imageUrl;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final url = json['url'] as String;
    final urlParts = url.split('/');
    final idString = urlParts[urlParts.length - 2];
    final id = int.parse(idString);

    return Pokemon(
      id: id,
      name: json['name'],
      imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png',
    );
  }
}