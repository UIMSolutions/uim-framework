/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.domain.enumerations.httpmethod;

import uim.service;

mixin(ShowModule!());

@safe:

/// HTTP method used during destination health checks or probing.
enum HttpMethod {
  get_ = "GET",
  post_ = "POST",
  put_ = "PUT",
  delete_ = "DELETE",
  patch_ = "PATCH",
  head_ = "HEAD",
  options_ = "OPTIONS",
}
HttpMethod toHttpMethod(string value) {
  switch (value.toLower()) {
    case "get": return HttpMethod.get_;
    case "post": return HttpMethod.post_;
    case "put": return HttpMethod.put_;
    case "delete": return HttpMethod.delete_;
    case "patch": return HttpMethod.patch_;
    case "head": return HttpMethod.head_;
    case "options": return HttpMethod.options_;
    default: return HttpMethod.get_; // default
  }
}
HttpMethod[] toHttpMethods(string[] values)
  => values.map!toHttpMethod.array;
string toString(HttpMethod method)
  => cast(string)method;
string[] toString(HttpMethod[] methods)
  => methods.map!toString.array;
///
unittest {
  mixin(ShowTest!("HttpMethod Enum"));    

  assert(HttpMethod.get_.toString == "GET");
  assert(HttpMethod.post_.toString == "POST");  
  assert(HttpMethod.put_.toString == "PUT");
  assert(HttpMethod.delete_.toString == "DELETE");
  assert(HttpMethod.patch_.toString == "PATCH");
  assert(HttpMethod.head_.toString == "HEAD");
  assert(HttpMethod.options_.toString == "OPTIONS");

  assert("get".toHttpMethod == HttpMethod.get_);
  assert("post".toHttpMethod == HttpMethod.post_);
  assert("put".toHttpMethod == HttpMethod.put_);
  assert("delete".toHttpMethod == HttpMethod.delete_);
  assert("patch".toHttpMethod == HttpMethod.patch_);
  assert("head".toHttpMethod == HttpMethod.head_);
  assert("options".toHttpMethod == HttpMethod.options_);

  assert(["get", "post", "put", "delete", "patch", "head", "options"].toHttpMethods == [HttpMethod.get_, HttpMethod.post_, HttpMethod.put_, HttpMethod.delete_, HttpMethod.patch_, HttpMethod.head_, HttpMethod.options_]);
  assert([HttpMethod.get_, HttpMethod.post_, HttpMethod.put_, HttpMethod.delete_, HttpMethod.patch_, HttpMethod.head_, HttpMethod.options_].toString == ["GET", "POST", "PUT", "DELETE", "PATCH", "HEAD", "OPTIONS"]);
}