import "dotenv/config";
import { connect } from "mongoose";

const MONGO_URI = process.env.MONGO_URI;

export const dbConnection = async () => {
  try {
    await connect(MONGO_URI);
    console.log("base de datos ejecutandose sin problemas");
  } catch (error) {
    console.log(error);
  }
};
