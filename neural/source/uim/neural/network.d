/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.neural.network;

import uim.neural;
import std.random : Random, unpredictableSeed;

@safe:

/// Simple sequential neural network composed of dense layers.
class NeuralNetwork : UIMObject {
  this() {
    rng = Random(unpredictableSeed);
  }

  NeuralNetwork addDenseLayer(size_t inputSize, size_t outputSize, Activation act, double initScale = 0.05) {
    auto layer = new DenseLayer(inputSize, outputSize, act, initScale, rng);
    layers ~= layer;
    return this;
  }

  NeuralNetwork addDenseLayer(size_t outputSize, Activation act, double initScale = 0.05) {
    enforce(layers.length > 0, "First layer requires explicit input size");
    auto inputSize = layers[$ - 1].outputSize;
    return addDenseLayer(inputSize, outputSize, act, initScale);
  }

  double[] forward(const double[] input) @safe {
    enforce(layers.length > 0, "Network has no layers");
    auto x = input.dup;
    foreach (layer; layers) {
      x = layer.forward(x);
    }
    return x;
  }

  double[] predict(const double[] input) const @safe {
    enforce(layers.length > 0, "Network has no layers");
    auto x = input.dup;
    foreach (layer; layers) {
      x = layer.infer(x);
    }
    return x;
  }

  double[] backward(const double[] gradOutput, double learningRate) @safe {
    auto grad = gradOutput.dup;
    foreach_reverse (layer; layers) {
      grad = layer.backward(grad, learningRate);
    }
    return grad;
  }

  size_t inputSize() const @safe {
    return layers.length ? layers[0].inputSize : 0;
  }

  size_t outputSize() const @safe {
    return layers.length ? layers[$ - 1].outputSize : 0;
  }

  DenseLayer[] layers;
  std.random.Random rng;
}
