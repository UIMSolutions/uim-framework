/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.numerical.vector;

import std.math;
import std.algorithm;
import std.range;
import std.conv;

@safe:

/**
 * A mathematical vector with numerical operations
 */
struct Vector {
    double[] data;
    
    /**
     * Creates a vector from an array
     */
    this(double[] values) pure nothrow {
        data = values.dup;
    }
    
    /**
     * Creates a zero vector of specified size
     */
    this(size_t size) pure nothrow {
        data = new double[size];
    }
    
    /**
     * Gets the size of the vector
     */
    @property size_t length() const pure nothrow {
        return data.length;
    }
    
    /**
     * Index access
     */
    double opIndex(size_t i) const pure nothrow {
        return data[i];
    }
    
    /// ditto
    ref double opIndex(size_t i) pure nothrow return {
        return data[i];
    }
    
    /**
     * Vector addition
     */
    Vector opBinary(string op)(const Vector rhs) const pure if (op == "+") {
        assert(length == rhs.length, "Vector dimensions must match");
        auto result = Vector(length);
        foreach (i; 0 .. length) {
            result.data[i] = data[i] + rhs.data[i];
        }
        return result;
    }
    
    /**
     * Vector subtraction
     */
    Vector opBinary(string op)(const Vector rhs) const pure if (op == "-") {
        assert(length == rhs.length, "Vector dimensions must match");
        auto result = Vector(length);
        foreach (i; 0 .. length) {
            result.data[i] = data[i] - rhs.data[i];
        }
        return result;
    }
    
    /**
     * Scalar multiplication
     */
    Vector opBinary(string op)(double scalar) const pure if (op == "*") {
        auto result = Vector(length);
        foreach (i; 0 .. length) {
            result.data[i] = data[i] * scalar;
        }
        return result;
    }
    
    /**
     * Scalar division
     */
    Vector opBinary(string op)(double scalar) const pure if (op == "/") {
        auto result = Vector(length);
        foreach (i; 0 .. length) {
            result.data[i] = data[i] / scalar;
        }
        return result;
    }
    
    /**
     * Dot product
     */
    double dot(const Vector rhs) const pure nothrow {
        assert(length == rhs.length, "Vector dimensions must match");
        double result = 0;
        foreach (i; 0 .. length) {
            result += data[i] * rhs.data[i];
        }
        return result;
    }
    
    /**
     * Cross product (3D only)
     */
    Vector cross(const Vector rhs) const pure {
        assert(length == 3 && rhs.length == 3, "Cross product only defined for 3D vectors");
        return Vector([
            data[1] * rhs.data[2] - data[2] * rhs.data[1],
            data[2] * rhs.data[0] - data[0] * rhs.data[2],
            data[0] * rhs.data[1] - data[1] * rhs.data[0]
        ]);
    }
    
    /**
     * Euclidean norm (magnitude)
     */
    double norm() const pure nothrow {
        return sqrt(dot(this));
    }
    
    /**
     * Returns a normalized (unit) vector
     */
    Vector normalized() const pure {
        double n = norm();
        assert(n != 0, "Cannot normalize zero vector");
        return this / n;
    }
    
    /**
     * Distance to another vector
     */
    double distance(const Vector rhs) const pure {
        return (this - rhs).norm();
    }
    
    /**
     * Sum of all elements
     */
    double sum() const pure nothrow {
        double result = 0;
        foreach (val; data) {
            result += val;
        }
        return result;
    }
    
    /**
     * Mean of all elements
     */
    double mean() const pure nothrow {
        return sum() / length;
    }
    
    /**
     * Maximum element
     */
    double max() const pure nothrow {
        double result = data[0];
        foreach (val; data[1 .. $]) {
            if (val > result) result = val;
        }
        return result;
    }
    
    /**
     * Minimum element
     */
    double min() const pure nothrow {
        double result = data[0];
        foreach (val; data[1 .. $]) {
            if (val < result) result = val;
        }
        return result;
    }
    
    /**
     * String representation
     */
    string toString() const {
        import std.format : format;
        return format("%s", data);
    }
}

/**
 * Creates a zero vector
 */
Vector zeros(size_t n) pure {
    return Vector(n);
}

/**
 * Creates a vector of ones
 */
Vector ones(size_t n) pure {
    auto result = Vector(n);
    result.data[] = 1.0;
    return result;
}

/**
 * Creates a linearly spaced vector
 */
Vector linspace(double start, double stop, size_t num) pure {
    auto result = Vector(num);
    if (num == 1) {
        result.data[0] = start;
        return result;
    }
    double step = (stop - start) / (num - 1);
    foreach (i; 0 .. num) {
        result.data[i] = start + i * step;
    }
    return result;
}

/**
 * Creates a vector from a range
 */
Vector arange(double start, double stop, double step = 1.0) pure {
    import std.math : abs, ceil;
    size_t n = cast(size_t)ceil(abs((stop - start) / step));
    auto result = Vector(n);
    foreach (i; 0 .. n) {
        result.data[i] = start + i * step;
    }
    return result;
}
