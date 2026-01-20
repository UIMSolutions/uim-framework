/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.numerical.solvers;

import std.math;
import std.algorithm;
import uim.numerical.vector;
import uim.numerical.matrix;

@safe:

/**
 * Solves a linear system Ax = b using Gaussian elimination with partial pivoting
 */
Vector solveLinearSystem(Matrix A, Vector b) pure {
    assert(A.rows == A.cols, "Matrix must be square");
    assert(A.rows == b.length, "Dimensions must match");
    
    size_t n = A.rows;
    auto augmented = Matrix(n, n + 1);
    
    // Create augmented matrix [A|b]
    foreach (i; 0 .. n) {
        foreach (j; 0 .. n) {
            augmented.data[i][j] = A.data[i][j];
        }
        augmented.data[i][n] = b.data[i];
    }
    
    // Forward elimination with partial pivoting
    foreach (k; 0 .. n) {
        // Find pivot
        size_t maxRow = k;
        double maxVal = abs(augmented.data[k][k]);
        foreach (i; k + 1 .. n) {
            double val = abs(augmented.data[i][k]);
            if (val > maxVal) {
                maxVal = val;
                maxRow = i;
            }
        }
        
        // Swap rows
        if (maxRow != k) {
            auto temp = augmented.data[k];
            augmented.data[k] = augmented.data[maxRow];
            augmented.data[maxRow] = temp;
        }
        
        // Eliminate column
        foreach (i; k + 1 .. n) {
            double factor = augmented.data[i][k] / augmented.data[k][k];
            foreach (j; k .. n + 1) {
                augmented.data[i][j] -= factor * augmented.data[k][j];
            }
        }
    }
    
    // Back substitution
    auto x = Vector(n);
    for (ptrdiff_t i = n - 1; i >= 0; i--) {
        double sum = 0;
        foreach (j; i + 1 .. n) {
            sum += augmented.data[i][j] * x.data[j];
        }
        x.data[i] = (augmented.data[i][n] - sum) / augmented.data[i][i];
    }
    
    return x;
}

/**
 * Finds a root of f using the bisection method
 */
double bisection(scope double delegate(double) @safe pure f, double a, double b, double tol = 1e-10, size_t maxIter = 100) pure {
    double fa = f(a);
    double fb = f(b);
    assert(fa * fb < 0, "Function must have opposite signs at endpoints");
    
    foreach (iter; 0 .. maxIter) {
        double c = (a + b) / 2.0;
        double fc = f(c);
        
        if (abs(fc) < tol || (b - a) / 2.0 < tol) {
            return c;
        }
        
        if (fa * fc < 0) {
            b = c;
            fb = fc;
        } else {
            a = c;
            fa = fc;
        }
    }
    
    return (a + b) / 2.0;
}

/**
 * Finds a root of f using Newton's method
 */
double newton(scope double delegate(double) @safe pure f, 
              scope double delegate(double) @safe pure df, 
              double x0, double tol = 1e-10, size_t maxIter = 100) pure {
    double x = x0;
    
    foreach (iter; 0 .. maxIter) {
        double fx = f(x);
        double dfx = df(x);
        
        if (abs(fx) < tol) {
            return x;
        }
        
        double dx = fx / dfx;
        x -= dx;
        
        if (abs(dx) < tol) {
            return x;
        }
    }
    
    return x;
}

/**
 * Finds a root of f using the secant method
 */
double secant(scope double delegate(double) @safe pure f, double x0, double x1, double tol = 1e-10, size_t maxIter = 100) pure {
    double fx0 = f(x0);
    double fx1 = f(x1);
    
    foreach (iter; 0 .. maxIter) {
        if (abs(fx1) < tol) {
            return x1;
        }
        
        double x2 = x1 - fx1 * (x1 - x0) / (fx1 - fx0);
        
        if (abs(x2 - x1) < tol) {
            return x2;
        }
        
        x0 = x1;
        fx0 = fx1;
        x1 = x2;
        fx1 = f(x1);
    }
    
    return x1;
}

/**
 * Finds minimum of f using golden section search
 */
double goldenSectionSearch(scope double delegate(double) @safe pure f, double a, double b, double tol = 1e-10) pure {
    immutable double phi = (1.0 + sqrt(5.0)) / 2.0;
    immutable double resphi = 2.0 - phi;
    
    double x1 = a + resphi * (b - a);
    double x2 = b - resphi * (b - a);
    double f1 = f(x1);
    double f2 = f(x2);
    
    while (abs(b - a) > tol) {
        if (f1 < f2) {
            b = x2;
            x2 = x1;
            f2 = f1;
            x1 = a + resphi * (b - a);
            f1 = f(x1);
        } else {
            a = x1;
            x1 = x2;
            f1 = f2;
            x2 = b - resphi * (b - a);
            f2 = f(x2);
        }
    }
    
    return (a + b) / 2.0;
}

/**
 * Gradient descent optimization
 */
Vector gradientDescent(scope Vector delegate(Vector) @safe pure grad, 
                       Vector x0, double alpha = 0.01, double tol = 1e-6, size_t maxIter = 1000) pure {
    auto x = Vector(x0.data);
    
    foreach (iter; 0 .. maxIter) {
        auto g = grad(x);
        if (g.norm() < tol) {
            break;
        }
        x = x - g * alpha;
    }
    
    return x;
}
