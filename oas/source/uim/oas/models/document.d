/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oas.models.document;

import uim.oas;

mixin(ShowModule!());

@safe:

class UIMOASDocument : UIMObject, IOASDocument {
  private string _raw;
  private OASVersion _version = OASVersion.unknown;
  private string _title;
  private string _documentVersion;
  private OASEndpoint[] _endpoints;

  string raw() {
    return _raw;
  }

  IOASDocument raw(string value) {
    _raw = value;
    return this;
  }

  OASVersion version_() {
    return _version;
  }

  IOASDocument version_(OASVersion value) {
    _version = value;
    return this;
  }

  string title() {
    return _title;
  }

  IOASDocument title(string value) {
    _title = value;
    return this;
  }

  string documentVersion() {
    return _documentVersion;
  }

  IOASDocument documentVersion(string value) {
    _documentVersion = value;
    return this;
  }

  OASEndpoint[] endpoints() {
    return _endpoints.dup;
  }

  IOASDocument endpoints(const(OASEndpoint)[] value) {
    _endpoints = value.dup;
    return this;
  }

  IOASDocument addEndpoint(OASEndpoint endpoint) {
    _endpoints ~= endpoint;
    return this;
  }

  bool isValid() {
    return _version != OASVersion.unknown && _title.length > 0;
  }
}

IOASDocument OASDocument() {
  return new UIMOASDocument();
}

unittest {
  auto d = OASDocument()
    .version_(OASVersion.v31)
    .title("Logistics API")
    .documentVersion("1.0.0")
    .addEndpoint(OASEndpoint("/orders", "get", "list"));

  assert(d.isValid());
  assert(d.endpoints().length == 1);
}
