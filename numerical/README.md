# UIM Numerical - Numerical Computing Library

A comprehensive D language library for numerical computing, mathematical operations, and solving numerical problems.

## Features

### Linear Algebra
- **Vectors** - Mathematical vectors with operations (add, subtract, dot product, cross product, norm)
- **Matrices** - Matrix operations (add, subtract, multiply, transpose, determinant, trace, LU decomposition)
- **Linear Systems** - Solve Ax = b using Gaussian elimination with partial pivoting

### Solvers
- **Root Finding**
  - Bisection method
  - Newton's method
  - Secant method
- **Optimization**
  - Golden section search
  - Gradient descent

### Statistics
- Basic statistics (mean, median, variance, standard deviation)
- Correlation and covariance
- Linear regression with R² calculation
- Percentiles and quartiles

### Numerical Integration & Differentiation
- **Integration Methods**
  - Trapezoidal rule
  - Simpson's rule
  - Adaptive Simpson's rule
  - Romberg integration
  - Monte Carlo integration (multidimensional)
- **Differentiation**
  - Forward differences
  - Central differences (more accurate)
  - Second derivatives

## Quick Start

### Vector Operations

```d
import uim.numerical;

auto v1 = Vector([1.0, 2.0, 3.0]);
auto v2 = Vector([4.0, 5.0, 6.0]);

auto sum = v1 + v2;              // Vector addition
auto dot = v1.dot(v2);           // Dot product
auto magnitude = v1.norm();      // Euclidean norm
auto unit = v1.normalized();     // Unit vector
```

### Matrix Operations

```d
import uim.numerical;

auto m1 = Matrix([[1.0, 2.0], [3.0, 4.0]]);
auto m2 = Matrix([[5.0, 6.0], [7.0, 8.0]]);

auto product = m1 * m2;          // Matrix multiplication
auto trans = m1.transpose();     // Transpose
auto det = m1.determinant();     // Determinant
auto tr = m1.trace();            // Trace

// Identity and zero matrices
auto I = eye(3);                 // 3x3 identity
auto Z = zeros(2, 3);            // 2x3 zero matrix
```

### Solving Linear Systems

```d
import uim.numerical;

auto A = Matrix([[2.0, 1.0], [1.0, 3.0]]);
auto b = Vector([5.0, 6.0]);
auto x = solveLinearSystem(A, b);  // Solve Ax = b
```

### Root Finding

```d
import uim.numerical;

// Find root of f(x) = x^2 - 2
auto f = (double x) @safe pure => x * x - 2.0;
auto df = (double x) @safe pure => 2.0 * x;

double root1 = bisection(f, 0.0, 2.0);
double root2 = newton(f, df, 1.0);
double root3 = secant(f, 1.0, 2.0);
```

### Optimization

```d
import uim.numerical;

// Find minimum of (x - 3)^2
auto f = (double x) @safe pure => (x - 3.0) * (x - 3.0);
double minX = goldenSectionSearch(f, 0.0, 5.0);
```

### Statistics

```d
import uim.numerical;

auto data = Vector([2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0]);

double avg = mean(data);
double med = median(data);
double stdDev = standardDeviation(data);
double var = variance(data);

// Linear regression
auto x = Vector([1.0, 2.0, 3.0, 4.0, 5.0]);
auto y = Vector([2.0, 4.0, 5.0, 4.0, 5.0]);
auto lr = linearRegression(x, y);  // Returns [intercept, slope]
double r2 = rSquared(x, y);
```

### Numerical Integration

```d
import uim.numerical;

// Integrate x^2 from 0 to 1
auto f = (double x) @safe pure => x * x;

double result1 = trapezoid(f, 0.0, 1.0, 100);
double result2 = simpson(f, 0.0, 1.0, 100);
double result3 = romberg(f, 0.0, 1.0);
double result4 = adaptiveSimpson(f, 0.0, 1.0);
```

### Numerical Differentiation

```d
import uim.numerical;
import std.math : sin, cos, PI;

auto f = (double x) @safe pure => sin(x);
double x0 = PI / 4.0;

double deriv = derivativeCentral(f, x0);
double deriv2 = secondDerivative(f, x0);
```

## API Reference

### Vector

```d
struct Vector {
    this(double[] values);
    this(size_t size);
    
    Vector opBinary(string op)(const Vector rhs);  // +, -
    Vector opBinary(string op)(double scalar);      // *, /
    double dot(const Vector rhs);
    Vector cross(const Vector rhs);  // 3D only
    double norm();
    Vector normalized();
    double distance(const Vector rhs);
    double sum(), mean(), max(), min();
}

// Helper functions
Vector zeros(size_t n);
Vector ones(size_t n);
Vector linspace(double start, double stop, size_t num);
Vector arange(double start, double stop, double step = 1.0);
```

### Matrix

```d
struct Matrix {
    this(double[][] values);
    this(size_t rows, size_t cols);
    
    Matrix opBinary(string op)(const Matrix rhs);  // +, -, *
    Matrix opBinary(string op)(double scalar);      // *
    Vector opBinary(string op)(const Vector v);     // *
    Matrix transpose();
    double determinant();
    double trace();
    double norm();
    Matrix luDecomposition();
    Vector row(size_t i), col(size_t j);
}

// Helper functions
Matrix zeros(size_t rows, size_t cols);
Matrix eye(size_t n);
Matrix diag(const Vector v);
```

## Running Examples

```bash
cd examples
dub run --single example.d
```

## Dependencies

- **uim-base:core** - Core UIM functionality

## License

Apache-2.0

## Author

Ozan Nurettin Süel (aka UIManufaktur)

## Copyright

Copyright © 2018-2026, ONS
