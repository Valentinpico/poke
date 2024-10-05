// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../Api/PokemonApi.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<dynamic> pokemonList = [];
  int _selectedIndex = 0;
  Set<int> favoritePokemonIndices =
      {}; // Conjunto para almacenar índices de favoritos
  String userId = '6701839797bec2b0da0a58fd';
  String token = '';

  @override
  void initState() {
    super.initState();
    PokemonApi.fetchPokemonFavorites(token, userId).then((data) {
      setState(() {
        pokemonList = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Pokémon Favoritos'),
        ),
        body: ListView.builder(
          itemCount: pokemonList.length,
          itemBuilder: (context, index) {
            final pokemon = pokemonList[index];
            return ListTile(
              title: Text(pokemon['name']),
              subtitle: Text(pokemon['type']),
              trailing: IconButton(
                icon: const Icon(Icons.favorite),
                onPressed: () {
                  setState(() {
                    favoritePokemonIndices.add(index);
                  });
                },
              ),
            );
          },
        ));
  }
}
