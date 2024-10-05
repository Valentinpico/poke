import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokemonesflutter/screens/Favoritos/FavoritosPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Api/PokemonApi.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> pokemonList = [];
  int _selectedIndex = 0;
  Set<int> favoritePokemonIndices =
      {}; // Conjunto para almacenar índices de favoritos
  String userId = '';
  String token = '';
  int randomNumber = 0;

  @override
  void initState() {
    super.initState();
    PokemonApi.fetchPokemon(randomNumber).then((data) {
      setState(() {
        pokemonList = data;
      });
    });
    getStoredUserId();
  }

  Future<void> getStoredUserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
    token = prefs.getString('auth_token') ?? '';
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('userId');
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // Manejo para la página de inicio
    } else if (index == 2) {
      logout(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Pokémon')),
      floatingActionButton: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.deepOrange[400],
          ), // Estilo para el botón de cargar más
          onPressed: () => {
                setState(() {
                  randomNumber = Random().nextInt(100);
                }),
                PokemonApi.fetchPokemon(randomNumber).then((data) {
                  setState(() {
                    pokemonList = data;
                  });
                })
              },
          child: const Text('Cargar más aleatoriamente',
              style: TextStyle(color: Colors.white))),
      body: _selectedIndex == 0
          ? pokemonList.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: pokemonList.length,
                  itemBuilder: (context, index) {
                    final pokemon = pokemonList[index];
                    print(pokemon['evolution_chain']); // Debug print
                    final name = pokemon['name'];

                    final imageUrl = pokemon['sprites']['front_default'];
                    final types = pokemon['types']
                        .map((type) => type['type']['name'])
                        .toList();
                    final abilities = pokemon['abilities']
                        .map((ability) => ability['ability']['name'])
                        .toList();
                    final stats = pokemon['stats']
                        .map((stat) =>
                            '${stat['stat']['name']}: ${stat['base_stat']}')
                        .toList();
                    final evolutions =
                        pokemon['evolutions'] ?? 'No evolutions available';

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(
                            8.0), // Espaciado alrededor del contenido
                        child: Row(
                          children: [
                            // Contenedor para la imagen
                            Container(
                              width: 150, // Ancho deseado
                              height: 150, // Alto deseado
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit
                                    .contain, // O BoxFit.cover según prefieras
                              ),
                            ),
                            const SizedBox(
                                width:
                                    16), // Espaciado entre la imagen y el texto
                            // Columna para el texto
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    name.toUpperCase(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Tipos:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('${types.join(', ')}'),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Habilidades:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('${abilities.join(', ')}'),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Estadísticas:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('${stats.join(', ')}'),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Evoluciones:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('$evolutions'),
                                  // Botón para agregar a favoritos
                                  TextButton(
                                    onPressed: () {
                                      PokemonApi.addPokemonFavoriteApi(
                                              pokemon, token, userId)
                                          .then((message) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(message)));
                                      });
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 117, 172, 216),
                                    ),
                                    child: const Text('Agregar a favoritos',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
          : FavoritePage(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Cerrar sesión',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
