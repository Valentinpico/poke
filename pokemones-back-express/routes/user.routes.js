import { Router } from "express";
import { createUser, getUser, login } from "../controllers/user.controller.js";

const router = Router();

router.get("/:id", getUser);
router.post("/", createUser);
router.post("/login", login);

export default router;
