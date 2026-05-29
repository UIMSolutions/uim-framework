/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.openapi.models.document;

import uim.openapi;

mixin(ShowModule!());

@safe:

class UIMOpenAPIDocument : UIMObject, IOpenAPIDocument {
  private string _raw;
  private OpenAPIVersion _version = OpenAPIVersion.unknown;
  private string _title;
  private string _documentVersion;
  private string[] _servers;
  private OpenAPIOperation[] _operations;

  string raw() {
    return _raw;
  }

  IOpenAPIDocument raw(string value) {
    _raw = value;
    return this;
  }

  OpenAPIVersion version_() {
    return _version;
  }

  IOpenAPIDocument version_(OpenAPIVersion value) {
    _version = value;
    return this;
  }

  string title() {
    return _title;
  }

  IOpenAPIDocument title(string value) {
    _title = value;
    return this;
  }

  string documentVersion() {
    return _documentVersion;
  }

  IOpenAPIDocument documentVersion(string value) {
    _documentVersion = value;
    return this;
  }

  string[] servers() {
    return _servers.dup;
  }

  IOpenAPIDocument servers(const(string)[] value) {
    _servers = value.dup;
    return this;
  }

  IOpenAPIDocument addServer(string value) {
    if (value.length > 0) {
      _servers ~= value;
    }

    return this;
  }

  OpenAPIOperation[] operations() {
    return _operations.dup;
  }

  IOpenAPIDocument operations(const(OpenAPIOperation)[] value) {
    _operations = value.dup;
    return this;
  }

  IOpenAPIDocument addOperation(OpenAPIOperation value) {
    if (value.path.length > 0 && value.method.length > 0) {
      _operations ~= value;
    }

    return this;
  }

  bool isValid() {
    return _version != OpenAPIVersion.unknown && _title.length > 0;
  }
}

IOpenAPIDocument OpenAPIDocument() {
  return new UIMOpenAPIDocument();
}

unittest {
  auto doc = OpenAPIDocument()
    .version_(OpenAPIVersion.v31)
    .title("Orders API")
    .documentVersion("1.0.0")
    .addServer("https://api.example.org")
    .addOperation(OpenAPIOperation("/orders", "get", "listOrders", "List orders"));

  assert(doc.isValid());
  assert(doc.operations().length == 1);
  assert(doc.servers().length == 1);
}
