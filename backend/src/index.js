require("dotenv").config();
const express = require("express");
const cors = require("cors");
const { PrismaClient } = require("@prisma/client");

const prisma = new PrismaClient();
const app = express();

app.use(cors());
app.use(express.json());

// 🔁 Helper: Safe JSON stringify for BigInt
function stringifyBigInts(obj) {
  return JSON.parse(JSON.stringify(obj, (_, value) =>
    typeof value === 'bigint' ? value.toString() : value
  ));
}

// 🔁 Health check route
app.get("/", (req, res) => {
  res.send("FitFi backend is live 💪");
});

// ✅ Create a new user with validations
app.post("/api/users", async (req, res) => {
  try {
    const wallet_address = req.body.wallet_address.trim();
    const username = req.body.username.trim();
    const email = req.body.email.trim().toLowerCase();

    // 🔐 Username validation
    const usernameRegex = /^[a-zA-Z0-9_]{4,16}$/;
    if (!usernameRegex.test(username)) {
      return res.status(400).json({
        error: "Username must be 4–16 characters with letters, numbers, or underscores only.",
      });
    }

    // 🔐 Email validation
    const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    if (!emailRegex.test(email)) {
      return res.status(400).json({ error: "Invalid email format." });
    }

    // ❌ Duplicate wallet check
    const existingWallet = await prisma.user.findUnique({
      where: { wallet_address },
    });

    if (existingWallet) {
      return res.status(400).json({ error: "Wallet address already exists." });
    }

    // ❌ Duplicate email check
    const existingEmail = await prisma.user.findUnique({
      where: { email },
    });

    if (existingEmail) {
      return res.status(400).json({ error: "Email already in use." });
    }

    // ✅ Create user
    const user = await prisma.user.create({
      data: { wallet_address, username, email },
    });

    res.status(201).json(stringifyBigInts(user));
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to create user" });
  }
});

// ✅ Save a map track
app.post("/api/maptrack", async (req, res) => {
  try {
    const { user_id, quest_id, session_id, latitude, longitude, fieldTimestamp } = req.body;

    const track = await prisma.mapTrack.create({
      data: {
        user_id,
        quest_id,
        session_id,
        latitude,
        longitude,
        fieldTimestamp: new Date(fieldTimestamp),
      },
    });

    res.status(201).json(stringifyBigInts(track));
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to save map track" });
  }
});

// 📍 Get all map track points for a session
app.get("/api/maptrack/:session_id", async (req, res) => {
  try {
    const session_id = BigInt(req.params.session_id); // convert to BigInt

    const mapTracks = await prisma.mapTrack.findMany({
      where: { session_id },
      orderBy: { fieldTimestamp: 'asc' }, // chronological
    });

    res.status(200).json(stringifyBigInts(mapTracks));
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to fetch map track data" });
  }
});

// 🚀 Start server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`✅ Server running on port ${PORT}`));
