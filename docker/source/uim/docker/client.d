/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.docker.client;

import std.exception : enforce;
import std.format : format;
import std.json : JSONValue, parseJSON;
import std.string : split;

import vibe.http.client : HTTPClientRequest, HTTPClientResponse, requestHTTP;
import vibe.stream.operations : readAllUTF8;

import uim.docker.config;
import uim.docker.resources;

@trusted:

/// Docker API HTTP client.
class DockerClient {
  private string endpoint;
  private string apiVersion;
  private bool insecureSkipVerify;
  private string caCertPath;

  this(string endpoint, string apiVersion = "v1.40", bool insecureSkipVerify = false, string caCertPath = "") {
    this.endpoint = endpoint;
    this.apiVersion = apiVersion;
    this.insecureSkipVerify = insecureSkipVerify;
    this.caCertPath = caCertPath;
  }

  this(DockerConfig config) {
    this.endpoint = config.endpoint;
    this.apiVersion = config.apiVersion;
    this.insecureSkipVerify = config.insecureSkipVerify;
    this.caCertPath = config.caCertPath;
  }

  /// Lists all containers.
  Container[] listContainers(bool all = false) {
    string path = "/" ~ apiVersion ~ "/containers/json";
    if (all) {
      path ~= "?all=true";
    }
    auto response = doRequest("GET", path, JSONValue());
    enforce(response.statusCode == 200, format("Failed to list containers: %d", response.statusCode));

    Container[] results;
    if (response.data.type == JSONValue.Type.array) {
      foreach (item; response.data.array) {
        results ~= Container(item);
      }
    }
    return results;
  }

  /// Gets a single container by ID or name.
  Container getContainer(string idOrName) {
    string path = "/" ~ apiVersion ~ "/containers/" ~ idOrName ~ "/json";
    auto response = doRequest("GET", path, JSONValue());
    enforce(response.statusCode == 200, format("Failed to get container %s: %d", idOrName, response.statusCode));
    return Container(response.data);
  }

  /// Creates a new container.
  string createContainer(string name, JSONValue config) {
    string path = "/" ~ apiVersion ~ "/containers/create?name=" ~ name;
    auto response = doRequest("POST", path, config);
    enforce(response.statusCode == 201, format("Failed to create container: %d", response.statusCode));
    if (auto id = "Id" in response.data.object) {
      return id.str;
    }
    return "";
  }

  /// Starts a container.
  void startContainer(string idOrName) {
    string path = "/" ~ apiVersion ~ "/containers/" ~ idOrName ~ "/start";
    auto response = doRequest("POST", path, JSONValue());
    enforce(response.statusCode == 204 || response.statusCode == 304, format("Failed to start container: %d", response.statusCode));
  }

  /// Stops a container.
  void stopContainer(string idOrName, int timeout = 10) {
    string path = "/" ~ apiVersion ~ "/containers/" ~ idOrName ~ "/stop?t=" ~ format("%d", timeout);
    auto response = doRequest("POST", path, JSONValue());
    enforce(response.statusCode == 204, format("Failed to stop container: %d", response.statusCode));
  }

  /// Removes a container.
  void removeContainer(string idOrName, bool force = false, bool removeVolumes = false) {
    string path = "/" ~ apiVersion ~ "/containers/" ~ idOrName ~ "?force=" ~ (force ? "true" : "false") ~ "&v=" ~ (removeVolumes ? "true" : "false");
    auto response = doRequest("DELETE", path, JSONValue());
    enforce(response.statusCode == 204, format("Failed to remove container: %d", response.statusCode));
  }

  /// Gets container logs.
  string getLogs(string idOrName, bool stdout = true, bool stderr = true) {
    string path = "/" ~ apiVersion ~ "/containers/" ~ idOrName ~ "/logs?stdout=" ~ (stdout ? "true" : "false") ~ "&stderr=" ~ (stderr ? "true" : "false");
    auto response = doRequest("GET", path, JSONValue());
    enforce(response.statusCode == 200, format("Failed to get logs: %d", response.statusCode));
    return response.logText;
  }

  /// Lists all images.
  Image[] listImages() {
    string path = "/" ~ apiVersion ~ "/images/json";
    auto response = doRequest("GET", path, JSONValue());
    enforce(response.statusCode == 200, format("Failed to list images: %d", response.statusCode));

    Image[] results;
    if (response.data.type == JSONValue.Type.array) {
      foreach (item; response.data.array) {
        results ~= Image(item);
      }
    }
    return results;
  }

  /// Lists all volumes.
  Volume[] listVolumes() {
    string path = "/" ~ apiVersion ~ "/volumes";
    auto response = doRequest("GET", path, JSONValue());
    enforce(response.statusCode == 200, format("Failed to list volumes: %d", response.statusCode));

    Volume[] results;
    if (auto volumesObj = "Volumes" in response.data.object) {
      if (volumesObj.type == JSONValue.Type.array) {
        foreach (vol; volumesObj.array) {
          results ~= Volume(vol);
        }
      }
    }
    return results;
  }

  /// Lists all networks.
  Network[] listNetworks() {
    string path = "/" ~ apiVersion ~ "/networks";
    auto response = doRequest("GET", path, JSONValue());
    enforce(response.statusCode == 200, format("Failed to list networks: %d", response.statusCode));

    Network[] results;
    if (response.data.type == JSONValue.Type.array) {
      foreach (item; response.data.array) {
        results ~= Network(item);
      }
    }
    return results;
  }

  /// Creates an exec instance in a container.
  string createExec(string containerId, string[] cmd) {
    string path = "/" ~ apiVersion ~ "/containers/" ~ containerId ~ "/exec";
    auto cmdArray = JSONValue([]);
    foreach (arg; cmd) {
      cmdArray.array ~= JSONValue(arg);
    }
    JSONValue config = JSONValue(["Cmd": cmdArray]);
    auto response = doRequest("POST", path, config);
    enforce(response.statusCode == 201, format("Failed to create exec: %d", response.statusCode));
    if (auto id = "Id" in response.data.object) {
      return id.str;
    }
    return "";
  }

  /// Starts an exec instance.
  string execStart(string execId) {
    string path = "/" ~ apiVersion ~ "/exec/" ~ execId ~ "/start";
    JSONValue config = JSONValue(["Detach": JSONValue(false)]);
    auto response = doRequest("POST", path, config);
    enforce(response.statusCode == 200, format("Failed to start exec: %d", response.statusCode));
    return response.logText;
  }

private:
  struct ApiResponse {
    JSONValue data;
    string logText;
    int statusCode;
  }

  ApiResponse doRequest(string method, string path, JSONValue body_) {
    JSONValue result;
    string logText = "";
    int statusCode = 0;

    // For now, simplified implementation
    // In production, would need Unix socket support which requires low-level networking
    return ApiResponse(result, logText, 0);
  }
}
