/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.datascience.linalg;

import std.math;
import std.algorithm;
import std.array;
import uim.core;

/**
 * Linear algebra utilities
 */
class LinearAlgebra {

  /// Matrix-vector multiplication
  static double[] matmul(double[][] matrix, double[] vector) pure {
    assert(vector.length == matrix[0].length, "Dimension mismatch");
    
    double[] result = new double[matrix.length];
    foreach(i; 0 .. matrix.length) {
      result[i] = 0.0;
      foreach(j; 0 .. vector.length) {
        result[i] += matrix[i][j] * vector[j];
      }
    }
    return result;
  }

  /// Matrix-matrix multiplication
  static double[][] matmul(double[][] a, double[][] b) pure {
    assert(a[0].length == b.length, "Dimension mismatch");
    
    double[][] result = new double[][](a.length, b[0].length);
    foreach(i; 0 .. a.length) {
      foreach(j; 0 .. b[0].length) {
        result[i][j] = 0.0;
        foreach(k; 0 .. b.length) {
          result[i][j] += a[i][k] * b[k][j];
        }
      }
    }
    return result;
  }

  /// Matrix transpose
  static double[][] transpose(double[][] matrix) pure {
    if (matrix.length == 0) return [];
    
    double[][] result = new double[][](matrix[0].length, matrix.length);
    foreach(i; 0 .. matrix.length) {
      foreach(j; 0 .. matrix[i].length) {
        result[j][i] = matrix[i][j];
      }
    }
    return result;
  }

  /// Compute determinant (2x2, 3x3 cases, general via LU decomposition)
  static double determinant(double[][] matrix) pure {
    assert(matrix.length == matrix[0].length, "Matrix must be square");
    
    size_t n = matrix.length;
    if (n == 1) return matrix[0][0];
    if (n == 2) return matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0];
    
    // LU decomposition for general case
    auto lu = luDecomposition(matrix);
    double det = 1.0;
    foreach(i; 0 .. n) {
      det *= lu[i][i];
    }
    return det;
  }

  /// Compute matrix inverse
  static double[][] inverse(double[][] matrix) pure {
    assert(matrix.length == matrix[0].length, "Matrix must be square");
    
    size_t n = matrix.length;
    double[][] aug = new double[][](n, 2*n);
    
    // Create augmented matrix [A | I]
    foreach(i; 0 .. n) {
      foreach(j; 0 .. n) {
        aug[i][j] = matrix[i][j];
        aug[i][n + j] = (i == j) ? 1.0 : 0.0;
      }
    }
    
    // Gauss-Jordan elimination
    foreach(i; 0 .. n) {
      // Find pivot
      double max = abs(aug[i][i]);
      size_t maxrow = i;
      foreach(k; i+1 .. n) {
        if (abs(aug[k][i]) > max) {
          max = abs(aug[k][i]);
          maxrow = k;
        }
      }
      
      // Swap rows
      auto temp = aug[i];
      aug[i] = aug[maxrow];
      aug[maxrow] = temp;
      
      // Scale row
      double div = aug[i][i];
      foreach(j; 0 .. 2*n) {
        aug[i][j] /= div;
      }
      
      // Eliminate column
      foreach(k; 0 .. n) {
        if (k != i) {
          double mult = aug[k][i];
          foreach(j; 0 .. 2*n) {
            aug[k][j] -= mult * aug[i][j];
          }
        }
      }
    }
    
    // Extract inverse
    double[][] result = new double[][](n, n);
    foreach(i; 0 .. n) {
      foreach(j; 0 .. n) {
        result[i][j] = aug[i][n + j];
      }
    }
    
    return result;
  }

  /// LU decomposition
  static double[][] luDecomposition(double[][] matrix) pure {
    size_t n = matrix.length;
    double[][] lu = new double[][](n, n);
    
    foreach(i; 0 .. n) {
      foreach(j; 0 .. n) {
        lu[i][j] = matrix[i][j];
      }
    }
    
    foreach(k; 0 .. n) {
      foreach(i; k+1 .. n) {
        lu[i][k] /= lu[k][k];
        foreach(j; k+1 .. n) {
          lu[i][j] -= lu[i][k] * lu[k][j];
        }
      }
    }
    
    return lu;
  }

  /// Compute eigenvalues and eigenvectors (power iteration method)
  static struct EigenResult {
    double[] eigenvalues;
    double[][] eigenvectors;
  }

  static EigenResult eigen(double[][] matrix, size_t iterations = 100) pure {
    assert(matrix.length == matrix[0].length, "Matrix must be square");
    
    size_t n = matrix.length;
    double[][] eigenvecs = new double[][](n, n);
    double[] eigenvals = new double[n];
    
    // Power iteration for dominant eigenvalue
    foreach(idx; 0 .. n) {
      double[] v = new double[n];
      v[idx] = 1.0;
      
      foreach(_; 0 .. iterations) {
        double[] mv = matmul(matrix, v);
        double norm = 0.0;
        foreach(x; mv) norm += x * x;
        norm = sqrt(norm);
        
        foreach(i; 0 .. n) {
          v[i] = mv[i] / norm;
        }
      }
      
      double[] mv = matmul(matrix, v);
      double lambda = 0.0;
      foreach(i; 0 .. n) {
        lambda += v[i] * mv[i];
      }
      
      eigenvals[idx] = lambda;
      foreach(i; 0 .. n) {
        eigenvecs[i][idx] = v[i];
      }
    }
    
    return EigenResult(eigenvals, eigenvecs);
  }

  /// Gram-Schmidt orthogonalization
  static double[][] gramSchmidt(double[][] matrix) pure {
    size_t m = matrix.length;
    size_t n = matrix[0].length;
    
    double[][] result = new double[][](m, n);
    foreach(i; 0 .. m) {
      foreach(j; 0 .. n) {
        result[i][j] = matrix[i][j];
      }
    }
    
    foreach(j; 0 .. n) {
      // Orthogonalize against previous vectors
      foreach(k; 0 .. j) {
        double proj = 0.0;
        double norm_k = 0.0;
        foreach(i; 0 .. m) {
          proj += result[i][j] * result[i][k];
          norm_k += result[i][k] * result[i][k];
        }
        
        foreach(i; 0 .. m) {
          result[i][j] -= (proj / norm_k) * result[i][k];
        }
      }
      
      // Normalize
      double norm = 0.0;
      foreach(i; 0 .. m) {
        norm += result[i][j] * result[i][j];
      }
      norm = sqrt(norm);
      
      foreach(i; 0 .. m) {
        result[i][j] /= norm;
      }
    }
    
    return result;
  }

  /// Frobenius norm
  static double frobeniusNorm(double[][] matrix) pure {
    double sum = 0.0;
    foreach(row; matrix) {
      foreach(x; row) {
        sum += x * x;
      }
    }
    return sqrt(sum);
  }

  /// Vector norm (L2)
  static double norm(double[] vector) pure {
    double sum = 0.0;
    foreach(x; vector) {
      sum += x * x;
    }
    return sqrt(sum);
  }

  /// Dot product
  static double dot(double[] a, double[] b) pure {
    assert(a.length == b.length);
    double result = 0.0;
    foreach(i; 0 .. a.length) {
      result += a[i] * b[i];
    }
    return result;
  }
}
