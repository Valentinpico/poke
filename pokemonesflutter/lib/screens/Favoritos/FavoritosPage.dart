import 'package:flutter/material.dart';
import 'package:pokemonesflutter/Api/PokemonApi.dart';

class FavoritePage extends StatelessWidget {
  final List<dynamic> favoritePokemons;
  final bool isLoading;

  final String userId;
  final String token;

  final void Function(int) onItemTapped;

  const FavoritePage({
    Key? key,
    required this.favoritePokemons,
    required this.isLoading,
    required this.userId,
    required this.token,
    required this.onItemTapped,
  }) : super(key: key);

  String obtenerEstadoEvolucion(evolutions, int id) {
    if (evolutions.length == 1) {
      return "No tiene evolución";
    }

    if (evolutions.last['id'] == id) {
      return "Nivel Max.";
    }

    return "Evolucionar";
  }

  _evolution(BuildContext context, pokemon, token, userId) {
    PokemonApi.evolutionPokemon(pokemon, token, userId).then((data) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data)));
      onItemTapped(1);
    });
  }

  _delete(BuildContext context, pokemon, token) {
    PokemonApi.deletePokemonFavoriteApi(pokemon['_id'], token).then((data) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data)));
      onItemTapped(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return favoritePokemons.isEmpty
        ? Center(
            child: isLoading
                ? CircularProgressIndicator()
                : Text("No hay pokemones favoritos"))
        : ListView.builder(
            itemCount: favoritePokemons.length,
            itemBuilder: (context, index) {
              final pokemon = favoritePokemons[index];
              final name = pokemon['name'];
              final imageUrl = pokemon['image'];

              final stats = pokemon['stats']
                  .entries
                  .map((e) => '${e.key}: ${e.value}')
                  .join(', ');

              String evolutions =
                  obtenerEstadoEvolucion(pokemon['evolutions'], pokemon['id']);

              return Card(
                color: Colors.blueGrey[800],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 150,
                        height: 150,
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              name.toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tipos:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text('${pokemon['types'].join(', ')}'),
                            const SizedBox(height: 4),
                            Text(
                              'Habilidades:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('${pokemon['abilities'].join(', ')}',
                                style: TextStyle(color: Colors.white60)),
                            const SizedBox(height: 4),
                            Text(
                              'Estadísticas:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('$stats',
                                style: TextStyle(color: Colors.white60)),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextButton(
                                    onPressed: () => _evolution(
                                        context, pokemon, token, userId),
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.black54,
                                    ),
                                    child: Text(
                                      evolutions,
                                      style: TextStyle(color: Colors.white),
                                    )),
                                TextButton(
                                    onPressed: () =>
                                        _delete(context, pokemon, token),
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                    ),
                                    child: Text(
                                      'Eliminar',
                                      style: TextStyle(color: Colors.white),
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
