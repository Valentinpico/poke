// models/Pokemon.js
import { Schema, model } from "mongoose";

// Definir el esquema de Pokémon
const pokemonSchema = new Schema(
  {
    id: {
      type: Number,
      required: true,
    },
    userId: {
      type: Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    name: {
      type: String,
      required: true,
    },
    image: {
      type: String,
      required: true,
    },
    types: [
      {
        type: String,
        required: true,
      },
    ],
    abilities: [
      {
        type: String,
        required: true,
      },
    ],
    stats: {
      hp: {
        type: Number,
        required: true,
      },
      attack: {
        type: Number,
        required: true,
      },
      defense: {
        type: Number,
        required: true,
      },
      specialAttack: {
        type: Number,
        required: true,
      },
      specialDefense: {
        type: Number,
        required: true,
      },
      speed: {
        type: Number,
        required: true,
      },
    },
    chainEvolution: {
      type: String,
    },
    evolutions: [
      {
        id: { type: Number },
        name: { type: String },
        image: { type: String },
        urlSpecie: { type: String },
        urlpokemon: { type: String },
      },
    ],
  },
  {
    timestamps: true,
  }
);

const Pokemon = model("Pokemon", pokemonSchema);

export default Pokemon;
