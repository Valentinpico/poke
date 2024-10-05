import express from "express";

import userRouter from "./routes/user.routes.js";
import pokemonRouter from "./routes/pokemon.routes.js";
import { dbConnection } from "./database/db.js";

const app = express();

dbConnection();
app.use(express.json());
app.use("/api/user", userRouter);
app.use("/api/pokemon", pokemonRouter);

const port = 3000;

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`);
});
