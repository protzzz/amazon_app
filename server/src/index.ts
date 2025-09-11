// IMPORT FROM PACKAGES
import express from "express";
import mongoose from "mongoose";

// IMPORT FROM FILES
import authRouter from "./routes/auth";

// INIT
const app = express();
const PORT = 3000;
const DB_URI = "";

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
