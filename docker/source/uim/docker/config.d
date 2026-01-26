/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.docker.config;

import std.conv : to;
import std.exception : enforce;
import std.string : startsWith;

// Docker daemon connection configuration
struct DockerConfig {
  string endpoint;  // e.g., "unix:///var/run/docker.sock" or "http://127.0.0.1:2375"
  string apiVersion = "v1.40";
  bool insecureSkipVerify = false;
  string caCertPath = "";
}

/// Creates a config for local Unix socket connection (default).
DockerConfig defaultConfig() @safe {
  return DockerConfig("unix:///var/run/docker.sock", "v1.40");
}

/// Creates a config for TCP connection.
DockerConfig tcpConfig(string host = "127.0.0.1", ushort port = 2375) @safe {
  return DockerConfig("http://" ~ host ~ ":" ~ to!string(port), "v1.40");
}

/// Checks if endpoint is a Unix socket.
bool isUnixSocket(string endpoint) @safe {
  return endpoint.startsWith("unix://");
}

/// Extracts socket path from Unix endpoint.
string getUnixSocketPath(string endpoint) @safe {
  if (isUnixSocket(endpoint)) {
    return endpoint[7 .. $];  // Strip "unix://"
  }
  return "";
}

/// Checks if endpoint is TCP.
bool isTcpEndpoint(string endpoint) @safe {
  return endpoint.startsWith("http://") || endpoint.startsWith("https://");
}

/// Extracts TCP URL from endpoint.
string getTcpUrl(string endpoint) @safe {
  if (isTcpEndpoint(endpoint)) {
    return endpoint;
  }
  return "";
}
