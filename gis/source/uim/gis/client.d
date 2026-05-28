/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.gis.client;

import vibe.d : runTask;

import uim.gis;

mixin(ShowModule!());

@safe:

class UIMGISClient : UIMObject, IGISClient {
  private bool _connected;
  private string _endpoint;
  private IGISFeature[string] _features;

  this(string endpoint = "memory://gis") {
    _endpoint = endpoint;
  }

  bool connect() {
    _connected = true;
    return true;
  }

  bool disconnect() {
    if (!_connected) {
      return false;
    }

    _connected = false;
    return true;
  }

  bool connected() const {
    return _connected;
  }

  string endpoint() const {
    return _endpoint;
  }

  bool addFeature(IGISFeature feature) {
    if (!_connected || feature is null || feature.id().length == 0) {
      return false;
    }

    _features[feature.id()] = feature;
    return true;
  }

  IGISFeature featureById(string featureId) {
    if (auto found = featureId in _features) {
      return *found;
    }

    return null;
  }

  IGISFeature[] features() {
    IGISFeature[] result;
    foreach (_id, f; _features) {
      result ~= f;
    }

    return result;
  }

  IGISFeature[] queryByExtent(GISExtent extent) {
    IGISFeature[] result;
    foreach (_id, f; _features) {
      if (gisExtentIntersects(f.extent(), extent)) {
        result ~= f;
      }
    }

    return result;
  }

  IGISFeature[] queryByProperty(string key, string value) {
    IGISFeature[] result;
    if (key.length == 0) {
      return result;
    }

    foreach (_id, f; _features) {
      auto props = f.properties();
      if (key in props && props[key] == value) {
        result ~= f;
      }
    }

    return result;
  }

  bool streamByExtent(GISExtent extent, GISFeatureHandler handler) {
    if (!_connected || handler is null) {
      return false;
    }

    auto snapshot = queryByExtent(extent);
    foreach (f; snapshot) {
      auto localFeature = f;
      auto localHandler = handler;

      (() @trusted {
        runTask(() nothrow {
          try {
            localHandler(localFeature);
          } catch (Exception) {
          }
        });
      })();
    }

    return true;
  }
}

IGISClient GISClient(string endpoint = "memory://gis") {
  return new UIMGISClient(endpoint);
}

unittest {
  auto client = GISClient();
  assert(client.connect());

  auto a = GISFeature("a", GISGeometryType.point, [GISPoint(1, 1, 0)]).setProperty("type", "sensor");
  auto b = GISFeature("b", GISGeometryType.point, [GISPoint(100, 100, 0)]).setProperty("type", "asset");

  assert(client.addFeature(a));
  assert(client.addFeature(b));

  auto inArea = client.queryByExtent(GISExtent(0, 0, 10, 10));
  assert(inArea.length == 1);
  assert(inArea[0].id() == "a");

  auto sensors = client.queryByProperty("type", "sensor");
  assert(sensors.length == 1);

  assert(client.disconnect());
}
