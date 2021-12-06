const express = require("express");
const cors = require("cors");
const app = express();
const rootRouter = express.Router();
const { todoRouter } = require("./api/todo");
const PORT = process.env.PORT || 9001;
app.use(cors());

rootRouter.get("/", (req, res) => {
  res.send({ ok: true, date: new Date() });
});

app.use((req, res, next) => {
  const log = `${req.method}: ${req.hostname}${req.url}`;
  console.log("url", log);
  console.log("headers", req.headers);
  next();
});
app.use("/todo", todoRouter);
app.use(rootRouter);
app.listen(PORT, () => console.log("Listenting on", PORT));
