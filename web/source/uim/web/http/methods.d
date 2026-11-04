/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.http.methods;

import uim.web;

mixin(ShowModule!());

@safe:

/// HTTP request methods (RFC 9110)
enum HttpMethod {
  Get,
  Head,
  Post,
  Put,
  Delete,
  Connect,
  Options,
  Trace,
  Patch
}

/// Converts a method to its string representation, e.g. HttpMethod.Get -> "GET"
string toString(HttpMethod method) {
  final switch (method) {
    case HttpMethod.Get:
      return "GET";
    case HttpMethod.Head:
      return "HEAD";
    case HttpMethod.Post:
      return "POST";
    case HttpMethod.Put:
      return "PUT";
    case HttpMethod.Delete:
      return "DELETE";
    case HttpMethod.Connect:
      return "CONNECT";
    case HttpMethod.Options:
      return "OPTIONS";
    case HttpMethod.Trace:
      return "TRACE";
    case HttpMethod.Patch:
      return "PATCH";
  }
}

/// Parses a method string (case-insensitive), returns HttpMethod.Get for unknown values
HttpMethod parseHttpMethod(string method) {
  switch (method.toUpper) {
    case "GET":
      return HttpMethod.Get;
    case "HEAD":
      return HttpMethod.Head;
    case "POST":
      return HttpMethod.Post;
    case "PUT":
      return HttpMethod.Put;
    case "DELETE":
      return HttpMethod.Delete;
    case "CONNECT":
      return HttpMethod.Connect;
    case "OPTIONS":
      return HttpMethod.Options;
    case "TRACE":
      return HttpMethod.Trace;
    case "PATCH":
      return HttpMethod.Patch;
    default:
      return HttpMethod.Get;
  }
}

/// Checks whether a method string is a known HTTP method
bool isHttpMethod(string method) {
  return ["GET", "HEAD", "POST", "PUT", "DELETE", "CONNECT", "OPTIONS", "TRACE", "PATCH"]
    .canFind(method.toUpper);
}

/// Safe methods do not modify server state (RFC 9110)
bool isSafeMethod(HttpMethod method) {
  return [HttpMethod.Get, HttpMethod.Head, HttpMethod.Options, HttpMethod.Trace].canFind(method);
}

/// Idempotent methods can be repeated with the same effect (RFC 9110)
bool isIdempotentMethod(HttpMethod method) {
  return [HttpMethod.Get, HttpMethod.Head, HttpMethod.Put, HttpMethod.Delete,
    HttpMethod.Options, HttpMethod.Trace].canFind(method);
}

/// Methods that typically carry a request body
bool hasRequestBody(HttpMethod method) {
  return [HttpMethod.Post, HttpMethod.Put, HttpMethod.Patch].canFind(method);
}

///
unittest {
  assert(HttpMethod.Get.toString == "GET");
  assert(HttpMethod.Post.toString == "POST");
  assert(HttpMethod.Patch.toString == "PATCH");

  assert(parseHttpMethod("get") == HttpMethod.Get);
  assert(parseHttpMethod("POST") == HttpMethod.Post);
  assert(parseHttpMethod("patch") == HttpMethod.Patch);
  assert(parseHttpMethod("unknown") == HttpMethod.Get);

  assert(isHttpMethod("DELETE"));
  assert(isHttpMethod("options"));
  assert(!isHttpMethod("FOO"));

  assert(isSafeMethod(HttpMethod.Get));
  assert(isSafeMethod(HttpMethod.Head));
  assert(!isSafeMethod(HttpMethod.Post));
  assert(!isSafeMethod(HttpMethod.Delete));

  assert(isIdempotentMethod(HttpMethod.Get));
  assert(isIdempotentMethod(HttpMethod.Put));
  assert(isIdempotentMethod(HttpMethod.Delete));
  assert(!isIdempotentMethod(HttpMethod.Post));
  assert(!isIdempotentMethod(HttpMethod.Patch));

  assert(hasRequestBody(HttpMethod.Post));
  assert(hasRequestBody(HttpMethod.Put));
  assert(hasRequestBody(HttpMethod.Patch));
  assert(!hasRequestBody(HttpMethod.Get));
}
