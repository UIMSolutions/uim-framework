/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.numerical.statistics;

import std.math;
import std.algorithm;
import uim.numerical.vector;

@safe:

/**
 * Calculates the mean (average) of a vector
 */
double mean(const Vector v) pure nothrow {
    return v.mean();
}

/**
 * Calculates the variance of a vector
 */
double variance(const Vector v, bool sample = true) pure nothrow {
    double m = v.mean();
    double sum = 0;
    foreach (val; v.data) {
        double diff = val - m;
        sum += diff * diff;
    }
    size_t n = sample ? v.length - 1 : v.length;
    return sum / n;
}

/**
 * Calculates the standard deviation of a vector
 */
double standardDeviation(const Vector v, bool sample = true) pure nothrow {
    return sqrt(variance(v, sample));
}

/**
 * Calculates the median of a vector
 */
double median(Vector v) pure {
    import std.algorithm : sort;
    auto sorted = v.data.dup;
    sorted.sort();
    
    size_t n = sorted.length;
    if (n % 2 == 1) {
        return sorted[n / 2];
    } else {
        return (sorted[n / 2 - 1] + sorted[n / 2]) / 2.0;
    }
}

/**
 * Calculates the covariance between two vectors
 */
double covariance(const Vector x, const Vector y, bool sample = true) pure {
    assert(x.length == y.length, "Vectors must have same length");
    
    double mx = x.mean();
    double my = y.mean();
    double sum = 0;
    
    foreach (i; 0 .. x.length) {
        sum += (x.data[i] - mx) * (y.data[i] - my);
    }
    
    size_t n = sample ? x.length - 1 : x.length;
    return sum / n;
}

/**
 * Calculates the Pearson correlation coefficient
 */
double correlation(const Vector x, const Vector y) pure {
    double cov = covariance(x, y);
    double sx = standardDeviation(x);
    double sy = standardDeviation(y);
    return cov / (sx * sy);
}

/**
 * Calculates linear regression (y = a + b*x)
 * Returns: [intercept, slope]
 */
double[2] linearRegression(const Vector x, const Vector y) pure {
    assert(x.length == y.length, "Vectors must have same length");
    
    double mx = x.mean();
    double my = y.mean();
    
    double num = 0;
    double den = 0;
    
    foreach (i; 0 .. x.length) {
        double dx = x.data[i] - mx;
        num += dx * (y.data[i] - my);
        den += dx * dx;
    }
    
    double slope = num / den;
    double intercept = my - slope * mx;
    
    return [intercept, slope];
}

/**
 * Calculates the sum of squared errors for linear regression
 */
double rSquared(const Vector x, const Vector y) pure {
    auto lr = linearRegression(x, y);
    double intercept = lr[0];
    double slope = lr[1];
    
    double ssr = 0;  // Sum of squared residuals
    double sst = 0;  // Total sum of squares
    double my = y.mean();
    
    foreach (i; 0 .. x.length) {
        double predicted = intercept + slope * x.data[i];
        double residual = y.data[i] - predicted;
        ssr += residual * residual;
        
        double total = y.data[i] - my;
        sst += total * total;
    }
    
    return 1.0 - (ssr / sst);
}

/**
 * Calculates percentile of a vector
 */
double percentile(Vector v, double p) pure {
    import std.algorithm : sort;
    assert(p >= 0 && p <= 100, "Percentile must be between 0 and 100");
    
    auto sorted = v.data.dup;
    sorted.sort();
    
    if (sorted.length == 1) {
        return sorted[0];
    }
    
    double index = (p / 100.0) * (sorted.length - 1);
    size_t lower = cast(size_t)index;
    size_t upper = lower + 1;
    
    if (upper >= sorted.length) {
        return sorted[$ - 1];
    }
    
    double fraction = index - lower;
    return sorted[lower] * (1.0 - fraction) + sorted[upper] * fraction;
}

/**
 * Calculates quartiles [Q1, Q2, Q3]
 */
double[3] quartiles(Vector v) pure {
    return [
        percentile(v, 25),
        percentile(v, 50),
        percentile(v, 75)
    ];
}
