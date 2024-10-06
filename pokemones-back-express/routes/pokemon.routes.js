import { Router } from "express";
import {
  addFavoritePokemon,
  getFavoritePokemons,
  evolvePokemon,
  deleteFavoritePokemon,
} from "../controllers/pokemon.controller.js";
import { authenticateToken } from "../middlewares/token.js";

const router = Router();

router.post("/", authenticateToken, addFavoritePokemon);
router.get("/:userId", authenticateToken, getFavoritePokemons);
router.put("/:userId/:pokemonId", authenticateToken, evolvePokemon);
router.delete("/:id", authenticateToken, deleteFavoritePokemon);

export default router;
