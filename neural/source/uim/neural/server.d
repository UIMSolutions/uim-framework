/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.neural.server;

import uim.neural;

@safe:

struct InferenceServerConfig {
  string host = "127.0.0.1";
  ushort port = 8080;
  string route = "/predict";
  size_t maxBatch = 256;
}

/// Starts a simple Json inference endpoint for a neural network.
void serveNeuralNetwork(ref NeuralNetwork net, InferenceServerConfig cfg = InferenceServerConfig.init) @safe {
  auto router = new URLRouter;

  router.post(cfg.route, (scope HTTPServerRequest req, scope HTTPServerResponse res) {
    try {
      auto body = req.bodyReader.readAllUTF8();
      auto json = parseJson(body);
      auto inputs = parseInputs(json, cfg.maxBatch);

      auto outputs = new double[][](inputs.length);
      foreach (i, sample; inputs) {
        outputs[i] = net.predict(sample);
      }

      auto response = Json([
        "outputs": encodeOutputs(outputs)
      ]);

      res.statusCode = 200;
      res.headers["Content-Type"] = "application/json";
      res.writeBody(response.toString());
    } catch (Exception e) {
      res.statusCode = 400;
      res.headers["Content-Type"] = "application/json";
      auto errorResponse = Json([
        "error": Json(e.msg)
      ]);
      res.writeBody(errorResponse.toString());
    }
  });

  auto settings = new HTTPServerSettings;
  settings.hostName = cfg.host;
  settings.port = cfg.port;

  listenHTTP(settings, router);
  runApplication();
}

private double[][] parseInputs(const Json payload, size_t maxBatch) @safe {
  enforce(payload.isObject, "Json body must be an object with an 'inputs' array");
  auto inputsNode = payload["inputs"];
  enforce(inputsNode.isArray, "'inputs' must be an array of number arrays");

  auto rows = inputsNode.toArray;
  enforce(rows.length <= maxBatch, "Batch exceeds configured maxBatch");

  double[][] inputs;
  inputs.length = rows.length;

  foreach (i, rowNode; rows) {
    enforce(rowNode.isArray, "Each input must be an array");
    auto cols = rowNode.toArray;
    inputs[i].length = cols.length;
    foreach (j, valueNode; cols) {
      double numeric;
      if (valueNode.isDouble) numeric = valueNode.get!double;
      else if (valueNode.isInteger) numeric = to!double(valueNode.get!int);
      else numeric = 0.0;

      inputs[i][j] = numeric;
    }
  }

  return inputs;
}

private Json encodeOutputs(const double[][] outputs) @safe {
  Json[] rows;
  rows.length = outputs.length;
  foreach (i, row; outputs) {
    Json[] cols;
    cols.length = row.length;
    foreach (j, value; row) {
      cols[j] = Json(value);
    }
    rows[i] = Json(cols);
  }
  return Json(rows);
}
