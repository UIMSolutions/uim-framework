/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.datascience.regression;

import std.math;
import std.algorithm;
import std.array;
import uim.core;
import uim.datascience.linalg;

/**
 * Linear Regression using least squares
 */
class LinearRegression {
  private {
    double[] coefficients;
    double intercept;
  }

  /// Fit linear regression model
  void fit(double[][] X, double[] y) {
    assert(X.length == y.length, "X and y must have same length");
    assert(X.length > 0 && X[0].length > 0, "Data must not be empty");
    
    size_t n_samples = X.length;
    size_t n_features = X[0].length;
    
    // Add intercept term (column of ones)
    double[][] X_with_intercept = new double[][](n_samples, n_features + 1);
    foreach(i; 0 .. n_samples) {
      X_with_intercept[i][0] = 1.0;
      foreach(j; 0 .. n_features) {
        X_with_intercept[i][j + 1] = X[i][j];
      }
    }
    
    // Compute (X^T X)^-1 X^T y
    auto X_T = LinearAlgebra.transpose(X_with_intercept);
    auto X_T_X = LinearAlgebra.matmul(X_T, X_with_intercept);
    auto X_T_X_inv = LinearAlgebra.inverse(X_T_X);
    auto X_T_y = new double[n_features + 1];
    
    foreach(i; 0 .. n_features + 1) {
      X_T_y[i] = 0.0;
      foreach(j; 0 .. n_samples) {
        X_T_y[i] += X_T[i][j] * y[j];
      }
    }
    
    auto beta = LinearAlgebra.matmul(X_T_X_inv, X_T_y);
    
    intercept = beta[0];
    coefficients = new double[n_features];
    foreach(i; 0 .. n_features) {
      coefficients[i] = beta[i + 1];
    }
  }

  /// Predict values
  double[] predict(double[][] X) const {
    assert(X.length > 0, "Data must not be empty");
    assert(X[0].length == coefficients.length, "Feature count mismatch");
    
    double[] predictions = new double[X.length];
    foreach(i; 0 .. X.length) {
      predictions[i] = intercept;
      foreach(j; 0 .. coefficients.length) {
        predictions[i] += X[i][j] * coefficients[j];
      }
    }
    return predictions;
  }

  /// Get coefficients
  @property double[] get_coefficients() const { return coefficients.dup; }
  @property double get_intercept() const { return intercept; }
}

/**
 * Logistic Regression for binary classification
 */
class LogisticRegression {
  private {
    double[] coefficients;
    double intercept;
  }

  /// Fit logistic regression model using gradient descent
  void fit(double[][] X, double[] y, double learning_rate = 0.01, size_t iterations = 1000) {
    assert(X.length == y.length, "X and y must have same length");
    assert(X.length > 0 && X[0].length > 0, "Data must not be empty");
    
    size_t n_samples = X.length;
    size_t n_features = X[0].length;
    
    // Initialize coefficients
    intercept = 0.0;
    coefficients = new double[n_features];
    
    // Gradient descent
    foreach(iter; 0 .. iterations) {
      double intercept_grad = 0.0;
      double[] coef_grad = new double[n_features];
      
      foreach(i; 0 .. n_samples) {
        double z = intercept;
        foreach(j; 0 .. n_features) {
          z += X[i][j] * coefficients[j];
        }
        double pred = sigmoid(z);
        double error = pred - y[i];
        
        intercept_grad += error;
        foreach(j; 0 .. n_features) {
          coef_grad[j] += error * X[i][j];
        }
      }
      
      intercept -= learning_rate * intercept_grad / n_samples;
      foreach(j; 0 .. n_features) {
        coefficients[j] -= learning_rate * coef_grad[j] / n_samples;
      }
    }
  }

  /// Predict probabilities
  double[] predictProba(double[][] X) const {
    assert(X.length > 0, "Data must not be empty");
    assert(X[0].length == coefficients.length, "Feature count mismatch");
    
    double[] predictions = new double[X.length];
    foreach(i; 0 .. X.length) {
      double z = intercept;
      foreach(j; 0 .. coefficients.length) {
        z += X[i][j] * coefficients[j];
      }
      predictions[i] = sigmoid(z);
    }
    return predictions;
  }

  /// Predict class labels (threshold at 0.5)
  size_t[] predict(double[][] X) const {
    auto proba = predictProba(X);
    size_t[] predictions = new size_t[proba.length];
    foreach(i; 0 .. proba.length) {
      predictions[i] = proba[i] >= 0.5 ? 1 : 0;
    }
    return predictions;
  }

  private static double sigmoid(double x) pure {
    return 1.0 / (1.0 + exp(-x));
  }
}

/**
 * Polynomial Regression
 */
class PolynomialRegression {
  private {
    LinearRegression lr;
    uint degree;
  }

  /// Create polynomial regression model
  this(uint poly_degree) {
    assert(poly_degree > 0, "Degree must be positive");
    degree = poly_degree;
    lr = new LinearRegression();
  }

  /// Fit polynomial regression
  void fit(double[][] X, double[] y) {
    // Generate polynomial features
    auto X_poly = generatePolyFeatures(X);
    lr.fit(X_poly, y);
  }

  /// Predict with polynomial features
  double[] predict(double[][] X) const {
    auto X_poly = generatePolyFeatures(X);
    return lr.predict(X_poly);
  }

  private double[][] generatePolyFeatures(double[][] X) const {
    size_t n_samples = X.length;
    size_t n_features = X[0].length;
    size_t n_poly = 0;
    
    foreach(d; 1 .. degree + 1) {
      n_poly += n_features;
    }
    
    double[][] X_poly = new double[][](n_samples, n_poly);
    
    foreach(i; 0 .. n_samples) {
      size_t col = 0;
      foreach(d; 1 .. degree + 1) {
        foreach(j; 0 .. n_features) {
          X_poly[i][col++] = pow(X[i][j], d);
        }
      }
    }
    
    return X_poly;
  }
}

/**
 * Ridge Regression (L2 regularization)
 */
class RidgeRegression {
  private {
    double[] coefficients;
    double intercept;
    double alpha; // Regularization strength
  }

  /// Create ridge regression model
  this(double regularization_strength = 1.0) {
    assert(regularization_strength >= 0.0, "Alpha must be non-negative");
    alpha = regularization_strength;
  }

  /// Fit ridge regression model
  void fit(double[][] X, double[] y) {
    assert(X.length == y.length, "X and y must have same length");
    assert(X.length > 0 && X[0].length > 0, "Data must not be empty");
    
    size_t n_samples = X.length;
    size_t n_features = X[0].length;
    
    // Add intercept term
    double[][] X_with_intercept = new double[][](n_samples, n_features + 1);
    foreach(i; 0 .. n_samples) {
      X_with_intercept[i][0] = 1.0;
      foreach(j; 0 .. n_features) {
        X_with_intercept[i][j + 1] = X[i][j];
      }
    }
    
    auto X_T = LinearAlgebra.transpose(X_with_intercept);
    auto X_T_X = LinearAlgebra.matmul(X_T, X_with_intercept);
    
    // Add regularization term to diagonal
    foreach(i; 1 .. n_features + 1) {
      X_T_X[i][i] += alpha;
    }
    
    auto X_T_X_inv = LinearAlgebra.inverse(X_T_X);
    auto X_T_y = new double[n_features + 1];
    
    foreach(i; 0 .. n_features + 1) {
      X_T_y[i] = 0.0;
      foreach(j; 0 .. n_samples) {
        X_T_y[i] += X_T[i][j] * y[j];
      }
    }
    
    auto beta = LinearAlgebra.matmul(X_T_X_inv, X_T_y);
    
    intercept = beta[0];
    coefficients = new double[n_features];
    foreach(i; 0 .. n_features) {
      coefficients[i] = beta[i + 1];
    }
  }

  /// Predict values
  double[] predict(double[][] X) const {
    assert(X.length > 0, "Data must not be empty");
    assert(X[0].length == coefficients.length, "Feature count mismatch");
    
    double[] predictions = new double[X.length];
    foreach(i; 0 .. X.length) {
      predictions[i] = intercept;
      foreach(j; 0 .. coefficients.length) {
        predictions[i] += X[i][j] * coefficients[j];
      }
    }
    return predictions;
  }
}
