/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.datascience.distributions;

import std.math;
import std.algorithm;
import uim.core;

/**
 * Probability distribution functions
 */

/// Gamma function using Stirling's approximation
private double gamma(double x) pure {
  if (x < 0.5) {
    return PI / (sin(PI * x) * gamma(1.0 - x));
  }
  
  x -= 1.0;
  double a = 1.0;
  double t = x + 7.0;
  t = (2.506628277459 * sqrt(t) * pow(t, x + 0.5) * exp(-t)) / a;
  return t;
}

/// Beta function
private double beta(double a, double b) pure {
  return exp(lgamma(a) + lgamma(b) - lgamma(a + b));
}

/// Log-gamma function (better numerical stability)
private double lgamma(double x) pure {
  if (x <= 0.0) return double.nan;
  
  const double g = 7.0;
  const double[] coef = [
    0.99999999999980993,
    676.5203681218851,
    -1259.1392167224028,
    771.32342877765313,
    -176.61502916214059,
    12.507343278686905,
    -0.13857109526572012,
    9.9843695780195716e-6,
    1.5056327351493116e-7
  ];

  x -= 1.0;
  double z = coef[0];
  foreach(i; 1 .. coef.length) {
    z += coef[i] / (x + i);
  }

  double t = x + g + 0.5;
  return 0.5 * log(2 * PI) + (x + 0.5) * log(t) - t + log(z);
}

/**
 * Normal (Gaussian) distribution
 */
class NormalDistribution {
  
  private double mean;
  private double stddev;

  this(double m = 0.0, double sd = 1.0) pure {
    assert(sd > 0.0, "Standard deviation must be positive");
    mean = m;
    stddev = sd;
  }

  /// Probability density function
  double pdf(double x) const pure {
    double z = (x - mean) / stddev;
    return (1.0 / (stddev * sqrt(2 * PI))) * exp(-(z * z) / 2.0);
  }

  /// Cumulative distribution function (approximation)
  double cdf(double x) const pure {
    double z = (x - mean) / stddev;
    return 0.5 * (1.0 + erf(z / sqrt(2.0)));
  }

  /// Quantile function
  double quantile(double p) const pure {
    assert(p > 0.0 && p < 1.0, "p must be between 0 and 1");
    // Approximation using the rational approximation method
    if (p < 0.5) {
      double t = sqrt(-2.0 * log(p));
      return mean + stddev * (t - (2.515517 + 0.802853*t + 0.010328*t*t) / 
             (1.0 + 1.432788*t + 0.189269*t*t + 0.001308*t*t*t));
    } else {
      return mean - stddev * quantile(1.0 - p);
    }
  }

  /// Generate random samples
  double[] sample(size_t n) const {
    double[] samples = new double[n];
    foreach(i; 0 .. n) {
      // Box-Muller transform
      double u1 = uniform(0.0, 1.0);
      double u2 = uniform(0.0, 1.0);
      double z0 = sqrt(-2.0 * log(u1)) * cos(2 * PI * u2);
      samples[i] = mean + stddev * z0;
    }
    return samples;
  }
}

/**
 * Uniform distribution
 */
class UniformDistribution {
  
  private double a;
  private double b;

  this(double min_val = 0.0, double max_val = 1.0) pure {
    assert(min_val < max_val, "min must be less than max");
    a = min_val;
    b = max_val;
  }

  /// Probability density function
  double pdf(double x) const pure {
    if (x < a || x > b) return 0.0;
    return 1.0 / (b - a);
  }

  /// Cumulative distribution function
  double cdf(double x) const pure {
    if (x < a) return 0.0;
    if (x > b) return 1.0;
    return (x - a) / (b - a);
  }

  /// Quantile function
  double quantile(double p) const pure {
    assert(p >= 0.0 && p <= 1.0, "p must be between 0 and 1");
    return a + p * (b - a);
  }
}

/**
 * Exponential distribution
 */
class ExponentialDistribution {
  
  private double lambda;

  this(double rate = 1.0) pure {
    assert(rate > 0.0, "Rate must be positive");
    lambda = rate;
  }

  /// Probability density function
  double pdf(double x) const pure {
    if (x < 0.0) return 0.0;
    return lambda * exp(-lambda * x);
  }

  /// Cumulative distribution function
  double cdf(double x) const pure {
    if (x < 0.0) return 0.0;
    return 1.0 - exp(-lambda * x);
  }

  /// Quantile function
  double quantile(double p) const pure {
    assert(p >= 0.0 && p <= 1.0, "p must be between 0 and 1");
    return -log(1.0 - p) / lambda;
  }
}

/**
 * Beta distribution
 */
class BetaDistribution {
  
  private double alpha;
  private double beta_param;

  this(double a, double b) pure {
    assert(a > 0.0 && b > 0.0, "Parameters must be positive");
    alpha = a;
    beta_param = b;
  }

  /// Probability density function
  double pdf(double x) const pure {
    if (x <= 0.0 || x >= 1.0) return 0.0;
    return pow(x, alpha - 1.0) * pow(1.0 - x, beta_param - 1.0) / beta(alpha, beta_param);
  }

  /// Cumulative distribution function (incomplete beta function)
  double cdf(double x) const pure {
    if (x <= 0.0) return 0.0;
    if (x >= 1.0) return 1.0;
    // Simplified approximation
    return incompleteBeta(x, alpha, beta_param);
  }

  /// Quantile function (approximation)
  double quantile(double p) const pure {
    assert(p >= 0.0 && p <= 1.0, "p must be between 0 and 1");
    if (p == 0.0) return 0.0;
    if (p == 1.0) return 1.0;
    return 0.5; // TODO: Implement proper quantile
  }
}

/**
 * Chi-squared distribution
 */
class ChiSquaredDistribution {
  
  private uint df;

  this(uint degrees_of_freedom) pure {
    assert(degrees_of_freedom > 0, "Degrees of freedom must be positive");
    df = degrees_of_freedom;
  }

  /// Probability density function
  double pdf(double x) const pure {
    if (x <= 0.0) return 0.0;
    double k = df / 2.0;
    return pow(x, k - 1.0) * exp(-x / 2.0) / (pow(2.0, k) * exp(lgamma(k)));
  }

  /// Cumulative distribution function (approximation)
  double cdf(double x) const pure {
    if (x <= 0.0) return 0.0;
    return incompleteBeta(x / (x + 2.0), df / 2.0, 1.0);
  }
}

/// Incomplete beta function (regularized)
private double incompleteBeta(double x, double a, double b) pure {
  if (x == 0.0) return 0.0;
  if (x == 1.0) return 1.0;

  // Continued fraction approximation
  double front = exp(a * log(x) + b * log(1.0 - x) - lgamma(a + b) + lgamma(a) + lgamma(b));
  
  if (x < (a + 1.0) / (a + b + 2.0)) {
    return front * continuedFraction(x, a, b) / a;
  } else {
    return 1.0 - front * continuedFraction(1.0 - x, b, a) / b;
  }
}

/// Helper for continued fraction approximation
private double continuedFraction(double x, double a, double b) pure {
  const int max_iter = 500;
  const double epsilon = 1e-10;

  double am = 1.0;
  double bm = 1.0;
  double az = 1.0;
  double qab = a + b;
  double qap = a + 1.0;
  double qam = a - 1.0;
  double bz = 1.0 - qab * x / qap;

  for (int m = 1; m <= max_iter; m++) {
    double em = m;
    double tem = 2.0 * em;
    double d = em * (b - em) * x / ((qam + tem) * (a + tem));
    double ap = az + d * am;
    double bp = bz + d * bm;
    d = -(a + em) * (qab + em) * x / ((qap + tem) * (a + tem));
    az = ap / bp;
    bz = 1.0;
    am = ap / bp;
    bm = d;
    if (abs(az - bz) < epsilon) {
      return az;
    }
  }

  return az;
}

/// Helper for uniform random number generation
private double uniform(double a, double b) @trusted {
  import std.random;
  return a + (b - a) * uniform01!(double)();
}
