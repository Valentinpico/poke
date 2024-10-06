import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pokemonesflutter/screens/Favoritos/FavoritosPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Api/pokemonApi.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> pokemonList = [];
  int _selectedIndex = 0;
  List<dynamic> favoritePokemons = [];
  String userId = '';
  String token = '';
  int randomNumber = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getStoredUserId();

    PokemonApi.fetchPokemon(randomNumber).then((data) {
      setState(() {
        pokemonList = data;
      });
    });
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
      _isLoading = true;
    });

    if (index == 0) {
      PokemonApi.fetchPokemon(randomNumber).then((data) {
        setState(() {
          pokemonList = data;
        });
      });
    }

    if (index == 1) {
      PokemonApi.fetchPokemonFavorites(token, userId).then((data) {
        setState(() {
          favoritePokemons = data;
        });
      });
    }

    if (index == 2) {
      logout(context);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _loadMore() {
    setState(() {
      randomNumber = Random().nextInt(29);
    });
    pokemonList.clear();
    print(randomNumber);
    PokemonApi.fetchPokemon(randomNumber).then((data) {
      setState(() {
        pokemonList = data;
      });
    });
  }

  void _addFavorite(pokemon) {
    PokemonApi.addPokemonFavoriteApi(pokemon, token, userId).then((message) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Pokémones' : "Pokémones Favoritos",
            style: TextStyle(color: Colors.white)),
      ),
      floatingActionButton: _selectedIndex == 0
          ? TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.deepOrange[600],
              ),
              onPressed: _loadMore,
              child: const Text('Cargar más',
                  style: TextStyle(color: Colors.white)))
          : null,
      body: _selectedIndex == 0
          ? pokemonList.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: pokemonList.length,
                  itemBuilder: (context, index) {
                    final pokemon = pokemonList[index];
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
                      color: Colors.blueGrey[800],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
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
                                  Text('${types.join(', ')}'),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Habilidades:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text('${abilities.join(', ')}',
                                      style: TextStyle(color: Colors.white60)),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Estadísticas:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text('${stats.join(', ')}',
                                      style: TextStyle(color: Colors.white60)),
                                  const SizedBox(height: 4),
                                  TextButton(
                                      onPressed: () => _addFavorite(pokemon),
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.black54,
                                      ),
                                      child: const Text(
                                        'Agregar a favoritos',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
          : FavoritePage(
              favoritePokemons: favoritePokemons,
              token: token,
              userId: userId,
              isLoading: _isLoading,
              onItemTapped: _onItemTapped),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'favorites',
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.logout,
            ),
            label: 'Cerrar sesión',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        onTap: _onItemTapped,
      ),
    );
  }
}
