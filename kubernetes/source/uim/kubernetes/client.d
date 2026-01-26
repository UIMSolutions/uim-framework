/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.kubernetes.client;

import std.exception : enforce;
import std.format : format;
import std.json : JSONValue, parseJSON;
import std.string : split;

import vibe.http.client : HTTPClientRequest, HTTPClientResponse, requestHTTP;
import vibe.stream.operations : readAllUTF8;

import uim.kubernetes.config;
import uim.kubernetes.resources;
import uim.kubernetes.watch;

@trusted:

/// Kubernetes API HTTP client.
class KubernetesClient {
  private string apiServer;
  private string token;
  private bool insecureSkipVerify;
  private string caCertPath;

  this(string apiServer, string token, bool insecureSkipVerify = false, string caCertPath = "") {
    this.apiServer = apiServer;
    this.token = token;
    this.insecureSkipVerify = insecureSkipVerify;
    this.caCertPath = caCertPath;
  }

  this(KubernetesConfig config) {
    this.apiServer = config.apiServer;
    this.token = config.token;
    this.insecureSkipVerify = config.insecureSkipVerify;
    this.caCertPath = config.caCertPath;
  }

  /// Lists resources of a given kind in a namespace.
  KubernetesResource[] listResources(string apiVersion, string kind, string namespace_) {
    string path = "/api/" ~ apiVersion ~ "/namespaces/" ~ namespace_ ~ "/" ~ kind;
    auto response = doRequest("GET", path, JSONValue());
    enforce(response.statusCode == 200, format("Failed to list %s: %d", kind, response.statusCode));

    auto items = response.data["items"].array;
    KubernetesResource[] results;
    foreach (item; items) {
      results ~= KubernetesResource(item);
    }
    return results;
  }

  /// Gets a single resource by name.
  KubernetesResource getResource(string apiVersion, string kind, string namespace_, string name) {
    string path = "/api/" ~ apiVersion ~ "/namespaces/" ~ namespace_ ~ "/" ~ kind ~ "/" ~ name;
    auto response = doRequest("GET", path, JSONValue());
    enforce(response.statusCode == 200, format("Failed to get %s %s: %d", kind, name, response.statusCode));
    return KubernetesResource(response.data);
  }

  /// Creates a new resource.
  KubernetesResource createResource(string apiVersion, string kind, string namespace_, JSONValue spec) {
    string path = "/api/" ~ apiVersion ~ "/namespaces/" ~ namespace_ ~ "/" ~ kind;
    auto response = doRequest("POST", path, spec);
    enforce(response.statusCode == 201, format("Failed to create %s: %d", kind, response.statusCode));
    return KubernetesResource(response.data);
  }

  /// Updates an existing resource.
  KubernetesResource updateResource(string apiVersion, string kind, string namespace_, string name, JSONValue spec) {
    string path = "/api/" ~ apiVersion ~ "/namespaces/" ~ namespace_ ~ "/" ~ kind ~ "/" ~ name;
    auto response = doRequest("PUT", path, spec);
    enforce(response.statusCode == 200, format("Failed to update %s %s: %d", kind, name, response.statusCode));
    return KubernetesResource(response.data);
  }

  /// Deletes a resource.
  void deleteResource(string apiVersion, string kind, string namespace_, string name) {
    string path = "/api/" ~ apiVersion ~ "/namespaces/" ~ namespace_ ~ "/" ~ kind ~ "/" ~ name;
    auto response = doRequest("DELETE", path, JSONValue());
    enforce(response.statusCode == 200 || response.statusCode == 202, format("Failed to delete %s %s: %d", kind, name, response.statusCode));
  }

  /// Lists Pods in a namespace.
  Pod[] listPods(string namespace_ = "default") {
    auto resources = listResources("v1", "pods", namespace_);
    Pod[] pods;
    foreach (res; resources) {
      pods ~= Pod(res);
    }
    return pods;
  }

  /// Gets a single Pod.
  Pod getPod(string namespace_, string name) {
    return Pod(getResource("v1", "pods", namespace_, name));
  }

  /// Lists Deployments in a namespace.
  Deployment[] listDeployments(string namespace_ = "default") {
    auto resources = listResources("apps/v1", "deployments", namespace_);
    Deployment[] deploys;
    foreach (res; resources) {
      deploys ~= Deployment(res);
    }
    return deploys;
  }

  /// Gets a single Deployment.
  Deployment getDeployment(string namespace_, string name) {
    return Deployment(getResource("apps/v1", "deployments", namespace_, name));
  }

  /// Lists Services in a namespace.
  Service[] listServices(string namespace_ = "default") {
    auto resources = listResources("v1", "services", namespace_);
    Service[] services;
    foreach (res; resources) {
      services ~= Service(res);
    }
    return services;
  }

  /// Gets a single Service.
  Service getService(string namespace_, string name) {
    return Service(getResource("v1", "services", namespace_, name));
  }

  /// Lists ConfigMaps in a namespace.
  ConfigMap[] listConfigMaps(string namespace_ = "default") {
    auto resources = listResources("v1", "configmaps", namespace_);
    ConfigMap[] cms;
    foreach (res; resources) {
      cms ~= ConfigMap(res);
    }
    return cms;
  }

  /// Gets a single ConfigMap.
  ConfigMap getConfigMap(string namespace_, string name) {
    return ConfigMap(getResource("v1", "configmaps", namespace_, name));
  }

  /// Watches for events on a resource kind.
  KubernetesWatcher watchResources(string apiVersion, string kind, string namespace_) {
    string path = "/api/" ~ apiVersion ~ "/watch/namespaces/" ~ namespace_ ~ "/" ~ kind;
    return KubernetesWatcher(this, path);
  }

  /// Watches Pods in a namespace.
  KubernetesWatcher watchPods(string namespace_ = "default") {
    return watchResources("v1", "pods", namespace_);
  }

private:
  struct ApiResponse {
    JSONValue data;
    int statusCode;
  }

  ApiResponse doRequest(string method, string path, JSONValue body_) {
    auto url = apiServer ~ path;

    JSONValue result;
    int statusCode = 0;

    requestHTTP(url,
      (scope HTTPClientRequest req) {
        req.method = parseHttpMethod(method);
        req.headers["Authorization"] = "Bearer " ~ token;
        req.headers["Content-Type"] = "application/json";
        if (insecureSkipVerify) {
          req.sslContext = null;
        }
        if (body_.type != JSONValue.Type.null_) {
          req.writeBody(body_.toString());
        }
      },
      (scope HTTPClientResponse res) {
        statusCode = res.statusCode;
        auto bodyStr = res.bodyReader.readAllUTF8();
        if (bodyStr.length > 0) {
          try {
            result = parseJSON(bodyStr);
          } catch (Exception) {
            result = JSONValue(bodyStr);
          }
        }
      }
    );

    return ApiResponse(result, statusCode);
  }

  import vibe.http.common : HTTPMethod;

  HTTPMethod parseHttpMethod(string method) {
    if (method == "GET") return HTTPMethod.GET;
    if (method == "POST") return HTTPMethod.POST;
    if (method == "PUT") return HTTPMethod.PUT;
    if (method == "DELETE") return HTTPMethod.DELETE;
    if (method == "PATCH") return HTTPMethod.PATCH;
    return HTTPMethod.GET;
  }
}
