/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.numerical.integration;

import std.math;

@safe:

/**
 * Numerical integration using the trapezoidal rule
 */
double trapezoid(scope double delegate(double) @safe pure f, double a, double b, size_t n = 100) pure {
    double h = (b - a) / n;
    double sum = (f(a) + f(b)) / 2.0;
    
    foreach (i; 1 .. n) {
        sum += f(a + i * h);
    }
    
    return h * sum;
}

/**
 * Numerical integration using Simpson's rule
 */
double simpson(scope double delegate(double) @safe pure f, double a, double b, size_t n = 100) pure {
    assert(n % 2 == 0, "n must be even for Simpson's rule");
    
    double h = (b - a) / n;
    double sum = f(a) + f(b);
    
    foreach (i; 1 .. n) {
        double x = a + i * h;
        sum += (i % 2 == 0 ? 2 : 4) * f(x);
    }
    
    return (h / 3.0) * sum;
}

/**
 * Numerical integration using adaptive Simpson's rule
 */
double adaptiveSimpson(scope double delegate(double) @safe pure f, double a, double b, double tol = 1e-10, size_t maxDepth = 50) pure {
    return adaptiveSimpsonHelper(f, a, b, tol, simpson(f, a, b, 2), 0, maxDepth);
}

private double adaptiveSimpsonHelper(scope double delegate(double) @safe pure f, double a, double b, 
                                     double tol, double S, size_t depth, size_t maxDepth) pure {
    double c = (a + b) / 2.0;
    double left = simpson(f, a, c, 2);
    double right = simpson(f, c, b, 2);
    double S2 = left + right;
    
    if (depth >= maxDepth || abs(S2 - S) <= 15.0 * tol) {
        return S2 + (S2 - S) / 15.0;
    }
    
    return adaptiveSimpsonHelper(f, a, c, tol / 2.0, left, depth + 1, maxDepth) +
           adaptiveSimpsonHelper(f, c, b, tol / 2.0, right, depth + 1, maxDepth);
}

/**
 * Numerical integration using Romberg's method
 */
double romberg(scope double delegate(double) @safe pure f, double a, double b, size_t maxIter = 10) pure {
    double[10][10] R;  // Romberg array
    
    double h = b - a;
    R[0][0] = (h / 2.0) * (f(a) + f(b));
    
    foreach (i; 1 .. maxIter) {
        h /= 2.0;
        double sum = 0;
        size_t points = 1 << (i - 1);
        foreach (k; 0 .. points) {
            sum += f(a + (2 * k + 1) * h);
        }
        R[i][0] = 0.5 * R[i - 1][0] + h * sum;
        
        foreach (j; 1 .. i + 1) {
            double power = 1 << (2 * j);
            R[i][j] = (power * R[i][j - 1] - R[i - 1][j - 1]) / (power - 1);
        }
    }
    
    return R[maxIter - 1][maxIter - 1];
}

/**
 * Numerical derivative using finite differences (forward)
 */
double derivative(scope double delegate(double) @safe pure f, double x, double h = 1e-8) pure {
    return (f(x + h) - f(x)) / h;
}

/**
 * Numerical derivative using central differences (more accurate)
 */
double derivativeCentral(scope double delegate(double) @safe pure f, double x, double h = 1e-5) pure {
    return (f(x + h) - f(x - h)) / (2.0 * h);
}

/**
 * Second derivative using central differences
 */
double secondDerivative(scope double delegate(double) @safe pure f, double x, double h = 1e-5) pure {
    return (f(x + h) - 2.0 * f(x) + f(x - h)) / (h * h);
}

/**
 * Numerical integration of a function with multiple variables using Monte Carlo method
 */
double monteCarloIntegration(scope double delegate(double[]) @safe f, 
                             double[] lowerBounds, double[] upperBounds, 
                             size_t numSamples = 10000) @trusted {
    import std.random : uniform;
    
    assert(lowerBounds.length == upperBounds.length, "Bounds must have same dimension");
    
    size_t dim = lowerBounds.length;
    double volume = 1.0;
    foreach (i; 0 .. dim) {
        volume *= (upperBounds[i] - lowerBounds[i]);
    }
    
    double sum = 0;
    auto point = new double[dim];
    
    foreach (_; 0 .. numSamples) {
        foreach (i; 0 .. dim) {
            point[i] = lowerBounds[i] + (upperBounds[i] - lowerBounds[i]) * uniform(0.0, 1.0);
        }
        sum += f(point);
    }
    
    return volume * sum / numSamples;
}
