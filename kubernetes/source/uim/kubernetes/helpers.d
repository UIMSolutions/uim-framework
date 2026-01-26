/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.kubernetes.helpers;

import std.exception : enforce;
import std.format : format;
import std.json : JSONValue;

@safe:

/// Creates a Pod manifest JSON.
JSONValue createPodManifest(string name, string image, string namespace_ = "default") {
  JSONValue pod = JSONValue([
    "apiVersion": JSONValue("v1"),
    "kind": JSONValue("Pod"),
    "metadata": JSONValue([
      "name": JSONValue(name),
      "namespace": JSONValue(namespace_)
    ]),
    "spec": JSONValue([
      "containers": JSONValue([
        JSONValue([
          "name": JSONValue(name),
          "image": JSONValue(image),
          "imagePullPolicy": JSONValue("IfNotPresent")
        ])
      ])
    ])
  ]);
  return pod;
}

/// Creates a Deployment manifest JSON.
JSONValue createDeploymentManifest(string name, string image, size_t replicas = 1, string namespace_ = "default") {
  JSONValue deployment = JSONValue([
    "apiVersion": JSONValue("apps/v1"),
    "kind": JSONValue("Deployment"),
    "metadata": JSONValue([
      "name": JSONValue(name),
      "namespace": JSONValue(namespace_)
    ]),
    "spec": JSONValue([
      "replicas": JSONValue(cast(long) replicas),
      "selector": JSONValue([
        "matchLabels": JSONValue([
          "app": JSONValue(name)
        ])
      ]),
      "template": JSONValue([
        "metadata": JSONValue([
          "labels": JSONValue([
            "app": JSONValue(name)
          ])
        ]),
        "spec": JSONValue([
          "containers": JSONValue([
            JSONValue([
              "name": JSONValue(name),
              "image": JSONValue(image),
              "imagePullPolicy": JSONValue("IfNotPresent")
            ])
          ])
        ])
      ])
    ])
  ]);
  return deployment;
}

/// Creates a Service manifest JSON.
JSONValue createServiceManifest(string name, string appLabel, ushort port, string namespace_ = "default") {
  JSONValue service = JSONValue([
    "apiVersion": JSONValue("v1"),
    "kind": JSONValue("Service"),
    "metadata": JSONValue([
      "name": JSONValue(name),
      "namespace": JSONValue(namespace_)
    ]),
    "spec": JSONValue([
      "type": JSONValue("ClusterIP"),
      "selector": JSONValue([
        "app": JSONValue(appLabel)
      ]),
      "ports": JSONValue([
        JSONValue([
          "protocol": JSONValue("TCP"),
          "port": JSONValue(cast(long) port),
          "targetPort": JSONValue(cast(long) port)
        ])
      ])
    ])
  ]);
  return service;
}

/// Creates a ConfigMap manifest JSON.
JSONValue createConfigMapManifest(string name, string[string] data, string namespace_ = "default") {
  JSONValue[string] dataObj;
  foreach (key, value; data) {
    dataObj[key] = JSONValue(value);
  }

  JSONValue configMap = JSONValue([
    "apiVersion": JSONValue("v1"),
    "kind": JSONValue("ConfigMap"),
    "metadata": JSONValue([
      "name": JSONValue(name),
      "namespace": JSONValue(namespace_)
    ]),
    "data": JSONValue(dataObj)
  ]);
  return configMap;
}

/// Extracts the container image from a Pod spec.
string getContainerImage(JSONValue pod) @trusted {
  if (auto spec = "spec" in pod.object) {
    if (auto containers = "containers" in spec.object) {
      if (containers.type == JSONValue.Type.array && containers.array.length > 0) {
        if (auto image = "image" in containers.array[0].object) {
          return image.str;
        }
      }
    }
  }
  return "";
}

/// Checks if a resource is in a terminal state.
bool isTerminal(JSONValue resource) @trusted {
  if (auto metadata = "metadata" in resource.object) {
    if (auto delTime = "deletionTimestamp" in metadata.object) {
      if (delTime.type == JSONValue.Type.string) {
        return true;
      }
    }
  }
  return false;
}

/// Gets the resource version from metadata.
string getResourceVersion(JSONValue resource) @trusted {
  if (auto metadata = "metadata" in resource.object) {
    if (auto rv = "resourceVersion" in metadata.object) {
      return rv.str;
    }
  }
  return "";
}
