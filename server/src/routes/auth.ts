// import express from "express";
import { Router, Request, Response } from "express";
import User from "../models/user";
import bcryptjs from "bcryptjs";
import jwt from "jsonwebtoken";
import { error } from "console";

const authRouter = Router();

interface SignUpBody {
  name: string;
  email: string;
  password: string;
}

interface LoginBody {
  email: string;
  password: string;
}

authRouter.post(
  "/signup",
  async (req: Request<{}, {}, SignUpBody>, res: Response) => {
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
      res.status(500).json({ error: error });
    }
  }
);

authRouter.post(
  "/login",
  async (req: Request<{}, {}, LoginBody>, res: Response) => {
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
      res.status(500).json({ error: error });
    }
  }
);

authRouter.post("/tokenIsValid", async (req: Request, res: Response) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) return res.json(false);

    const isVerified = jwt.verify(token, "passwordKey");
    if (!isVerified) return res.json(false);

    const verifiedToken = isVerified as { id: string };

    const user = await User.findById(verifiedToken.id);
    if (!user) return res.json(false);

    res.json(true);
  } catch (error) {
    res.status(500).json({ error: error });
  }
});

export default authRouter;
