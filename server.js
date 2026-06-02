const express = require("express");
const fetch = require("node-fetch");
const cors = require("cors");
const path = require("path");

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

// Serve static frontend files
app.use(express.static(path.join(__dirname, "dist", "public")));

// Places API proxy — avoids CORS on the browser side
app.post("/api/places/search", async (req, res) => {
  const { textQuery, maxResultCount = 15 } = req.body;

  if (!textQuery || typeof textQuery !== "string" || textQuery.trim().length === 0) {
    return res.status(400).json({ error: "textQuery is required" });
  }

  const GPLACES_KEY = "AIzaSyCLjVD8cEgHqNfrsXxSPoFoSwtrB-BKYAc";

  try {
    const upstream = await fetch(
      "https://places.googleapis.com/v1/places:searchText",
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-Goog-Api-Key": GPLACES_KEY,
          "X-Goog-FieldMask":
            "places.displayName,places.formattedAddress,places.nationalPhoneNumber,places.websiteUri,places.rating,places.userRatingCount,places.id,places.businessStatus",
        },
        body: JSON.stringify({
          textQuery: textQuery.trim(),
          maxResultCount: Math.min(Number(maxResultCount) || 15, 20),
        }),
      }
    );

    const data = await upstream.json();

    if (!upstream.ok) {
      console.error("Places API error:", data);
      return res.status(upstream.status).json({
        error: data.error?.message || "Places API error",
        details: data,
      });
    }

    return res.json(data);
  } catch (err) {
    console.error("Proxy error:", err);
    return res.status(500).json({ error: "Internal proxy error", message: err.message });
  }
});

// SPA fallback — serve index.html for all other routes
app.get("*", (req, res) => {
  res.sendFile(path.join(__dirname, "dist", "public", "index.html"));
});

app.listen(PORT, () => {
  console.log(`Infinity AI server running on port ${PORT}`);
});
