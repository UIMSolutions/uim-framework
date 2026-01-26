/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.neural.training;

import std.algorithm : min, shuffle;
import std.exception : enforce;
import std.math : sqrt;
import std.random : Random, unpredictableSeed;

import uim.neural.losses;
import uim.neural.network;

@safe:

struct Dataset {
  double[][] inputs;
  double[][] targets;

  size_t length() const @safe {
    return inputs.length;
  }

  size_t inputSize() const @safe {
    return inputs.length ? inputs[0].length : 0;
  }

  size_t outputSize() const @safe {
    return targets.length ? targets[0].length : 0;
  }

  void validate() const @safe {
    enforce(inputs.length == targets.length, "Dataset inputs and targets must align");
    if (inputs.length == 0) {
      return;
    }
    const size_t inSize = inputs[0].length;
    const size_t outSize = targets[0].length;
    foreach (sample; inputs) {
      enforce(sample.length == inSize, "All inputs must share the same dimensionality");
    }
    foreach (sample; targets) {
      enforce(sample.length == outSize, "All targets must share the same dimensionality");
    }
  }

  /// Normalizes each feature dimension to zero mean and unit variance.
  void normalizeInputs(double epsilon = 1e-8) @safe {
    validate();
    if (inputs.length == 0) {
      return;
    }

    const size_t featureCount = inputs[0].length;
    auto mean = new double[featureCount];
    auto var = new double[featureCount];

    foreach (sample; inputs) {
      foreach (i, value; sample) {
        mean[i] += value;
      }
    }
    foreach (i; 0 .. featureCount) {
      mean[i] /= inputs.length;
    }

    foreach (sample; inputs) {
      foreach (i, value; sample) {
        double diff = value - mean[i];
        var[i] += diff * diff;
      }
    }
    foreach (i; 0 .. featureCount) {
      var[i] = var[i] / inputs.length + epsilon;
      var[i] = 1.0 / sqrt(var[i]);
    }

    foreach (ref sample; inputs) {
      foreach (i, ref value; sample) {
        value = (value - mean[i]) * var[i];
      }
    }
  }
}

struct TrainConfig {
  size_t epochs = 100;
  size_t batchSize = 1;
  double learningRate = 0.01;
  bool shuffleBatches = true;
}

struct TrainLog {
  size_t epoch;
  double loss;
}

TrainLog[] train(ref NeuralNetwork net, Dataset data, const Loss l, TrainConfig cfg) @safe {
  data.validate();
  enforce(cfg.batchSize > 0, "Batch size must be positive");
  enforce(net.layers.length > 0, "Network must have at least one layer");
  enforce(net.inputSize == 0 || net.inputSize == data.inputSize(), "Network input size and dataset inputs must match");
  enforce(net.outputSize == 0 || net.outputSize == data.outputSize(), "Network output size and targets must match");

  TrainLog[] history;
  auto indices = new size_t[data.length];
  foreach (i; 0 .. data.length) {
    indices[i] = i;
  }
  auto rng = Random(unpredictableSeed);

  foreach (epoch; 0 .. cfg.epochs) {
    if (cfg.shuffleBatches) {
      shuffle(indices, rng);
    }

    double epochLoss = 0.0;
    size_t batchCount = 0;

    for (size_t start = 0; start < data.length; start += cfg.batchSize) {
      size_t end = min(start + cfg.batchSize, data.length);
      auto batchInputs = new double[][](end - start);
      auto batchTargets = new double[][](end - start);

      foreach (bi, idx; indices[start .. end]) {
        batchInputs[bi] = data.inputs[idx];
        batchTargets[bi] = data.targets[idx];
      }

      double batchLoss = runBatch(net, batchInputs, batchTargets, l, cfg.learningRate);
      epochLoss += batchLoss;
      ++batchCount;
    }

    double averaged = batchCount ? epochLoss / batchCount : epochLoss;
    history ~= TrainLog(epoch + 1, averaged);
  }

  return history;
}

/// Runs forward/backward for a single batch and applies SGD updates.
double runBatch(ref NeuralNetwork net, double[][] batchInputs, double[][] batchTargets, const Loss l, double learningRate) @safe {
  enforce(batchInputs.length == batchTargets.length, "Batch inputs and targets must align");
  if (batchInputs.length == 0) {
    return 0.0;
  }

  double totalLoss = 0.0;

  foreach (i; 0 .. batchInputs.length) {
    auto output = net.forward(batchInputs[i]);
    auto lossResult = computeLoss(l, output, batchTargets[i]);
    totalLoss += lossResult.value;
    net.backward(lossResult.gradient, learningRate);
  }

  return totalLoss / batchInputs.length;
}
