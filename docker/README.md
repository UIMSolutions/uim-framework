# UIM Docker - Docker API Client for D + vibe.d

A lightweight Docker client for D. Query, create, and manage Docker containers, images, volumes, and networks via the Docker API using vibe.d.

## Features
- Docker API HTTP client with vibe.d
- Container lifecycle (list, create, start, stop, remove, logs)
- Image management (list, pull, remove)
- Volume and network operations
- Exec for running commands inside containers
- JSON serialization/deserialization for API responses

## Quick Start

### Connect to Docker daemon
```d
import uim.docker;

auto client = DockerClient("unix:///var/run/docker.sock");
auto containers = client.listContainers();
```

### List containers
```d
import uim.docker;

auto client = DockerClient("unix:///var/run/docker.sock");
auto containers = client.listContainers();
foreach (container; containers) {
  writefln("Container: %s (%s)", container.name, container.id[0..12]);
}
```

### Create and start a container
```d
import uim.docker;
import std.json : JSONValue;

auto client = DockerClient("unix:///var/run/docker.sock");
auto spec = JSONValue([
  "Image": JSONValue("nginx:latest"),
  "HostConfig": JSONValue(["PortBindings": JSONValue(["80/tcp": JSONValue([])])])
]);
auto containerId = client.createContainer("my-nginx", spec);
client.startContainer(containerId);
```

### Execute command in container
```d
import uim.docker;

auto client = DockerClient("unix:///var/run/docker.sock");
auto exec = client.createExec("container-id", ["ls", "-la", "/tmp"]);
auto output = client.execStart(exec);
```

### Get container logs
```d
import uim.docker;

auto client = DockerClient("unix:///var/run/docker.sock");
auto logs = client.getLogs("container-id");
```

## Modules
- `uim.docker.config` – Connection and authentication config
- `uim.docker.resources` – Container, image, volume, and network types
- `uim.docker.client` – Main HTTP client for Docker API
- `uim.docker.helpers` – Utility functions for manifests and conversions

## Notes
- Connects to Docker daemon via Unix socket (default) or TCP.
- In-cluster or Swarm mode not yet supported.
- Logs are streamed as JSON or plain text.
