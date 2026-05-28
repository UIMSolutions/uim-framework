/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.opf.service;

import vibe.d : runTask;

import uim.opf;

mixin(ShowModule!());

@safe:

class UIMOPFService : UIMObject, IOPFService {
  private bool _connected;
  private string _baseUrl;
  private IOPFResource[string] _resources;

  bool connect(string baseUrl) {
    if (baseUrl.length == 0) {
      return false;
    }

    _baseUrl = baseUrl;
    _connected = true;
    return true;
  }

  bool disconnect() {
    if (!_connected) {
      return false;
    }

    _connected = false;
    _baseUrl = "";
    return true;
  }

  bool connected() const {
    return _connected;
  }

  string baseUrl() const {
    return _baseUrl;
  }

  bool upsertResource(IOPFResource resource) {
    if (!_connected || resource is null || !resource.isValid()) {
      return false;
    }

    _resources[resource.id()] = resource;
    return true;
  }

  IOPFResource resourceById(string resourceId) {
    if (auto found = resourceId in _resources) {
      return *found;
    }

    return null;
  }

  IOPFResource[] resources() {
    IOPFResource[] result;
    foreach (_id, value; _resources) {
      result ~= value;
    }

    return result;
  }

  IOPFResource[] resourcesByType(OPFResourceType value) {
    IOPFResource[] result;
    foreach (_id, item; _resources) {
      if (item.resourceType() == value) {
        result ~= item;
      }
    }

    return result;
  }

  OPFApiResponse request(OPFHttpMethod method, string path, string body = "", string[string] headers = null) {
    OPFApiResponse response;

    if (!_connected) {
      response.statusCode = 503;
      response.body = "{\"error\":\"service_not_connected\"}";
      return response;
    }

    response.statusCode = 200;
    response.headers = headers.dup;
    response.headers["X-OPF-Method"] = opfMethodToString(method);
    response.headers["X-OPF-Url"] = opfBuildUrl(_baseUrl, path);
    response.body = body.length > 0 ? body : "{}";

    return response;
  }

  bool requestAsync(OPFHttpMethod method, string path, OPFResponseHandler handler, string body = "", string[string] headers = null) {
    if (!_connected || handler is null) {
      return false;
    }

    auto response = request(method, path, body, headers);
    auto localHandler = handler;

    (() @trusted {
      runTask(() nothrow {
        try {
          localHandler(response);
        } catch (Exception) {
        }
      });
    })();

    return true;
  }
}

IOPFService OPFService() {
  return new UIMOPFService();
}

unittest {
  auto service = OPFService();
  assert(service.connect("https://api.openlogisticsfoundation.org"));

  auto resource = OPFResource("ord-1", OPFResourceType.order, "OPEN")
    .payload("{\"reference\":\"PO-100\"}");

  assert(service.upsertResource(resource));
  assert(service.resourcesByType(OPFResourceType.order).length == 1);

  auto resp = service.request(OPFHttpMethod.get, "/orders/ord-1");
  assert(resp.statusCode == 200);
  assert(resp.headers["X-OPF-Method"] == "GET");

  assert(service.disconnect());
}
