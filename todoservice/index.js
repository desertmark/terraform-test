const express = require("express");
const cors = require("cors");
const app = express();
const todoRouter = express.Router();
const rootRouter = express.Router();
const PORT = process.env.PORT || 8080;
app.use(cors());

rootRouter.get("/", (req, res) => {
  res.send({ ok: true, date: new Date() });
});

todoRouter.get("/todo", (req, res) => {
  res.json([
    {
      id: 1,
      text: "Example task to do",
    },
  ]);
});

app.use(todoRouter);
app.use(rootRouter);
app.listen(PORT, () => console.log("Listenting on", PORT));