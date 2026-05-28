/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.grpc.helpers.path;

import std.string : strip;

@safe:

string grpcNormalizeMethodPath(string methodPath) {
  auto value = methodPath.strip;
  if (value.length == 0) {
    return "";
  }

  while (value.length > 1 && value[$ - 1] == '/') {
    value = value[0 .. $ - 1];
  }

  if (value.length == 0 || value == "/") {
    return "";
  }

  return value[0] == '/' ? value : "/" ~ value;
}

string grpcBuildMethodPath(string serviceName, string methodName) {
  auto service = serviceName.strip;
  auto method = methodName.strip;
  if (service.length == 0 || method.length == 0) {
    return "";
  }

  while (service.length > 0 && service[0] == '/') {
    service = service[1 .. $];
  }

  while (method.length > 0 && method[0] == '/') {
    method = method[1 .. $];
  }

  if (service.length == 0 || method.length == 0) {
    return "";
  }

  return "/" ~ service ~ "/" ~ method;
}

bool grpcTrySplitMethodPath(string methodPath, out string serviceName, out string methodName) {
  serviceName = "";
  methodName = "";

  auto normalized = grpcNormalizeMethodPath(methodPath);
  if (normalized.length < 3) {
    return false;
  }

  auto slashIndex = -1;
  foreach (i, c; normalized) {
    if (i == 0) {
      continue;
    }
    if (c == '/') {
      slashIndex = cast(int) i;
      break;
    }
  }

  if (slashIndex <= 1 || slashIndex >= cast(int) normalized.length - 1) {
    return false;
  }

  serviceName = normalized[1 .. slashIndex];
  methodName = normalized[slashIndex + 1 .. $];
  return serviceName.length > 0 && methodName.length > 0;
}

unittest {
  assert(grpcNormalizeMethodPath("demo.Greeter/SayHello") == "/demo.Greeter/SayHello");
  assert(grpcNormalizeMethodPath("/demo.Greeter/SayHello/") == "/demo.Greeter/SayHello");

  assert(grpcBuildMethodPath("demo.Greeter", "SayHello") == "/demo.Greeter/SayHello");

  string serviceName;
  string methodName;
  assert(grpcTrySplitMethodPath("/demo.Greeter/SayHello", serviceName, methodName));
  assert(serviceName == "demo.Greeter");
  assert(methodName == "SayHello");
}
