import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
    fetchPokemon();
    getStoredUserId();
  }

  Future<void> getStoredUserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
    token = prefs.getString('auth_token') ?? '';
  }

  Future<void> fetchPokemon() async {
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
          detailedPokemonList.add(json.decode(pokemonDetailsResponse.body));
        }
      }

      setState(() {
        pokemonList = detailedPokemonList;
      });
    }
  }

  Future<void> addPokemonFavoriteApi(pokemon) async {
    final url = Uri.parse('http://192.168.0.121:3000/api/pokemon/');
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
              'https://pokeapi.co/api/v2/evolution-chain/1/', // Agregar la cadena de evolución
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'])),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(data['error'] ?? 'Error al agregar a favoritos')),
      );
    }
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
    } else if (index == 1) {
      Navigator.pushNamed(context, '/favoritos');
    } else if (index == 2) {
      logout(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Pokémon')),
      bottomSheet: TextButton(
          style: TextButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 117, 172, 216),
              textStyle: TextStyle(color: Color(0xFFFFFFFF)) // Color de fondo
              ), // Estilo para el botón de cargar más
          onPressed: () => {
                setState(() {
                  randomNumber = Random().nextInt(100);
                }),
                fetchPokemon()
              },
          child: const Text('Cargar más')),
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
                                      addPokemonFavoriteApi(pokemon);
                                    },
                                    child: const Text('Agregar a favoritos'),
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
          : Container(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
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
