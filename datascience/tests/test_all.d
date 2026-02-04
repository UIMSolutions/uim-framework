/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module datascience.tests.test_all;

import uim.datascience;

void main() {
  // Run basic tests
  testSeries();
  testStatistics();
  testLinearAlgebra();
  testClustering();
  testRegression();
  
  import std.stdio;
  writeln("\nAll tests passed!");
}

void testSeries() {
  import std.stdio;
  writeln("Testing Series...");
  
  auto s = new Series!double([1.0, 2.0, 3.0, 4.0, 5.0]);
  assert(s.length == 5);
  assert(s.mean() == 3.0);
  assert(s.min() == 1.0);
  assert(s.max() == 5.0);
  
  writeln("  Series: PASSED");
}

void testStatistics() {
  import std.stdio;
  writeln("Testing Statistics...");
  
  double[] data = [1.0, 2.0, 3.0, 4.0, 5.0];
  
  double m = Statistics.mean(data);
  assert(m == 3.0);
  
  double x = Statistics.correlation([1.0, 2.0, 3.0], [2.0, 4.0, 6.0]);
  assert(x == 1.0); // Perfect correlation
  
  writeln("  Statistics: PASSED");
}

void testLinearAlgebra() {
  import std.stdio;
  writeln("Testing Linear Algebra...");
  
  double[] v1 = [1.0, 0.0, 0.0];
  double[] v2 = [0.0, 1.0, 0.0];
  
  double dot = LinearAlgebra.dot(v1, v2);
  assert(dot == 0.0);
  
  double[][] matrix = [[1.0, 2.0], [3.0, 4.0]];
  auto trans = LinearAlgebra.transpose(matrix);
  assert(trans[0][1] == 3.0);
  
  writeln("  Linear Algebra: PASSED");
}

void testClustering() {
  import std.stdio;
  writeln("Testing Clustering...");
  
  double[][] data = [
    [1.0, 1.0],
    [1.5, 1.5],
    [10.0, 10.0],
    [10.5, 10.5],
  ];
  
  auto kmeans = new KMeans(2);
  kmeans.fit(data);
  auto labels = kmeans.predict(data);
  
  assert(labels.length == 4);
  
  writeln("  Clustering: PASSED");
}

void testRegression() {
  import std.stdio;
  writeln("Testing Regression...");
  
  double[][] X = [[1.0], [2.0], [3.0], [4.0], [5.0]];
  double[] y = [2.0, 4.0, 6.0, 8.0, 10.0];
  
  auto lr = new LinearRegression();
  lr.fit(X, y);
  auto pred = lr.predict(X);
  
  assert(pred.length == 5);
  
  writeln("  Regression: PASSED");
}
