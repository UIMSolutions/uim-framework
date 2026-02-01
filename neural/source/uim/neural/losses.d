/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.neural.losses;

import uim.neural;

@safe:

struct LossResult {
  double value;
  double[] gradient;
}

alias LossFn = LossResult function(const double[] prediction, const double[] target) @safe;

struct Loss {
  string name;
  LossFn evaluate;
}

struct loss {
  static immutable Loss mse = Loss("mse", &mseLoss);
  static immutable Loss crossEntropy = Loss("cross_entropy", &crossEntropyLoss);
}

LossResult computeLoss(const Loss l, const double[] prediction, const double[] target) @safe {
  enforce(prediction.length == target.length, "Prediction and target sizes must match");
  return l.evaluate(prediction, target);
}

private LossResult mseLoss(const double[] prediction, const double[] target) @safe {
  double value = 0.0;
  const size_t n = prediction.length ? prediction.length : 1;
  auto grad = new double[prediction.length];

  foreach (i; 0 .. prediction.length) {
    double diff = prediction[i] - target[i];
    value += diff * diff;
    grad[i] = (2.0 / n) * diff;
  }

  value /= n;
  return LossResult(value, grad);
}

private LossResult crossEntropyLoss(const double[] logitsOrProbabilities, const double[] target) @safe {
  enforce(logitsOrProbabilities.length == target.length, "Logits and targets must align");
  const double eps = 1e-9;

  // If the inputs are not normalized, interpret them as logits and normalize with softmax.
  auto probs = logitsOrProbabilities.dup;
  double sum = 0.0;
  foreach (p; probs) {
    sum += p;
  }
  if (sum < 0.99 || sum > 1.01) {
    probs = softmax(logitsOrProbabilities);
  }

  double value = 0.0;
  auto grad = new double[probs.length];
  const size_t n = probs.length ? probs.length : 1;

  foreach (i; 0 .. probs.length) {
    double p = probs[i];
    double t = target[i];
    double clamped = clampProbability(p, eps);
    value -= t * std.math.exponential.log(clamped);
    grad[i] = (p - t) / n; // gradient w.r.t logits when softmax is used
  }

  return LossResult(value, grad);
}

private double clampProbability(double v, double eps) @safe pure nothrow {
  if (v < eps) {
    return eps;
  }
  if (v > 1.0 - eps) {
    return 1.0 - eps;
  }
  return v;
}
