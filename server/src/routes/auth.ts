// import express from "express";
import { Router, Request, Response } from "express";
import User from "../models/user";
import bcryptjs from "bcryptjs";
import jwt from "jsonwebtoken";
import { error } from "console";

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
      return res
        .status(400)
        .json({ message: "User with the same email already exists!" });
    }

    const hashedPassword = await bcryptjs.hash(password, 8);

    // create a new user
    let user = new User({
      email,
      password: hashedPassword,
      name,
    });

    // post that data in database
    user = await user.save();

    // return that data to the user
    res.status(201).json(user);
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    res.status(500).json({ error: message });
  }
});

authRouter.post("/api/signin", async (req: Request, res: Response) => {
  try {
    const { email, password } = req.body;

    const existingUser = await User.findOne({ email });

    if (!existingUser) {
      return res
        .status(400)
        .json({ message: "User with this email addres does not exist!" });
    }

    const isMatchPassword = await bcryptjs.compare(
      password,
      existingUser.password
    );
    if (!isMatchPassword) {
      return res.status(400).json({ error: "Incorrect password!" });
    }

    const token = jwt.sign({ id: existingUser._id }, "passwordKey");

    res.json({ token, ...existingUser });
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    res.status(500).json({ error: message });
  }
});

export default authRouter;
