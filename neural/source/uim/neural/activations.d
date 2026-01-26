/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.neural.activations;

import std.math : exp, tanh;

@safe:

alias ActivationFn = double function(double) @safe pure nothrow;

struct Activation {
  string name;
  ActivationFn applyElement;
  ActivationFn derivativeFromOutput;
  bool vectorBased;
  bool applyChainRule;
}

struct activation {
  static immutable Activation relu = Activation(
    "relu",
    &reluFn,
    &reluDerivative,
    false,
    true
  );

  static immutable Activation sigmoid = Activation(
    "sigmoid",
    &sigmoidFn,
    &sigmoidDerivative,
    false,
    true
  );

  static immutable Activation tanh = Activation(
    "tanh",
    &tanhFn,
    &tanhDerivative,
    false,
    true
  );

  static immutable Activation linear = Activation(
    "linear",
    &linearFn,
    &linearDerivative,
    false,
    true
  );

  // Softmax is vector based; gradient is typically provided by the loss (cross entropy), so we skip chaining.
  static immutable Activation softmaxOutput = Activation(
    "softmax",
    &linearFn,
    &linearDerivative,
    true,
    false
  );
}

/// Applies the activation element-wise or vector-wise (softmax).
double[] applyActivation(const Activation act, const double[] values) @safe {
  if (values.length == 0) {
    return [];
  }

  if (act.vectorBased) {
    return softmax(values);
  }

  auto result = new double[values.length];
  foreach (i, v; values) {
    result[i] = act.applyElement ? act.applyElement(v) : v;
  }
  return result;
}

/// Computes activation derivatives from activation outputs for chain rule.
double[] activationDerivative(const Activation act, const double[] outputs) @safe {
  auto grad = new double[outputs.length];

  if (!act.applyChainRule) {
    foreach (i, _; outputs) {
      grad[i] = 1.0;
    }
    return grad;
  }

  foreach (i, outVal; outputs) {
    grad[i] = act.derivativeFromOutput ? act.derivativeFromOutput(outVal) : 1.0;
  }
  return grad;
}

/// Numerically stable softmax.
double[] softmax(const double[] logits) @safe {
  if (logits.length == 0) {
    return [];
  }

  double maxLogit = logits[0];
  foreach (val; logits[1 .. $]) {
    if (val > maxLogit) {
      maxLogit = val;
    }
  }

  double sumExp = 0.0;
  auto out = new double[logits.length];
  foreach (i, val; logits) {
    double e = exp(val - maxLogit);
    out[i] = e;
    sumExp += e;
  }

  if (sumExp == 0) {
    return out;
  }

  foreach (ref v; out) {
    v /= sumExp;
  }
  return out;
}

// Activation primitives
private double reluFn(double x) @safe pure nothrow {
  return x > 0 ? x : 0;
}

private double reluDerivative(double y) @safe pure nothrow {
  return y > 0 ? 1.0 : 0.0;
}

private double sigmoidFn(double x) @safe pure nothrow {
  return 1.0 / (1.0 + exp(-x));
}

private double sigmoidDerivative(double y) @safe pure nothrow {
  return y * (1.0 - y);
}

private double tanhFn(double x) @safe pure nothrow {
  return tanh(x);
}

private double tanhDerivative(double y) @safe pure nothrow {
  return 1.0 - (y * y);
}

private double linearFn(double x) @safe pure nothrow {
  return x;
}

private double linearDerivative(double) @safe pure nothrow {
  return 1.0;
}
