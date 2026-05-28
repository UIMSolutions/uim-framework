/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.opf.helpers.http;

import std.string : strip;

import uim.opf.interfaces.api;

@safe:

string opfMethodToString(OPFHttpMethod method) {
  final switch (method) {
    case OPFHttpMethod.get: return "GET";
    case OPFHttpMethod.post: return "POST";
    case OPFHttpMethod.put: return "PUT";
    case OPFHttpMethod.patch: return "PATCH";
    case OPFHttpMethod.delete_: return "DELETE";
  }
}

string opfNormalizePath(string path) {
  auto value = path.strip();
  if (value.length == 0) {
    return "/";
  }

  if (value[0] != '/') {
    value = "/" ~ value;
  }

  return value;
}

string opfBuildUrl(string baseUrl, string path) {
  auto base = baseUrl.strip();
  if (base.length == 0) {
    return opfNormalizePath(path);
  }

  while (base.length > 0 && base[$ - 1] == '/') {
    base = base[0 .. $ - 1];
  }

  return base ~ opfNormalizePath(path);
}

unittest {
  assert(opfMethodToString(OPFHttpMethod.patch) == "PATCH");
  assert(opfNormalizePath("orders") == "/orders");
  assert(opfBuildUrl("https://api.example.org/", "orders") == "https://api.example.org/orders");
}
