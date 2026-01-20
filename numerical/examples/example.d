#!/usr/bin/env dub
/+ dub.sdl:
    name "numerical-example"
    dependency "uim-base:numerical" path="../.."
+/
module numerical.examples.example;

import std.stdio;
import std.math;
import uim.numerical;

void main() {
    writeln("=== UIM Numerical Library Examples ===\n");
    
    // Example 1: Vector operations
    writeln("--- Example 1: Vector Operations ---");
    auto v1 = Vector([1.0, 2.0, 3.0]);
    auto v2 = Vector([4.0, 5.0, 6.0]);
    











































































































}    writeln("=== Examples Complete ===");        writeln();    writefln("  Exact:     %.10f", cos(x0));    writefln("  Numerical: %.10f", deriv);    writeln("Derivative of sin(x) at x = π/4:");    double deriv = derivativeCentral(sinFunc, x0);    double x0 = PI / 4.0;    auto sinFunc = (double x) @safe pure => sin(x);    // Derivative of sin(x) at x = pi/4 (should be cos(pi/4) ≈ 0.707)        writeln("--- Example 8: Numerical Derivatives ---");    // Example 8: Derivatives        writeln();    writefln("  Exact value:      %.10f", 1.0/3.0);    writefln("  Romberg method:   %.10f", integral3);    writefln("  Simpson's rule:   %.10f", integral2);    writefln("  Trapezoidal rule: %.10f", integral1);    writeln("Integral of x^2 from 0 to 1:");        double integral3 = romberg(h, 0.0, 1.0, 8);    double integral2 = simpson(h, 0.0, 1.0, 100);    double integral1 = trapezoid(h, 0.0, 1.0, 100);    auto h = (double x) @safe pure => x * x;    // Integrate f(x) = x^2 from 0 to 1 (exact answer = 1/3)        writeln("--- Example 7: Numerical Integration ---");    // Example 7: Numerical integration        writeln();    writefln("  R² = %.3f", rSquared(x_data, y_data));    writefln("  y = %.3f + %.3f*x", lr[0], lr[1]);    writeln("  y = ", y_data);    writeln("  x = ", x_data);    writeln("\nLinear Regression (y = a + b*x):");    auto lr = linearRegression(x_data, y_data);    auto y_data = Vector([2.0, 4.0, 5.0, 4.0, 5.0]);    auto x_data = Vector([1.0, 2.0, 3.0, 4.0, 5.0]);        writeln("Variance: ", variance(data));    writeln("Std Dev: ", standardDeviation(data));    writeln("Median: ", median(data));    writeln("Mean: ", mean(data));    writeln("Data: ", data);    auto data = Vector([2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0]);    writeln("--- Example 6: Statistics ---");    // Example 6: Statistics        writeln();    writeln("  f(", minX, ") = ", g(minX));    writeln("Minimum of (x-3)^2 found at x = ", minX);    double minX = goldenSectionSearch(g, 0.0, 5.0);    auto g = (double x) @safe pure => (x - 3.0) * (x - 3.0);    // Find minimum of f(x) = (x - 3)^2        writeln("--- Example 5: Optimization ---");    // Example 5: Optimization        writeln();    writeln("Root of x^2 - 2 using Newton: ", root2);    double root2 = newton(f, df, 1.0);        writeln("  sqrt(2) = ", sqrt(2.0));    writeln("Root of x^2 - 2 using bisection: ", root1);    double root1 = bisection(f, 0.0, 2.0);        auto df = (double x) @safe pure => 2.0 * x;    auto f = (double x) @safe pure => x * x - 2.0;    // Find root of f(x) = x^2 - 2 (should be sqrt(2))        writeln("--- Example 4: Root Finding ---");    // Example 4: Root finding        writeln();    writeln("Verification Ax = ", A * x);    writeln("Solution x = ", x);    writeln("b = ", b);    writeln("A = ", A);    auto x = solveLinearSystem(A, b);    auto b = Vector([5.0, 6.0]);    auto A = Matrix([[2.0, 1.0], [1.0, 3.0]]);    writeln("--- Example 3: Solving Linear System Ax = b ---");    // Example 3: Linear system solver        writeln();    writeln("trace(m1) = ", m1.trace());    writeln("det(m1) = ", m1.determinant());    writeln("m1' (transpose) = ", m1.transpose());    writeln("m1 * m2 = ", m1 * m2);    writeln("m1 + m2 = ", m1 + m2);    writeln("m2 = ", m2);    writeln("m1 = ", m1);        auto m2 = Matrix([[5.0, 6.0], [7.0, 8.0]]);    auto m1 = Matrix([[1.0, 2.0], [3.0, 4.0]]);    writeln("--- Example 2: Matrix Operations ---");    // Example 2: Matrix operations        writeln();    writeln("||v1|| (norm) = ", v1.norm());    writeln("v1 . v2 (dot product) = ", v1.dot(v2));    writeln("v1 * 2 = ", v1 * 2);    writeln("v1 - v2 = ", v1 - v2);    writeln("v1 + v2 = ", v1 + v2);    writeln("v1 = ", v1);
    writeln("v2 = ", v2);