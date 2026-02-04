/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.datascience.web;

import vibe.d;
import std.json;
import std.algorithm;
import std.array;
import std.conv;
import uim.core;
import uim.datascience.dataframe;
import uim.datascience.series;

/**
 * REST API endpoints for data science operations
 */
@rootPath("/api/datascience")
class DataScienceAPI {

  /// Health check endpoint
  @method(HTTPMethod.GET)
  @path("/health")
  void health(HTTPServerResponse res) {
    res.writeJsonBody(["status": "ok", "service": "uim-datascience"]);
  }

  /// Endpoint for statistical calculations
  @method(HTTPMethod.POST)
  @path("/statistics/describe")
  void describeStatistics(HTTPServerRequest req, HTTPServerResponse res) {
    auto json = req.json;
    
    if ("data" !in json || !json["data"].type == JSONType.array) {
      res.statusCode = 400;
      res.writeJsonBody(["error": "Missing or invalid 'data' field"]);
      return;
    }

    double[] data = json["data"].array
      .map!(v => v.get!double)
      .array;

    JSONValue result;
    result["count"] = data.length;
    result["mean"] = cast(double)sum(data) / data.length;
    
    res.writeJsonBody(result);
  }

  /// Endpoint for data correlation
  @method(HTTPMethod.POST)
  @path("/correlation")
  void calculateCorrelation(HTTPServerRequest req, HTTPServerResponse res) {
    auto json = req.json;
    
    if ("x" !in json || "y" !in json) {
      res.statusCode = 400;
      res.writeJsonBody(["error": "Missing 'x' or 'y' field"]);
      return;
    }

    double[] x = json["x"].array.map!(v => v.get!double).array;
    double[] y = json["y"].array.map!(v => v.get!double).array;

    if (x.length != y.length) {
      res.statusCode = 400;
      res.writeJsonBody(["error": "x and y must have same length"]);
      return;
    }

    double correlation = calculatePearsonCorrelation(x, y);
    
    JSONValue result;
    result["correlation"] = correlation;
    result["length"] = x.length;
    
    res.writeJsonBody(result);
  }

  /// Endpoint for data preprocessing
  @method(HTTPMethod.POST)
  @path("/preprocess/normalize")
  void normalizeData(HTTPServerRequest req, HTTPServerResponse res) {
    auto json = req.json;
    
    if ("data" !in json || json["data"].type != JSONType.array) {
      res.statusCode = 400;
      res.writeJsonBody(["error": "Missing or invalid 'data' field"]);
      return;
    }

    double[] data = json["data"].array.map!(v => v.get!double).array;
    double[] normalized = minMaxNormalize(data);

    JSONValue result;
    result["data"] = JSONValue(normalized.map!(v => JSONValue(v)).array);
    
    res.writeJsonBody(result);
  }

  /// Endpoint for standardization
  @method(HTTPMethod.POST)
  @path("/preprocess/standardize")
  void standardizeData(HTTPServerRequest req, HTTPServerResponse res) {
    auto json = req.json;
    
    if ("data" !in json || json["data"].type != JSONType.array) {
      res.statusCode = 400;
      res.writeJsonBody(["error": "Missing or invalid 'data' field"]);
      return;
    }

    double[] data = json["data"].array.map!(v => v.get!double).array;
    double[] standardized = standardizeVector(data);

    JSONValue result;
    result["data"] = JSONValue(standardized.map!(v => JSONValue(v)).array);
    
    res.writeJsonBody(result);
  }

  /// Endpoint for histogram data
  @method(HTTPMethod.POST)
  @path("/visualization/histogram")
  void histogramData(HTTPServerRequest req, HTTPServerResponse res) {
    auto json = req.json;
    
    if ("data" !in json || json["data"].type != JSONType.array) {
      res.statusCode = 400;
      res.writeJsonBody(["error": "Missing or invalid 'data' field"]);
      return;
    }

    double[] data = json["data"].array.map!(v => v.get!double).array;
    size_t bins = 10;
    
    if ("bins" in json) {
      bins = json["bins"].get!size_t;
    }

    auto hist = createHistogram(data, bins);

    JSONValue result;
    result["bins"] = JSONValue(hist[0].map!(v => JSONValue(v)).array);
    result["frequencies"] = JSONValue(hist[1].map!(v => JSONValue(v)).array);
    
    res.writeJsonBody(result);
  }

  /// Endpoint for summary statistics
  @method(HTTPMethod.POST)
  @path("/statistics/summary")
  void summaryStatistics(HTTPServerRequest req, HTTPServerResponse res) {
    auto json = req.json;
    
    if ("data" !in json || json["data"].type != JSONType.array) {
      res.statusCode = 400;
      res.writeJsonBody(["error": "Missing or invalid 'data' field"]);
      return;
    }

    double[] data = json["data"].array.map!(v => v.get!double).array;

    auto sorted = data.dup;
    sort(sorted);

    JSONValue result;
    result["count"] = data.length;
    result["min"] = sorted.length > 0 ? sorted[0] : 0.0;
    result["max"] = sorted.length > 0 ? sorted[$-1] : 0.0;
    result["mean"] = cast(double)sum(data) / data.length;
    result["median"] = sorted.length > 0 ? 
      (sorted.length % 2 == 0 ? 
        (sorted[sorted.length/2 - 1] + sorted[sorted.length/2]) / 2.0 :
        sorted[sorted.length/2]) : 0.0;

    res.writeJsonBody(result);
  }

  private double calculatePearsonCorrelation(double[] x, double[] y) pure {
    if (x.length < 2) return 0.0;
    
    double mean_x = sum(x) / x.length;
    double mean_y = sum(y) / y.length;
    
    double cov = 0.0, var_x = 0.0, var_y = 0.0;
    
    foreach(i; 0 .. x.length) {
      double dx = x[i] - mean_x;
      double dy = y[i] - mean_y;
      cov += dx * dy;
      var_x += dx * dx;
      var_y += dy * dy;
    }
    
    if (var_x == 0.0 || var_y == 0.0) return 0.0;
    return cov / sqrt(var_x * var_y);
  }

  private double[] minMaxNormalize(double[] data) pure {
    if (data.length == 0) return [];
    
    double minVal = data[0];
    double maxVal = data[0];
    
    foreach(v; data[1..$]) {
      if (v < minVal) minVal = v;
      if (v > maxVal) maxVal = v;
    }
    
    double range = maxVal - minVal;
    if (range == 0.0) return new double[data.length];
    
    double[] result = new double[data.length];
    foreach(i, v; data) {
      result[i] = (v - minVal) / range;
    }
    return result;
  }

  private double[] standardizeVector(double[] data) pure {
    if (data.length < 2) return data;
    
    double mean = sum(data) / data.length;
    double var = 0.0;
    
    foreach(v; data) {
      double diff = v - mean;
      var += diff * diff;
    }
    var /= data.length;
    
    import std.math : sqrt;
    double std = sqrt(var);
    
    if (std == 0.0) return new double[data.length];
    
    double[] result = new double[data.length];
    foreach(i, v; data) {
      result[i] = (v - mean) / std;
    }
    return result;
  }

  private double[2][] createHistogram(double[] data, size_t bins) pure {
    if (data.length == 0) return [];
    
    auto sorted = data.dup;
    sort(sorted);
    
    double minVal = sorted[0];
    double maxVal = sorted[$-1];
    double binWidth = (maxVal - minVal) / bins;
    
    if (binWidth == 0.0) binWidth = 1.0;
    
    double[][] result = new double[][](bins, 2);
    size_t[] frequencies = new size_t[bins];
    
    foreach(v; data) {
      size_t binIdx = cast(size_t)((v - minVal) / binWidth);
      if (binIdx >= bins) binIdx = bins - 1;
      frequencies[binIdx]++;
    }
    
    foreach(i; 0 .. bins) {
      result[i][0] = minVal + (i + 0.5) * binWidth;
      result[i][1] = frequencies[i];
    }
    
    return result;
  }

  private static double sum(double[] data) pure {
    double result = 0.0;
    foreach(v; data) result += v;
    return result;
  }
}

/**
 * Model serving API for trained models
 */
@rootPath("/api/models")
class ModelServingAPI {

  /// Get model info
  @method(HTTPMethod.GET)
  @path("/:modelId")
  void getModel(HTTPServerRequest req, HTTPServerResponse res) {
    string modelId = req.params["modelId"];
    
    JSONValue result;
    result["id"] = modelId;
    result["status"] = "ready";
    
    res.writeJsonBody(result);
  }

  /// Make predictions
  @method(HTTPMethod.POST)
  @path("/:modelId/predict")
  void predict(HTTPServerRequest req, HTTPServerResponse res) {
    string modelId = req.params["modelId"];
    auto json = req.json;
    
    if ("data" !in json) {
      res.statusCode = 400;
      res.writeJsonBody(["error": "Missing 'data' field"]);
      return;
    }

    JSONValue result;
    result["model_id"] = modelId;
    result["predictions"] = JSONValue([]);
    
    res.writeJsonBody(result);
  }
}
