const express = require("express");
const app = express();
const port = 3000;

app.get("/", (req, res) => res.send("Meow\n"));
app.listen(port, () => console.log(`App started on http://localhost:${port}`));
