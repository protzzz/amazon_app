import { UUID } from "crypto";
import { Request, Response, NextFunction } from "express";
import jwt from "jsonwebtoken";
import User from "../models/user";

export interface AuthRequest extends Request {
  user?: UUID;
  token?: string;
}

export const auth = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    // Extract the token from the request header.
    const token = req.header("x-auth-token");
    if (!token)
      return res.status(401).json({ message: "No auth token! Access denied." });

    // Verify the token's validity using the secret key.
    const isVerified = jwt.verify(token, "passwordKey");
    if (!isVerified)
      return res.status(401).json({ message: "Token verification failed!" });

    const verifiedToken = isVerified as { id: UUID };

    const user = await User.findById(verifiedToken.id);
    if (!user) return res.status(401).json({ message: "User not found!" });

    req.user = verifiedToken.id;
    req.token = token;
    next();
  } catch (error) {
    res.status(500).json({ error: error });
  }
};
