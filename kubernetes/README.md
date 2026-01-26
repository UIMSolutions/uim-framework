# UIM Kubernetes - Kubernetes API Client for D + vibe.d

A lightweight Kubernetes client for D. Query and manage K8s resources (Pods, Deployments, Services, etc.), watch for changes, and interact with the Kubernetes API via vibe.d HTTP.

## Features
- Kubernetes API HTTP client with vibe.d
- Common resource types (Pod, Deployment, Service, ConfigMap, Secret, StatefulSet)
- In-cluster and out-of-cluster authentication (service account tokens, kubeconfig)
- Watch functionality for real-time resource events
- JSON serialization/deserialization for K8s API responses

## Quick Start

### Initialize a client
```d
import uim.kubernetes;

auto client = KubernetesClient("https://kubernetes.default:443", "my-sa-token");
auto pods = client.listPods("default");
```

### Get a specific resource
```d
import uim.kubernetes;

auto client = KubernetesClient("https://kubernetes.default:443", "token");
auto pod = client.getPod("default", "my-pod");
writeln(pod.name);
```

### Create a resource
```d
import uim.kubernetes;
import std.json : JSONValue;

auto client = KubernetesClient(apiServer, token);
JSONValue podSpec = [
  "apiVersion": JSONValue("v1"),
  "kind": JSONValue("Pod"),
  "metadata": JSONValue(["name": JSONValue("test-pod")]),
  "spec": JSONValue([
    "containers": JSONValue([
      JSONValue(["name": JSONValue("app"), "image": JSONValue("nginx:latest")])
    ])
  ])
];
client.createResource("v1", "pods", "default", podSpec);
```

### Watch for events
```d
import uim.kubernetes;

auto client = KubernetesClient(apiServer, token);
auto watcher = client.watchPods("default");
while (auto event = watcher.next()) {
  writefln("Event: %s on %s", event.type, event.object["metadata"]["name"].str);
}
```

## Modules
- `uim.kubernetes.client` – HTTP client and API calls
- `uim.kubernetes.config` – Authentication and connection config
- `uim.kubernetes.resources` – Common resource definitions
- `uim.kubernetes.watch` – Watch stream handling
- `uim.kubernetes.helpers` – Utility functions

## Notes
- Intended for small to medium K8s operators and monitoring tools.
- Uses vibe.d for HTTP; all calls are blocking.
- TLS verification can be disabled (not recommended for production).
- In-cluster config auto-discovers the API server and token.
