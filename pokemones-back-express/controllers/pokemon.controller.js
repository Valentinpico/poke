import Pokemon from "../models/pokemon.model.js";
import axios from "axios";
export const addFavoritePokemon = async (req, res) => {
  const { userId, pokemonFront } = req.body;
  console.log(req.body);

  try {
    let pokemon = await Pokemon.findOne({
      id: parseInt(pokemonFront.id),
      userId: userId,
    });
    const chainEvolutionExist = await Pokemon.findOne({
      chainEvolution: pokemonFront.evolution_chain,
      userId: userId,
    });

    if (pokemon) {
      return res.status(400).json({ error: "Pokémon ya está en favoritos" });
    }

    if (chainEvolutionExist) {
      return res.status(400).json({
        error: `El Pokémon ya está en favoritos (pertenece a la misma cadena evolutiva que ${chainEvolutionExist.name}).`,
      });
    }

    const pokemonData = pokemonFront;

    const speciesPokemon = await axios
      .get(pokemonData.species.url)
      .then((res) => res.data);

    const chainEvolution = speciesPokemon.evolution_chain.url;

    const evolutionChain = await axios
      .get(speciesPokemon.evolution_chain.url)
      .then((res) => res.data);

    const idFirstEvolution = evolutionChain.chain.species.url.split("/")[6];

    const evolutions = [
      {
        id: idFirstEvolution,
        image: `https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${idFirstEvolution}.png`,
        name: evolutionChain.chain.species.name,
        urlSpecie: evolutionChain.chain.species.url,
        urlpokemon: `https://pokeapi.co/api/v2/pokemon/${idFirstEvolution}`,
      },
    ];

    let evolution = evolutionChain.chain.evolves_to[0];

    while (evolution) {
      const specieData = await axios.get(evolution.species.url);
      const pokeData = await axios.get(
        `https://pokeapi.co/api/v2/pokemon/${specieData.data.id}`
      );
      evolutions.push({
        id: specieData.data.id,
        name: specieData.data.name,
        image: pokeData.data.sprites.front_default,
        urlSpecie: evolution.species.url,
        urlpokemon: `https://pokeapi.co/api/v2/pokemon/${specieData.data.id}`,
      });
      evolution = evolution.evolves_to[0];
    }

    pokemon = new Pokemon({
      id: parseInt(pokemonData.id),
      userId: userId,
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
      chainEvolution: chainEvolution,
      evolutions: evolutions,
    });

    await pokemon.save();

    res.status(200).json({ message: "Pokémon agregado a favoritos", pokemon });
  } catch (error) {
    console.log(error.message);
    res.status(500).json({
      message: "Error al agregar el Pokémon a favoritos",
      error: error.message,
    });
  }
};

export const getFavoritePokemons = async (req, res) => {
  const { userId } = req.params;

  try {
    const pokemons = await Pokemon.find({ userId }).select(
      "name image types abilities stats evolutions"
    );

    if (!pokemons.length) {
      return res.status(404).json({
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

export const evolvePokemon = async (req, res) => {
  const { userId, pokemonId } = req.params;

  try {
    let pokemon = await Pokemon.findOne({ id: pokemonId, userId });

    if (!pokemon) {
      return res.status(404).json({ message: "Pokémon no encontrado" });
    }

    const evolutions = pokemon.evolutions;

    if (evolutions.length === 1) {
      return res.status(404).json({ message: "No tiene evolucion" });
    }

    if (evolutions[evolutions.length - 1].id === pokemon.id) {
      return res.status(404).json({ message: "Ya no puede evolucionar" });
    }

    let index = evolutions.findIndex((evo) => evo.id === pokemon.id);

    const nextEvolution = evolutions[index + 1];

    const response = await axios.get(nextEvolution.urlpokemon);

    const pokemonData = response.data;

    pokemon.id = nextEvolution.id;
    pokemon.name = nextEvolution.name;
    pokemon.image = nextEvolution.image;
    pokemon.types = pokemonData.types.map((type) => type.type.name);
    pokemon.abilities = pokemonData.abilities.map(
      (ability) => ability.ability.name
    );
    pokemon.stats = {
      hp: pokemonData.stats[0].base_stat,
      attack: pokemonData.stats[1].base_stat,
      defense: pokemonData.stats[2].base_stat,
      specialAttack: pokemonData.stats[3].base_stat,
      specialDefense: pokemonData.stats[4].base_stat,
      speed: pokemonData.stats[5].base_stat,
    };
    pokemon.chainEvolution = pokemon.chainEvolution;
    pokemon.evolutions = pokemon.evolutions;

    await pokemon.save();

    res.status(200).json({ message: "Pokémon evolucionado", pokemon });
  } catch (error) {
    res.status(500).json({ message: "Error al evolucionar el Pokémon", error });
  }
};

export const deleteFavoritePokemon = async (req, res) => {
  const { id } = req.params;

  try {
    const pokemon = await Pokemon.findOneAndDelete({ _id: id });

    if (!pokemon) {
      return res.status(404).json({ message: "Pokémon no encontrado" });
    }

    res.status(200).json({ message: "Pokémon eliminado de favoritos" });
  } catch (error) {
    res
      .status(500)
      .json({ message: "Error al eliminar el Pokémon de favoritos", error });
  }
};
