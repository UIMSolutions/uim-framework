/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.numerical.matrix;

import std.math;
import std.algorithm;
import std.conv;
import uim.numerical.vector;

@safe:

/**
 * A mathematical matrix with numerical operations
 */
struct Matrix {
    double[][] data;
    size_t rows;
    size_t cols;
    
    /**
     * Creates a matrix from a 2D array
     */
    this(double[][] values) pure {
        assert(values.length > 0, "Matrix must have at least one row");
        assert(values[0].length > 0, "Matrix must have at least one column");
        
        rows = values.length;
        cols = values[0].length;
        data = new double[][](rows, cols);
        
        foreach (i; 0 .. rows) {
            assert(values[i].length == cols, "All rows must have same length");
            data[i][] = values[i][];
        }
    }
    
    /**
     * Creates a zero matrix
     */
    this(size_t rows, size_t cols) pure nothrow {
        this.rows = rows;
        this.cols = cols;
        data = new double[][](rows, cols);
    }
    
    /**
     * Index access
     */
    double opIndex(size_t i, size_t j) const pure nothrow {
        return data[i][j];
    }
    
    /// ditto
    ref double opIndex(size_t i, size_t j) pure nothrow return {
        return data[i][j];
    }
    
    /**
     * Matrix addition
     */
    Matrix opBinary(string op)(const Matrix rhs) const pure if (op == "+") {
        assert(rows == rhs.rows && cols == rhs.cols, "Matrix dimensions must match");
        auto result = Matrix(rows, cols);
        foreach (i; 0 .. rows) {
            foreach (j; 0 .. cols) {
                result.data[i][j] = data[i][j] + rhs.data[i][j];
            }
        }
        return result;
    }
    
    /**
     * Matrix subtraction
     */
    Matrix opBinary(string op)(const Matrix rhs) const pure if (op == "-") {
        assert(rows == rhs.rows && cols == rhs.cols, "Matrix dimensions must match");
        auto result = Matrix(rows, cols);
        foreach (i; 0 .. rows) {
            foreach (j; 0 .. cols) {
                result.data[i][j] = data[i][j] - rhs.data[i][j];
            }
        }
        return result;
    }
    
    /**
     * Matrix multiplication
     */
    Matrix opBinary(string op)(const Matrix rhs) const pure if (op == "*") {
        assert(cols == rhs.rows, "Inner dimensions must match for multiplication");
        auto result = Matrix(rows, rhs.cols);
        foreach (i; 0 .. rows) {
            foreach (j; 0 .. rhs.cols) {
                double sum = 0;
                foreach (k; 0 .. cols) {
                    sum += data[i][k] * rhs.data[k][j];
                }
                result.data[i][j] = sum;
            }
        }
        return result;
    }
    
    /**
     * Scalar multiplication
     */
    Matrix opBinary(string op)(double scalar) const pure if (op == "*") {
        auto result = Matrix(rows, cols);
        foreach (i; 0 .. rows) {
            foreach (j; 0 .. cols) {
                result.data[i][j] = data[i][j] * scalar;
            }
        }
        return result;
    }
    
    /**
     * Matrix-vector multiplication
     */
    Vector opBinary(string op)(const Vector v) const pure if (op == "*") {
        assert(cols == v.length, "Matrix columns must match vector length");
        auto result = Vector(rows);
        foreach (i; 0 .. rows) {
            double sum = 0;
            foreach (j; 0 .. cols) {
                sum += data[i][j] * v.data[j];
            }
            result.data[i] = sum;
        }
        return result;
    }
    
    /**
     * Transpose
     */
    Matrix transpose() const pure {
        auto result = Matrix(cols, rows);
        foreach (i; 0 .. rows) {
            foreach (j; 0 .. cols) {
                result.data[j][i] = data[i][j];
            }
        }
        return result;
    }
    
    /**
     * Determinant (for square matrices)
     */
    double determinant() const pure {
        assert(rows == cols, "Determinant only defined for square matrices");
        
        if (rows == 1) {
            return data[0][0];
        }
        
        if (rows == 2) {
            return data[0][0] * data[1][1] - data[0][1] * data[1][0];
        }
        
        // LU decomposition for larger matrices
        auto lu = this.luDecomposition();
        double det = 1.0;
        foreach (i; 0 .. rows) {
            det *= lu.data[i][i];
        }
        return det;
    }
    
    /**
     * LU Decomposition (returns L+U in single matrix, L has implicit 1s on diagonal)
     */
    Matrix luDecomposition() const pure {
        assert(rows == cols, "LU decomposition only for square matrices");
        auto result = Matrix(rows, cols);
        
        // Copy data
        foreach (i; 0 .. rows) {
            result.data[i][] = data[i][];
        }
        
        foreach (k; 0 .. rows - 1) {
            foreach (i; k + 1 .. rows) {
                result.data[i][k] /= result.data[k][k];
                foreach (j; k + 1 .. rows) {
                    result.data[i][j] -= result.data[i][k] * result.data[k][j];
                }
            }
        }
        return result;
    }
    
    /**
     * Trace (sum of diagonal elements)
     */
    double trace() const pure nothrow {
        assert(rows == cols, "Trace only defined for square matrices");
        double result = 0;
        foreach (i; 0 .. rows) {
            result += data[i][i];
        }
        return result;
    }
    
    /**
     * Frobenius norm
     */
    double norm() const pure nothrow {
        double sum = 0;
        foreach (i; 0 .. rows) {
            foreach (j; 0 .. cols) {
                sum += data[i][j] * data[i][j];
            }
        }
        return sqrt(sum);
    }
    
    /**
     * Gets a row as a vector
     */
    Vector row(size_t i) const pure {
        return Vector(data[i].dup);
    }
    
    /**
     * Gets a column as a vector
     */
    Vector col(size_t j) const pure {
        auto result = Vector(rows);
        foreach (i; 0 .. rows) {
            result.data[i] = data[i][j];
        }
        return result;
    }
    
    /**
     * String representation
     */
    string toString() const {
        import std.format : format;
        import std.array : join;
        string[] lines;
        foreach (row; data) {
            lines ~= format("%s", row);
        }
        return format("[%s]", lines.join(",\n "));
    }
}

/**
 * Creates a zero matrix
 */
Matrix zeros(size_t rows, size_t cols) pure {
    return Matrix(rows, cols);
}

/**
 * Creates an identity matrix
 */
Matrix eye(size_t n) pure {
    auto result = Matrix(n, n);
    foreach (i; 0 .. n) {
        result.data[i][i] = 1.0;
    }
    return result;
}

/**
 * Creates a diagonal matrix from a vector
 */
Matrix diag(const Vector v) pure {
    auto result = Matrix(v.length, v.length);
    foreach (i; 0 .. v.length) {
        result.data[i][i] = v.data[i];
    }
    return result;
}
