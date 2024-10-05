import { Router } from "express";
import {
  addFavoritePokemon,
  getFavoritePokemons,
  evolvePokemon,
  deleteFavoritePokemon,
} from "../controllers/pokemon.controller.js";
import { authenticateToken } from "../middlewares/token.js";

const router = Router();

router.get("/:userId", getFavoritePokemons);
router.post("/", addFavoritePokemon);
router.put("/:userId/:pokemonId", authenticateToken, evolvePokemon);
router.delete("/:id", authenticateToken, deleteFavoritePokemon);

export default router;
