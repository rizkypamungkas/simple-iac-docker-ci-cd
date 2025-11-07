const express = require("express");
const path = require("path");
const app = express();
const PORT = process.env.PORT || 3000;

// Path ke folder html dan css
const htmlPath = path.join(__dirname, "html");
const cssPath = path.join(__dirname, "css");

// Serve file statis (biar bisa akses /css/style.css dari browser)
app.use(express.static(htmlPath));
app.use("/css", express.static(cssPath));

// Kirim index.html untuk route utama
app.get("/", (req, res) => {
  res.sendFile(path.join(htmlPath, "index.html"));
});

app.listen(PORT, () => {
  console.log(`✅ Server running at http://localhost:${PORT}`);
});
