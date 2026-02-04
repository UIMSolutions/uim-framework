#!/usr/bin/env dub
/+ dub.sdl:
name "datascience_basic_example"
description "Basic data science library example"
dependency "uim-framework:datascience" version="*"
+/
module datascience.examples.basic_example;

import std.stdio;
import uim.datascience;

void main() {
  writeln("=== UIM Data Science Library - Basic Example ===\n");

  // 1. Create and analyze a Series
  writeln("1. Series Operations:");
  auto data = new Series!double([1.0, 2.0, 3.0, 4.0, 5.0]);
  writeln("  Series: ", data);
  writeln("  Mean: ", data.mean());
  writeln("  StdDev: ", data.stddev());
  writeln("  Min: ", data.min());



































































}  writeln("=== Example completed successfully! ===");  writeln();  writeln("  Coefficients: ", lr.get_coefficients());  writeln("  Intercept: ", lr.get_intercept());  writeln("  Predictions: ", predictions);  writeln("  Training data: ", y);  auto predictions = lr.predict(X);  lr.fit(X, y);  auto lr = new LinearRegression();  double[] y = [2.0, 4.0, 6.0, 8.0, 10.0];  double[][] X = [[1.0], [2.0], [3.0], [4.0], [5.0]];  writeln("6. Linear Regression:");  // 6. Linear Regression  writeln();  writeln("  Inertia: ", kmeans.get_inertia());  writeln("  Labels: ", labels);  writeln("  Clusters: 2");  writeln("  Data points: ", clusterData.length);  auto labels = kmeans.predict(clusterData);  kmeans.fit(clusterData);  auto kmeans = new KMeans(2);  ];    [10.5, 10.5],    [10.0, 10.0],    [1.5, 1.5],    [1.0, 1.0],  double[][] clusterData = [  writeln("5. Clustering (K-Means):");  // 5. Clustering (K-Means)  writeln();  writeln("  L2 norm: ", norm);  writeln("  Dot product: ", dotProd);  writeln("  Vector 2: ", vec2);  writeln("  Vector 1: ", vec);  double norm = LinearAlgebra.norm(vec);  double dotProd = LinearAlgebra.dot(vec, vec2);  double[] vec2 = [4.0, 5.0, 6.0];  double[] vec = [1.0, 2.0, 3.0];  writeln("4. Linear Algebra:");  // 4. Linear algebra  writeln();  writeln("  Normalized shape: ", normalized.length, "x", normalized[0].length);  writeln("  Original: ", rawData);  auto normalized = Preprocessing.minMaxScale([[1.0, 10.0], [100.0, 1000.0]]);  double[] rawData = [1.0, 10.0, 100.0, 1000.0];  writeln("3. Data Preprocessing:");  // 3. Normalization  writeln();  writeln("  Quantile(0.75): ", Statistics.quantile(values, 0.75));  writeln("  Quantile(0.25): ", Statistics.quantile(values, 0.25));  writeln("  StdDev: ", Statistics.stddev(values));  writeln("  Variance: ", Statistics.variance(values));  writeln("  Mean: ", Statistics.mean(values));  writeln("  Data: ", values);  double[] values = [10.0, 20.0, 30.0, 40.0, 50.0];  writeln("2. Statistical Analysis:");  // 2. Statistical operations  writeln();  writeln("  Median: ", data.median());  writeln("  Max: ", data.max());