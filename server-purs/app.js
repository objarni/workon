const express = require("express")
const Main = require("./output/Main/index.js")

const app = express()

let state = []

app.get("/:alias/workon/:workingon", (req, res) => {
    const timestamp = process.uptime()
    const alias = req.params.alias;
    const workingon = req.params.workingon;
    let heartbeat = { alias, workingon, timestamp }
    state = Main.updateState(heartbeat)(state);
    res.send(Main.convertToJson(state))
});

app.listen(8080, () => {
    console.log("Server running")
})
