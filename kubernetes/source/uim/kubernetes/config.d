/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.kubernetes.config;

import std.conv : to;
import std.exception : enforce;
import std.file : exists, readText;
import std.json : JSONValue, parseJSON;
import std.path : buildPath, expandTilde;

// Configuration for Kubernetes client authentication and API server access
struct KubernetesConfig {
  string apiServer;
  string token;
  bool insecureSkipVerify = false;
  string caCertPath = "";
}

/// Creates a config from in-cluster service account.
KubernetesConfig inClusterConfig() @trusted {
  enum saDir = "/var/run/secrets/kubernetes.io/serviceaccount";
  enum hostPath = saDir ~ "/ca.crt";
  enum tokenPath = saDir ~ "/token";

  string host = "https://kubernetes.default.svc.cluster.local:443";
  auto hostEnv = std.process.environment.get("KUBERNETES_SERVICE_HOST");
  auto portEnv = std.process.environment.get("KUBERNETES_SERVICE_PORT");
  if (hostEnv.length > 0 && portEnv.length > 0) {
    host = "https://" ~ hostEnv ~ ":" ~ portEnv;
  }

  enforce(exists(tokenPath), "Service account token not found: " ~ tokenPath);
  auto token = readText(tokenPath).strip();

  KubernetesConfig cfg;
  cfg.apiServer = host;
  cfg.token = token;
  if (exists(hostPath)) {
    cfg.caCertPath = hostPath;
  }
  return cfg;
}

/// Loads config from kubeconfig file (simplified; loads first context).
KubernetesConfig loadKubeconfig(string path = "") @trusted {
  if (path.length == 0) {
    path = expandTilde("~/.kube/config");
  }

  enforce(exists(path), "Kubeconfig not found: " ~ path);
  auto content = readText(path);
  auto json = parseJSON(content);

  // Find cluster and context
  string currentContext = json["current-context"].str;
  auto contexts = json["contexts"].array;
  JSONValue* activeCtx;
  foreach (ref ctx; contexts) {
    if (ctx["name"].str == currentContext) {
      activeCtx = &ctx;
      break;
    }
  }
  enforce(activeCtx !is null, "Current context not found");

  string clusterName = activeCtx.object["context"]["cluster"].str;
  auto clusters = json["clusters"].array;
  JSONValue* activeCluster;
  foreach (ref cls; clusters) {
    if (cls["name"].str == clusterName) {
      activeCluster = &cls;
      break;
    }
  }
  enforce(activeCluster !is null, "Cluster not found");

  KubernetesConfig cfg;
  cfg.apiServer = activeCluster.object["cluster"]["server"].str;
  cfg.insecureSkipVerify = activeCluster.object["cluster"].object.get("insecure-skip-tls-verify", JSONValue(false)).type == JSONValue.Type.true_;
  if (auto caCert = "certificate-authority" in activeCluster.object["cluster"].object) {
    cfg.caCertPath = caCert.str;
  }

  // For now, we skip bearer token extraction from kubeconfig; use in-cluster or explicit token
  return cfg;
}

import std.process : environment;
import std.string : strip;
