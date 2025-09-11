// import express from "express";
import { Router, Request, Response } from "express";
import User from "../models/user";
import bcryptjs from "bcryptjs";

const authRouter = Router();

authRouter.post("/api/signup", async (req: Request, res: Response) => {
  try {
    // get the data from client (json body)
    /* default json body
  {
    'name': name,
    'email': email,
    'password': password,
  }
  */
    const { name, email, password } = req.body;

    const existingUser = await User.findOne({ email });

    if (existingUser) {
      return res.json({ message: "User with same email is already exists!" });
    }

    const hashedPassword = await bcryptjs.hash(password, 8);

    let user = new User({
      email,
      password: hashedPassword,
      name,
    });

    user = await user.save();
    res.json(user);

    // post that data in database
    // return that data to the user
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    res.status(500).json({ error: message });
  }
});

export default authRouter;
