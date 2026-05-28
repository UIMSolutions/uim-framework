/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.opf.models.resource;

import uim.opf;

mixin(ShowModule!());

@safe:

class UIMOPFResource : UIMObject, IOPFResource {
  private string _id;
  private OPFResourceType _resourceType = OPFResourceType.order;
  private string _status;
  private string _payload;
  private string[string] _metadata;

  this(string id = "", OPFResourceType resourceType = OPFResourceType.order, string status = "") {
    _id = id;
    _resourceType = resourceType;
    _status = status;
  }

  string id() {
    return _id;
  }

  IOPFResource id(string value) {
    _id = value;
    return this;
  }

  OPFResourceType resourceType() {
    return _resourceType;
  }

  IOPFResource resourceType(OPFResourceType value) {
    _resourceType = value;
    return this;
  }

  string status() {
    return _status;
  }

  IOPFResource status(string value) {
    _status = value;
    return this;
  }

  string payload() {
    return _payload;
  }

  IOPFResource payload(string value) {
    _payload = value;
    return this;
  }

  string[string] metadata() {
    return _metadata.dup;
  }

  IOPFResource metadata(string[string] value) {
    _metadata = value.dup;
    return this;
  }

  IOPFResource setMetadata(string key, string value) {
    if (key.length > 0) {
      _metadata[key] = value;
    }

    return this;
  }

  bool isValid() {
    return _id.length > 0;
  }
}

IOPFResource OPFResource(string id = "", OPFResourceType resourceType = OPFResourceType.order, string status = "") {
  return new UIMOPFResource(id, resourceType, status);
}

unittest {
  auto resource = OPFResource("ord-1", OPFResourceType.order, "OPEN")
    .payload("{\"reference\":\"PO-100\"}")
    .setMetadata("tenant", "demo");

  assert(resource.isValid());
  assert(resource.resourceType() == OPFResourceType.order);
  assert(resource.metadata()["tenant"] == "demo");
}
