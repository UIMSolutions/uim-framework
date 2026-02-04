/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.datascience.classification;

import std.math;
import std.algorithm;
import std.array;
import uim.core;

/**
 * Decision Tree Classifier
 */
class DecisionTreeClassifier {
  private {
    struct Node {
      bool isLeaf;
      size_t featureIndex;
      double threshold;
      size_t class_label;
      Node* left;
      Node* right;
    }
    
    Node* root;
    size_t max_depth;
    size_t min_samples_split;
  }

  /// Create decision tree classifier
  this(size_t tree_max_depth = 10, size_t tree_min_samples = 2) {
    max_depth = tree_max_depth;
    min_samples_split = tree_min_samples;
    root = null;
  }

  /// Fit decision tree
  void fit(double[][] X, size_t[] y) {
    assert(X.length == y.length, "X and y must have same length");
    assert(X.length > 0 && X[0].length > 0, "Data must not be empty");
    
    size_t[] indices = new size_t[X.length];
    foreach(i; 0 .. X.length) indices[i] = i;
    
    root = buildTree(X, y, indices, 0);
  }

  /// Predict class labels
  size_t[] predict(double[][] X) const {
    assert(X.length > 0, "Data must not be empty");
    
    size_t[] predictions = new size_t[X.length];
    foreach(i; 0 .. X.length) {
      predictions[i] = predictSample(root, X[i]);
    }
    return predictions;
  }

  private Node* buildTree(double[][] X, size_t[] y, size_t[] indices, size_t depth) {
    auto node = new Node();
    
    // Base cases
    if (indices.length < min_samples_split || depth >= max_depth) {
      node.isLeaf = true;
      node.class_label = majorityClass(y, indices);
      return node;
    }
    
    // All same class
    size_t label = y[indices[0]];
    bool allSame = true;
    foreach(idx; indices) {
      if (y[idx] != label) {
        allSame = false;
        break;
      }
    }
    if (allSame) {
      node.isLeaf = true;
      node.class_label = label;
      return node;
    }
    
    // Find best split
    double bestGain = -1.0;
    size_t bestFeature = 0;
    double bestThreshold = 0.0;
    
    foreach(j; 0 .. X[0].length) {
      double[] values = new double[indices.length];
      foreach(i, idx; indices) {
        values[i] = X[idx][j];
      }
      
      sort(values);
      
      foreach(i; 0 .. values.length - 1) {
        double threshold = (values[i] + values[i+1]) / 2.0;
        
        size_t[] leftIndices, rightIndices;
        foreach(idx; indices) {
          if (X[idx][j] <= threshold) {
            leftIndices ~= idx;
          } else {
            rightIndices ~= idx;
          }
        }
        
        if (leftIndices.length == 0 || rightIndices.length == 0) continue;
        
        double gain = informationGain(y, indices, leftIndices, rightIndices);
        if (gain > bestGain) {
          bestGain = gain;
          bestFeature = j;
          bestThreshold = threshold;
        }
      }
    }
    
    if (bestGain < 0.0) {
      node.isLeaf = true;
      node.class_label = majorityClass(y, indices);
      return node;
    }
    
    // Split data
    size_t[] leftIndices, rightIndices;
    foreach(idx; indices) {
      if (X[idx][bestFeature] <= bestThreshold) {
        leftIndices ~= idx;
      } else {
        rightIndices ~= idx;
      }
    }
    
    node.isLeaf = false;
    node.featureIndex = bestFeature;
    node.threshold = bestThreshold;
    node.left = buildTree(X, y, leftIndices, depth + 1);
    node.right = buildTree(X, y, rightIndices, depth + 1);
    
    return node;
  }

  private size_t predictSample(Node* node, double[] sample) const {
    if (node is null || node.isLeaf) {
      return node ? node.class_label : 0;
    }
    
    if (sample[node.featureIndex] <= node.threshold) {
      return predictSample(node.left, sample);
    } else {
      return predictSample(node.right, sample);
    }
  }

  private static double informationGain(size_t[] y, size_t[] parent, size_t[] left, size_t[] right) pure {
    double parentEntropy = entropy(y, parent);
    double leftEntropy = entropy(y, left);
    double rightEntropy = entropy(y, right);
    
    double n = parent.length;
    double weightedEntropy = (left.length / n) * leftEntropy + (right.length / n) * rightEntropy;
    
    return parentEntropy - weightedEntropy;
  }

  private static double entropy(size_t[] y, size_t[] indices) pure {
    if (indices.length == 0) return 0.0;
    
    size_t[size_t] counts;
    foreach(idx; indices) {
      counts[y[idx]]++;
    }
    
    double ent = 0.0;
    foreach(count; counts.values) {
      double p = cast(double)count / indices.length;
      if (p > 0.0) {
        ent -= p * log2(p);
      }
    }
    return ent;
  }

  private static size_t majorityClass(size_t[] y, size_t[] indices) pure {
    size_t[size_t] counts;
    foreach(idx; indices) {
      counts[y[idx]]++;
    }
    
    size_t maxCount = 0;
    size_t majorityLabel = 0;
    foreach(label, count; counts) {
      if (count > maxCount) {
        maxCount = count;
        majorityLabel = label;
      }
    }
    return majorityLabel;
  }
}

/**
 * K-Nearest Neighbors Classifier
 */
class KNearestNeighbors {
  private {
    double[][] X_train;
    size_t[] y_train;
    size_t k;
  }

  /// Create KNN classifier
  this(size_t num_neighbors = 3) {
    assert(num_neighbors > 0, "k must be positive");
    k = num_neighbors;
  }

  /// Fit KNN (just stores training data)
  void fit(double[][] X, size_t[] y) {
    assert(X.length == y.length, "X and y must have same length");
    X_train = X.dup;
    y_train = y.dup;
  }

  /// Predict class labels
  size_t[] predict(double[][] X) const {
    assert(X.length > 0, "Data must not be empty");
    
    size_t[] predictions = new size_t[X.length];
    foreach(i; 0 .. X.length) {
      predictions[i] = predictSample(X[i]);
    }
    return predictions;
  }

  private size_t predictSample(double[] sample) const {
    // Compute distances to all training samples
    struct Distance {
      double dist;
      size_t idx;
    }
    
    Distance[] distances = new Distance[X_train.length];
    foreach(i; 0 .. X_train.length) {
      double dist = 0.0;
      foreach(j; 0 .. sample.length) {
        double diff = sample[j] - X_train[i][j];
        dist += diff * diff;
      }
      distances[i] = Distance(sqrt(dist), i);
    }
    
    // Sort and get k nearest
    sort(distances);
    
    size_t[size_t] votes;
    foreach(i; 0 .. min(k, distances.length)) {
      size_t label = y_train[distances[i].idx];
      votes[label]++;
    }
    
    // Return most common label
    size_t maxVotes = 0;
    size_t prediction = 0;
    foreach(label, count; votes) {
      if (count > maxVotes) {
        maxVotes = count;
        prediction = label;
      }
    }
    
    return prediction;
  }
}

/**
 * Naive Bayes Classifier
 */
class NaiveBayesClassifier {
  private {
    struct ClassStats {
      double prior;
      double[] mean;
      double[] var;
    }
    
    ClassStats[size_t] class_stats;
  }

  /// Fit Naive Bayes
  void fit(double[][] X, size_t[] y) {
    assert(X.length == y.length, "X and y must have same length");
    assert(X.length > 0 && X[0].length > 0, "Data must not be empty");
    
    size_t n_samples = X.length;
    size_t n_features = X[0].length;
    
    // Group samples by class
    double[][size_t] class_samples;
    size_t[size_t] class_counts;
    
    foreach(i; 0 .. n_samples) {
      size_t label = y[i];
      class_samples[label] ~= i;
      class_counts[label]++;
    }
    
    // Calculate statistics for each class
    foreach(label; class_counts.keys.sort()) {
      auto indices = class_samples[label];
      ClassStats stats;
      stats.prior = cast(double)indices.length / n_samples;
      stats.mean = new double[n_features];
      stats.var = new double[n_features];
      
      // Calculate mean and variance for each feature
      foreach(j; 0 .. n_features) {
        double sum = 0.0;
        foreach(idx; indices) {
          sum += X[idx][j];
        }
        stats.mean[j] = sum / indices.length;
        
        double var = 0.0;
        foreach(idx; indices) {
          double diff = X[idx][j] - stats.mean[j];
          var += diff * diff;
        }
        stats.var[j] = var / (indices.length - 1);
      }
      
      class_stats[label] = stats;
    }
  }

  /// Predict class labels
  size_t[] predict(double[][] X) const {
    assert(X.length > 0, "Data must not be empty");
    
    size_t[] predictions = new size_t[X.length];
    foreach(i; 0 .. X.length) {
      predictions[i] = predictSample(X[i]);
    }
    return predictions;
  }

  private size_t predictSample(double[] sample) const {
    double maxProb = -double.max;
    size_t prediction = 0;
    
    foreach(label, stats; class_stats) {
      double prob = log(stats.prior);
      
      foreach(j; 0 .. sample.length) {
        double mean = stats.mean[j];
        double var = stats.var[j];
        double num = exp(-((sample[j] - mean) ^^ 2) / (2 * var));
        double denom = sqrt(2 * PI * var);
        prob += log(num / denom);
      }
      
      if (prob > maxProb) {
        maxProb = prob;
        prediction = label;
      }
    }
    
    return prediction;
  }
}
