// import express from "express"
import { createServer } from "http"

import LfmError from "./LfmError.js"

createServer((req, res) => {
  res.writeHead(500)
  res.end()
}).listen()

return

const app = express()
app.disable("etag")

app.get("/2.0/", (req, res) => {
  if (req.query.format !== "json") {
    return res.status(400).send()
  }
  try {
    switch (req.query.method.toLowerCase()) {
      case "auth.getsession":
        break
      default:
        throw new LfmError(6)
    }
  } catch (ex) {
    if (ex instanceof LfmError) {
      return res.status(400).type("json").send(ex.toJSON())
    }
  }
  return res.status(500).send()
})

app.listen(8001)
