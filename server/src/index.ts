// IMPORT FROM PACKAGES
import express from "express";
import mongoose from "mongoose";
import dotenv from "dotenv";

// IMPORT FROM FILES
import authRouter from "./routes/auth";

// INIT
dotenv.config();
const app = express();
const PORT = 3000;
const DB_URI = `mongodb+srv://${process.env.MONGO_DB_URI_NAME}:${process.env.MONGO_DB_URI_PASSWORD}@cluster0.mtkozwf.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0`;

// console.log("ENV USER:", process.env.MONGO_DB_URI_NAME);
// console.log("ENV PASS LEN:", (process.env.MONGO_DB_URI_PASSWORD || "").length);

mongoose.connect(DB_URI);

// middleware
app.use(express.json());
app.use(authRouter);

mongoose
  .connect(DB_URI)
  .then(() => {
    console.log("Connection successful");
  })
  .catch((e) => {
    console.log(e);
  });

app.listen(PORT, () => {
  console.log(`connected at port ${PORT}`);
});
