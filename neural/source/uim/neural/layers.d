/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.neural.layers;

import std.exception : enforce;
import std.random : Random, uniform, unpredictableSeed;

import uim.neural.activations;

@safe:

/// A fully-connected layer with optional activation.
class DenseLayer {
public:
  this(size_t inputSize, size_t outputSize, Activation activation, double initScale = 0.05) {
    auto rng = Random(unpredictableSeed);
    this(inputSize, outputSize, activation, initScale, rng);
  }

  this(size_t inputSize, size_t outputSize, Activation activation, double initScale, ref Random rng) {
    enforce(inputSize > 0 && outputSize > 0, "Layer dimensions must be positive");
    this.inputSize = inputSize;
    this.outputSize = outputSize;
    this.activation = activation;

    weights.length = outputSize;
    bias.length = outputSize;

    foreach (o; 0 .. outputSize) {
      weights[o].length = inputSize;
      foreach (i; 0 .. inputSize) {
        weights[o][i] = uniform!double(-initScale, initScale, rng);
      }
      bias[o] = uniform!double(-initScale, initScale, rng);
    }
  }

  double[] forward(const double[] input) @safe {
    enforce(input.length == inputSize, "Input size does not match layer expectation");
    lastInput = input.dup;

    auto z = computeLinear(input);
    lastOutput = applyActivation(activation, z);
    return lastOutput;
  }

  double[] infer(const double[] input) const @safe {
    enforce(input.length == inputSize, "Input size does not match layer expectation");
    auto z = computeLinear(input);
    return applyActivation(activation, z);
  }

  double[] backward(const double[] gradOutput, double learningRate) @safe {
    enforce(gradOutput.length == outputSize, "Gradient size does not match layer output");
    enforce(lastInput.length == inputSize, "Layer must run forward before backward");

    auto gradInput = new double[inputSize];

    double[] delta;
    if (activation.applyChainRule) {
      auto actGrad = activationDerivative(activation, lastOutput);
      delta = new double[outputSize];
      foreach (i; 0 .. outputSize) {
        delta[i] = gradOutput[i] * actGrad[i];
      }
    } else {
      delta = gradOutput.dup;
    }

    foreach (o; 0 .. outputSize) {
      foreach (i; 0 .. inputSize) {
        gradInput[i] += delta[o] * weights[o][i];
        weights[o][i] -= learningRate * delta[o] * lastInput[i];
      }
      bias[o] -= learningRate * delta[o];
    }

    return gradInput;
  }

  size_t inputSize;
  size_t outputSize;
  Activation activation;
  double[][] weights;
  double[] bias;

private:
  double[] computeLinear(const double[] input) const @safe {
    auto z = new double[outputSize];
    foreach (o; 0 .. outputSize) {
      double sum = bias[o];
      foreach (i; 0 .. inputSize) {
        sum += weights[o][i] * input[i];
      }
      z[o] = sum;
    }
    return z;
  }

  double[] lastInput;
  double[] lastOutput;
}
