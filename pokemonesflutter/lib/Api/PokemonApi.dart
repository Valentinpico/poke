import 'package:http/http.dart' as http;
import 'dart:convert';
import './UriIP.dart';

class PokemonApi {
  static Future<List<dynamic>> fetchPokemon(randomNumber) async {
    final url = Uri.parse(
        'https://pokeapi.co/api/v2/pokemon?offset=$randomNumber 0&limit=20');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> results = data['results'];

      List<dynamic> detailedPokemonList = [];
      for (var pokemon in results) {
        final pokemonDetailsResponse =
            await http.get(Uri.parse(pokemon['url']));
        if (pokemonDetailsResponse.statusCode == 200) {
          var poke = json.decode(pokemonDetailsResponse.body);
          var pokeResponse = await http.get(Uri.parse(poke['species']['url']));

          var chainEvolution = json.decode(pokeResponse.body);

          poke['evolution_chain'] = chainEvolution['evolution_chain']['url'];

          detailedPokemonList.add(poke);
        }
      }

      return detailedPokemonList;
    }
    return [];
  }

  static Future<List<dynamic>> fetchPokemonFavorites(token, userId) async {
    final url = Uri.parse('${URIP.uri}/$userId');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['favoritePokemons'];
    }
    return [];
  }

  static Future<String> addPokemonFavoriteApi(pokemon, token, userId) async {
    final url = Uri.parse('${URIP.uri}/');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        'userId': userId,
        'pokemonFront': {
          'name': pokemon['name'],
          'id': pokemon['id'],
          'species': {'url': pokemon['species']['url']},
          'evolution_chain':
              pokemon['evolution_chain'], // Agregar la cadena de evolución
          'sprites': {
            'front_default': pokemon['sprites']['front_default'],
          },
          'types': pokemon['types'],
          'abilities': pokemon['abilities'],
          'stats': pokemon['stats'],
        },
      }),
    );
    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      return data['message'];
    }

    return data['error'] ??
        'Ocurrió un error al agregar el pokémon a favoritos';
  }
}
