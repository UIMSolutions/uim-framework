/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.datascience.preprocessing;

import std.math;
import std.algorithm;
import std.array;
import uim.core;

/**
 * Data preprocessing and normalization utilities
 */
class Preprocessing {

  /// Standard scaling (z-score normalization)
  static double[][] standardScale(double[][] data) pure {
    if (data.length == 0) return [];
    
    size_t n_features = data[0].length;
    double[][] scaled = new double[][](data.length, n_features);
    
    foreach(j; 0 .. n_features) {
      double mean = 0.0;
      foreach(i; 0 .. data.length) {
        mean += data[i][j];
      }
      mean /= data.length;
      
      double var = 0.0;
      foreach(i; 0 .. data.length) {
        double diff = data[i][j] - mean;
        var += diff * diff;
      }
      var /= data.length;
      double std = sqrt(var);
      
      foreach(i; 0 .. data.length) {
        scaled[i][j] = (data[i][j] - mean) / std;
      }
    }
    
    return scaled;
  }

  /// Min-Max scaling to [0, 1]
  static double[][] minMaxScale(double[][] data) pure {
    if (data.length == 0) return [];
    
    size_t n_features = data[0].length;
    double[][] scaled = new double[][](data.length, n_features);
    
    foreach(j; 0 .. n_features) {
      double min = data[0][j];
      double max = data[0][j];
      
      foreach(i; 1 .. data.length) {
        if (data[i][j] < min) min = data[i][j];
        if (data[i][j] > max) max = data[i][j];
      }
      
      double range = max - min;
      if (range == 0.0) range = 1.0;
      
      foreach(i; 0 .. data.length) {
        scaled[i][j] = (data[i][j] - min) / range;
      }
    }
    
    return scaled;
  }

  /// Handle missing values (NaN) by mean imputation
  static double[][] imputeMean(double[][] data) pure {
    if (data.length == 0) return [];
    
    size_t n_features = data[0].length;
    double[][] result = new double[][](data.length, n_features);
    
    foreach(j; 0 .. n_features) {
      double sum = 0.0;
      size_t count = 0;
      
      foreach(i; 0 .. data.length) {
        if (!isNaN(data[i][j])) {
          sum += data[i][j];
          count++;
        }
      }
      
      double mean = (count > 0) ? sum / count : 0.0;
      
      foreach(i; 0 .. data.length) {
        result[i][j] = isNaN(data[i][j]) ? mean : data[i][j];
      }
    }
    
    return result;
  }

  /// Remove rows with missing values
  static double[][] dropNaN(double[][] data) pure {
    double[][] result;
    
    foreach(row; data) {
      bool hasMissing = false;
      foreach(val; row) {
        if (isNaN(val)) {
          hasMissing = true;
          break;
        }
      }
      if (!hasMissing) {
        result ~= row;
      }
    }
    
    return result;
  }

  /// One-hot encoding for categorical features (assumes integer encoding)
  static double[][] oneHotEncode(double[] feature) pure {
    if (feature.length == 0) return [];
    
    // Find unique values
    double[] unique;
    foreach(val; feature) {
      if (!unique.canFind(val)) {
        unique ~= val;
      }
    }
    
    double[][] encoded = new double[][](feature.length, unique.length);
    
    foreach(i, val; feature) {
      foreach(j, u; unique) {
        encoded[i][j] = (val == u) ? 1.0 : 0.0;
      }
    }
    
    return encoded;
  }

  /// Polynomial feature generation
  static double[][] polynomialFeatures(double[][] data, uint degree) pure {
    if (data.length == 0 || degree < 1) return data;
    if (degree == 1) return data;
    
    size_t n_samples = data.length;
    size_t n_features = data[0].length;
    
    // Calculate number of polynomial features
    size_t n_output = n_features;
    foreach(d; 2 .. degree + 1) {
      n_output += n_features;
    }
    
    double[][] result = new double[][](n_samples, n_output);
    
    foreach(i; 0 .. n_samples) {
      size_t col = 0;
      
      // Original features
      foreach(j; 0 .. n_features) {
        result[i][col++] = data[i][j];
      }
      
      // Higher order terms
      foreach(d; 2 .. degree + 1) {
        foreach(j; 0 .. n_features) {
          result[i][col++] = pow(data[i][j], d);
        }
      }
    }
    
    return result;
  }

  /// Principal Component Analysis (simple version)
  static struct PCAResult {
    double[][] transformed;
    double[][] components;
    double[] explained_variance;
  }

  static PCAResult pca(double[][] data, size_t n_components) pure {
    // Standardize data
    auto scaled = standardScale(data);
    
    size_t n_samples = scaled.length;
    size_t n_features = scaled[0].length;
    
    // Compute covariance matrix
    double[][] cov = new double[][](n_features, n_features);
    foreach(i; 0 .. n_features) {
      foreach(j; 0 .. n_features) {
        double sum = 0.0;
        foreach(k; 0 .. n_samples) {
          sum += scaled[k][i] * scaled[k][j];
        }
        cov[i][j] = sum / (n_samples - 1);
      }
    }
    
    // TODO: Compute eigenvalues and eigenvectors
    // For now, return approximate result
    double[][] components = new double[][](n_components, n_features);
    double[] explained_var = new double[n_components];
    
    // Placeholder implementation
    foreach(i; 0 .. n_components) {
      components[i][i % n_features] = 1.0;
      explained_var[i] = 1.0 / (i + 1);
    }
    
    // Transform data
    double[][] transformed = new double[][](n_samples, n_components);
    foreach(i; 0 .. n_samples) {
      foreach(j; 0 .. n_components) {
        double sum = 0.0;
        foreach(k; 0 .. n_features) {
          sum += scaled[i][k] * components[j][k];
        }
        transformed[i][j] = sum;
      }
    }
    
    return PCAResult(transformed, components, explained_var);
  }

  /// Train-test split
  static struct TrainTestSplit {
    double[][] X_train;
    double[][] X_test;
    double[] y_train;
    double[] y_test;
  }

  static TrainTestSplit trainTestSplit(double[][] X, double[] y, double test_size = 0.2) pure {
    assert(X.length == y.length, "X and y must have same length");
    
    size_t n = X.length;
    size_t n_test = cast(size_t)(n * test_size);
    size_t n_train = n - n_test;
    
    double[][] X_train = new double[][](n_train, X[0].length);
    double[][] X_test = new double[][](n_test, X[0].length);
    double[] y_train = new double[n_train];
    double[] y_test = new double[n_test];
    
    foreach(i; 0 .. n_train) {
      X_train[i] = X[i].dup;
      y_train[i] = y[i];
    }
    
    foreach(i; 0 .. n_test) {
      X_test[i] = X[n_train + i].dup;
      y_test[i] = y[n_train + i];
    }
    
    return TrainTestSplit(X_train, X_test, y_train, y_test);
  }
}
