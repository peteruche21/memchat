const express = require("express");
const bodyParser = require("body-parser");
const fs = require("fs");
const handle = require("./function"); // Import the handle function

const app = express();
const port = 4001;

app.use(bodyParser.json());

// Load the initial state from a JSON file
let state = require("./state.json");

// Endpoint to get the current state
app.get("/api/state/:contract", (req, res) => {
  const { contract } = req.params;
  if (contract !== "QGpH2VTY7wKGQc_e2j_2KFCTMeL4hgbkWpsVweNa1Oo") {
    res.status(400).json({ error: "Invalid function ID" });
  }
  res.json(state);
});

// Endpoint to update the state by calling the handle function
app.post("/api/transactions", async (req, res) => {
  const { functionId, inputs } = req.body;

  if (functionId !== "QGpH2VTY7wKGQc_e2j_2KFCTMeL4hgbkWpsVweNa1Oo") {
    res.status(400).json({ error: "Invalid function ID" });
  }

  try {
    // Call the handle function with the current state and inputs
    const result = await handle(state, inputs[0]);

    const newState = result.state; // Update the state with the result

    // Save the updated state to the JSON file
    fs.writeFileSync("./state.json", JSON.stringify(newState, null, 2));

    res.json({
      staus: "SUCCESS",
      data: {
        pseudoId:
          "cbdc8f94c47118ca84cc71c11f2afc838ffc76ac6f474ae491a61008fcbab62f34c00b594bf412f3b4cf52",
        execution: {
          state: newState,
          result: null,
          validity: {},
          exmContext: {},
          kv: {},
          errors: {},
        },
      },
    });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

app.listen(port, () => {
  console.log(`Express server is listening on port ${port}`);
});
