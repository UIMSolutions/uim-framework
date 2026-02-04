/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.datascience.clustering;

import std.math;
import std.algorithm;
import std.array;
import uim.core;

/**
 * K-Means clustering algorithm
 */
class KMeans {
  private {
    size_t k;
    double[][] centers;
    size_t[] labels;
    double inertia;
  }

  /// Create K-Means model
  this(size_t n_clusters) {
    assert(n_clusters > 0, "Number of clusters must be positive");
    k = n_clusters;
  }

  /// Fit the model
  void fit(double[][] data, size_t max_iterations = 100) {
    assert(data.length > 0 && data[0].length > 0, "Data must not be empty");
    assert(k <= data.length, "Number of clusters cannot exceed number of samples");
    
    size_t n_samples = data.length;
    size_t n_features = data[0].length;
    
    // Initialize centers randomly
    centers = new double[][](k, n_features);
    foreach(i; 0 .. k) {
      foreach(j; 0 .. n_features) {
        centers[i][j] = data[i][j];
      }
    }
    
    labels = new size_t[n_samples];
    
    foreach(iter; 0 .. max_iterations) {
      // Assign points to nearest center
      foreach(i; 0 .. n_samples) {
        double minDist = double.max;
        size_t bestCluster = 0;
        
        foreach(c; 0 .. k) {
          double dist = 0.0;
          foreach(j; 0 .. n_features) {
            double diff = data[i][j] - centers[c][j];
            dist += diff * diff;
          }
          
          if (dist < minDist) {
            minDist = dist;
            bestCluster = c;
          }
        }
        labels[i] = bestCluster;
      }
      
      // Update centers
      double[][] newCenters = new double[][](k, n_features);
      size_t[] counts = new size_t[k];
      
      foreach(i; 0 .. n_samples) {
        size_t c = labels[i];
        counts[c]++;
        foreach(j; 0 .. n_features) {
          newCenters[c][j] += data[i][j];
        }
      }
      
      foreach(c; 0 .. k) {
        if (counts[c] > 0) {
          foreach(j; 0 .. n_features) {
            newCenters[c][j] /= counts[c];
          }
        } else {
          foreach(j; 0 .. n_features) {
            newCenters[c][j] = centers[c][j];
          }
        }
      }
      
      centers = newCenters;
    }
    
    // Calculate inertia (within-cluster sum of squares)
    inertia = 0.0;
    foreach(i; 0 .. n_samples) {
      double dist = 0.0;
      foreach(j; 0 .. n_features) {
        double diff = data[i][j] - centers[labels[i]][j];
        dist += diff * diff;
      }
      inertia += dist;
    }
  }

  /// Predict cluster labels
  size_t[] predict(double[][] data) const {
    assert(data.length > 0, "Data must not be empty");
    
    size_t n_samples = data.length;
    size_t n_features = data[0].length;
    size_t[] predictions = new size_t[n_samples];
    
    foreach(i; 0 .. n_samples) {
      double minDist = double.max;
      size_t bestCluster = 0;
      
      foreach(c; 0 .. k) {
        double dist = 0.0;
        foreach(j; 0 .. n_features) {
          double diff = data[i][j] - centers[c][j];
          dist += diff * diff;
        }
        
        if (dist < minDist) {
          minDist = dist;
          bestCluster = c;
        }
      }
      predictions[i] = bestCluster;
    }
    
    return predictions;
  }

  /// Get cluster centers
  @property double[][] get_centers() const { return centers.dup; }

  /// Get inertia
  @property double get_inertia() const { return inertia; }
}

/**
 * Hierarchical clustering with agglomerative approach
 */
class HierarchicalClustering {
  private {
    struct Cluster {
      size_t[] indices;
      double[] centroid;
    }
    
    Cluster[] clusters;
  }

  /// Perform hierarchical clustering
  void fit(double[][] data, size_t n_clusters) {
    assert(data.length > 0 && data[0].length > 0, "Data must not be empty");
    assert(n_clusters > 0 && n_clusters <= data.length, "Invalid number of clusters");
    
    size_t n_samples = data.length;
    size_t n_features = data[0].length;
    
    // Initialize each point as a cluster
    clusters = new Cluster[n_samples];
    foreach(i; 0 .. n_samples) {
      clusters[i].indices = [i];
      clusters[i].centroid = new double[n_features];
      foreach(j; 0 .. n_features) {
        clusters[i].centroid[j] = data[i][j];
      }
    }
    
    // Merge clusters until n_clusters remain
    while (clusters.length > n_clusters) {
      double minDist = double.max;
      size_t mergeI = 0, mergeJ = 1;
      
      // Find two closest clusters
      foreach(i; 0 .. clusters.length) {
        foreach(j; i+1 .. clusters.length) {
          double dist = clusterDistance(clusters[i], clusters[j]);
          if (dist < minDist) {
            minDist = dist;
            mergeI = i;
            mergeJ = j;
          }
        }
      }
      
      // Merge clusters
      foreach(idx; clusters[mergeJ].indices) {
        clusters[mergeI].indices ~= idx;
      }
      
      // Update centroid
      size_t n_features = clusters[mergeI].centroid.length;
      double[] newCentroid = new double[n_features];
      foreach(idx; clusters[mergeI].indices) {
        foreach(j; 0 .. n_features) {
          newCentroid[j] += data[idx][j];
        }
      }
      foreach(j; 0 .. n_features) {
        newCentroid[j] /= clusters[mergeI].indices.length;
      }
      clusters[mergeI].centroid = newCentroid;
      
      // Remove merged cluster
      clusters = clusters[0 .. mergeJ] ~ clusters[mergeJ+1 .. $];
    }
  }

  /// Get cluster assignments
  size_t[] getLabels(size_t n_samples) const {
    size_t[] labels = new size_t[n_samples];
    foreach(c, cluster; clusters) {
      foreach(idx; cluster.indices) {
        labels[idx] = c;
      }
    }
    return labels;
  }

  private static double clusterDistance(Cluster c1, Cluster c2) pure {
    double dist = 0.0;
    foreach(i; 0 .. c1.centroid.length) {
      double diff = c1.centroid[i] - c2.centroid[i];
      dist += diff * diff;
    }
    return sqrt(dist);
  }
}
