/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.docker.helpers;

import std.json : JSONValue;

@safe:

/// Creates a container config for a simple image run.
JSONValue createContainerConfig(string image, string[] cmd = [], string[] env = []) {
  JSONValue[] cmdArray;
  foreach (c; cmd) {
    cmdArray ~= JSONValue(c);
  }

  JSONValue[] envArray;
  foreach (e; env) {
    envArray ~= JSONValue(e);
  }

  JSONValue config = JSONValue([
    "Image": JSONValue(image),
    "Cmd": JSONValue(cmdArray),
    "Env": JSONValue(envArray)
  ]);
  return config;
}

/// Creates port bindings for container.
JSONValue createPortBindings(string[string] portMap) {
  JSONValue[string] bindings;
  foreach (containerPort, hostPort; portMap) {
    bindings[containerPort] = JSONValue([
      JSONValue([
        "HostPort": JSONValue(hostPort)
      ])
    ]);
  }
  return JSONValue(bindings);
}

/// Creates volume mounts for container.
JSONValue createVolumeMounts(string[string] mounts) {
  JSONValue[] volumeList;
  foreach (containerPath, hostPath; mounts) {
    volumeList ~= JSONValue([
      "Source": JSONValue(hostPath),
      "Target": JSONValue(containerPath),
      "ReadOnly": JSONValue(false)
    ]);
  }
  return JSONValue(volumeList);
}

/// Creates environment variables from map.
string[] createEnvArray(string[string] env) {
  string[] result;
  foreach (key, value; env) {
    result ~= key ~ "=" ~ value;
  }
  return result;
}

/// Creates a volume creation config.
JSONValue createVolumeConfig(string name, string driver = "local") {
  JSONValue config = JSONValue([
    "Name": JSONValue(name),
    "Driver": JSONValue(driver)
  ]);
  return config;
}

/// Creates a network creation config.
JSONValue createNetworkConfig(string name, string driver = "bridge") {
  JSONValue config = JSONValue([
    "Name": JSONValue(name),
    "Driver": JSONValue(driver)
  ]);
  return config;
}

/// Parses image reference into components.
struct ImageRef {
  string registry;
  string repository;
  string tag;

  string toString() const {
    string result;
    if (registry.length > 0) {
      result ~= registry ~ "/";
    }
    result ~= repository;
    if (tag.length > 0) {
      result ~= ":" ~ tag;
    }
    return result;
  }
}

/// Parses an image reference string.
ImageRef parseImageRef(string imageRef) @safe {
  ImageRef result;
  result.tag = "latest";

  size_t tagIdx = imageRef.length;
  size_t colonIdx = imageRef.length - 1;
  for (ptrdiff_t i = cast(ptrdiff_t)imageRef.length - 1; i >= 0; --i) {
    if (imageRef[i] == ':') {
      colonIdx = i;
      break;
    }
    if (imageRef[i] == '/') {
      colonIdx = imageRef.length;
      break;
    }
  }

  if (colonIdx < imageRef.length && imageRef[colonIdx] == ':') {
    result.tag = imageRef[colonIdx + 1 .. $];
    imageRef = imageRef[0 .. colonIdx];
  }

  size_t slashIdx = imageRef.length;
  for (ptrdiff_t i = cast(ptrdiff_t)imageRef.length - 1; i >= 0; --i) {
    if (imageRef[i] == '/') {
      slashIdx = i;
      break;
    }
  }

  if (slashIdx > 0 && imageRef[0 .. slashIdx].indexOf('/') != -1) {
    result.registry = imageRef[0 .. slashIdx];
    result.repository = imageRef[slashIdx + 1 .. $];
  } else if (slashIdx < imageRef.length) {
    result.registry = imageRef[0 .. slashIdx];
    result.repository = imageRef[slashIdx + 1 .. $];
  } else {
    result.repository = imageRef;
  }

  return result;
}

private size_t indexOf(string str, char c) @safe {
  for (size_t i = 0; i < str.length; ++i) {
    if (str[i] == c) {
      return i;
    }
  }
  return str.length;
}
