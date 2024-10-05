//formato de data que se envia desde el front para agregar un pokemon a favoritos
const data = {
  userId: "67006f45a6332289de7245a4",
  pokemonFront: {
    name: "bulbasaur",
    id: 3,
    species: {
      url: "https://pokeapi.co/api/v2/pokemon-species/1/",
    },
    evolution_chain: {
      url: "https://pokeapi.co/api/v2/evolution-chain/1/",
    },
    sprites: {
      front_default:
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png",
    },
    stats: [
      {
        base_stat: 45,
        effort: 0,
        stat: {
          name: "hp",
          url: "https://pokeapi.co/api/v2/stat/1/",
        },
      },
      {
        base_stat: 49,
        effort: 0,
        stat: {
          name: "attack",
          url: "https://pokeapi.co/api/v2/stat/2/",
        },
      },
      {
        base_stat: 49,
        effort: 0,
        stat: {
          name: "defense",
          url: "https://pokeapi.co/api/v2/stat/3/",
        },
      },
      {
        base_stat: 65,
        effort: 1,
        stat: {
          name: "special-attack",
          url: "https://pokeapi.co/api/v2/stat/4/",
        },
      },
      {
        base_stat: 65,
        effort: 0,
        stat: {
          name: "special-defense",
          url: "https://pokeapi.co/api/v2/stat/5/",
        },
      },
      {
        base_stat: 45,
        effort: 0,
        stat: {
          name: "speed",
          url: "https://pokeapi.co/api/v2/stat/6/",
        },
      },
    ],
    abilities: [
      {
        ability: {
          name: "overgrow",
          url: "https://pokeapi.co/api/v2/ability/65/",
        },
        is_hidden: false,
        slot: 1,
      },
      {
        ability: {
          name: "chlorophyll",
          url: "https://pokeapi.co/api/v2/ability/34/",
        },
        is_hidden: true,
        slot: 3,
      },
    ],
    types: [
      {
        slot: 1,
        type: {
          name: "grass",
          url: "https://pokeapi.co/api/v2/type/12/",
        },
      },
      {
        slot: 2,
        type: {
          name: "poison",
          url: "https://pokeapi.co/api/v2/type/4/",
        },
      },
    ],
  },
};
