import Pokemon from "../src/models/Pokemon.js"; // Importa el modelo de Pokémon
import User from "../../models/user.model.js";

export const addFavoritePokemon = async (req, res) => {
  const { userId, pokemonId } = req.body;

  try {
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ message: "Usuario no encontrado" });
    }

    let pokemon = await Pokemon.findOne({ id: pokemonId, userId });

    if (pokemon) {
      return res.status(400).json({ message: "Pokémon ya está en favoritos" });
    }

    const response = await axios.get(
      `https://pokeapi.co/api/v2/pokemon/${pokemonId}`
    );

    const pokemonData = response.data;

    pokemon = new Pokemon({
      id: pokemonData.id,
      userId: user._id,
      name: pokemonData.name,
      image: pokemonData.sprites.front_default,
      types: pokemonData.types.map((type) => type.type.name),
      abilities: pokemonData.abilities.map((ability) => ability.ability.name),
      stats: {
        hp: pokemonData.stats[0].base_stat,
        attack: pokemonData.stats[1].base_stat,
        defense: pokemonData.stats[2].base_stat,
        specialAttack: pokemonData.stats[3].base_stat,
        specialDefense: pokemonData.stats[4].base_stat,
        speed: pokemonData.stats[5].base_stat,
      },
      evolutions: [],
    });

    await pokemon.save();

    res.status(200).json({ message: "Pokémon agregado a favoritos", user });
  } catch (error) {
    res
      .status(500)
      .json({ message: "Error al agregar el Pokémon a favoritos", error });
  }
};

export const getFavoritePokemons = async (req, res) => {
  const { userId } = req.params;

  try {
    const pokemons = await Pokemon.find({ userId }).select(
      "name image types abilities stats evolutions"
    );

    if (!pokemons.length) {
      return res
        .status(404)
        .json({
          message: "No se encontraron Pokémon favoritos para este usuario.",
        });
    }

    res.status(200).json({ favoritePokemons: pokemons });
  } catch (error) {
    res
      .status(500)
      .json({ message: "Error al recuperar los Pokémon favoritos", error });
  }
};
