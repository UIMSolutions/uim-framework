/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
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

/// Starts a simple JSON inference endpoint for a neural network.
void serveNeuralNetwork(ref NeuralNetwork net, InferenceServerConfig cfg = InferenceServerConfig.init) @safe {
  auto router = new URLRouter;

  router.post(cfg.route, (scope HTTPServerRequest req, scope HTTPServerResponse res) {
    try {
      auto body = req.bodyReader.readAllUTF8();
      auto json = parseJSON(body);
      auto inputs = parseInputs(json, cfg.maxBatch);

      auto outputs = new double[][](inputs.length);
      foreach (i, sample; inputs) {
        outputs[i] = net.predict(sample);
      }

      auto response = JSONValue([
        "outputs": encodeOutputs(outputs)
      ]);

      res.statusCode = 200;
      res.headers["Content-Type"] = "application/json";
      res.writeBody(response.toString());
    } catch (Exception e) {
      res.statusCode = 400;
      res.headers["Content-Type"] = "application/json";
      auto errorResponse = JSONValue([
        "error": JSONValue(e.msg)
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

private double[][] parseInputs(const JSONValue payload, size_t maxBatch) @safe {
  enforce(payload.type == JSONType.object, "JSON body must be an object with an 'inputs' array");
  auto inputsNode = payload["inputs"];
  enforce(inputsNode.type == JSONType.array, "'inputs' must be an array of number arrays");

  auto rows = inputsNode.array;
  enforce(rows.length <= maxBatch, "Batch exceeds configured maxBatch");

  double[][] inputs;
  inputs.length = rows.length;

  foreach (i, rowNode; rows) {
    enforce(rowNode.type == JSONType.array, "Each input must be an array");
    auto cols = rowNode.array;
    inputs[i].length = cols.length;
    foreach (j, valueNode; cols) {
      enforce(valueNode.type == JSONType.float_ || valueNode.type == JSONType.integer || valueNode.type == JSONType.uinteger, "Inputs must contain numeric values");

      double numeric;
      final switch (valueNode.type) {
        case JSONType.float_:
          numeric = valueNode.floating;
          break;
        case JSONType.integer:
          numeric = to!double(valueNode.integer);
          break;
        case JSONType.uinteger:
          numeric = to!double(valueNode.uinteger);
          break;
        default:
          numeric = 0.0;
      }

      inputs[i][j] = numeric;
    }
  }

  return inputs;
}

private JSONValue encodeOutputs(const double[][] outputs) @safe {
  JSONValue[] rows;
  rows.length = outputs.length;
  foreach (i, row; outputs) {
    JSONValue[] cols;
    cols.length = row.length;
    foreach (j, value; row) {
      cols[j] = JSONValue(value);
    }
    rows[i] = JSONValue(cols);
  }
  return JSONValue(rows);
}
