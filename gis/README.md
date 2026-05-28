# Library uim-gis

Updated on 28. May 2026

uim-gis is a lightweight GIS library for D projects using vibe.d patterns. It provides typed geometry and feature models, extent queries, and asynchronous streaming helpers for map and geospatial workflows.

## Features

* Typed GIS contracts (`IGISFeature`, `IGISClient`)
* Geometry and extent types (`GISPoint`, `GISExtent`, `GISGeometryType`)
* Extent intersection and coordinate utility helpers
* In-memory GIS feature client with query operations
* Async feature streaming with vibe.d `runTask`

## Installation

Add this dependency to your dub.sdl:

```d
dependency "uim-framework:gis" version="*"
```

## Quick Start

```d
import std.stdio : writeln;
import uim.gis;

void main() {
  auto client = GISClient("memory://map");
  client.connect();

  auto feature = GISFeature(
    "road-1",
    GISGeometryType.lineString,
    [GISPoint(7.1, 50.7, 0), GISPoint(7.2, 50.8, 0)]
  ).setProperty("class", "primary");

  client.addFeature(feature);

  auto matches = client.queryByExtent(GISExtent(7.0, 50.6, 7.3, 50.9));
  foreach (m; matches) {
    writeln("feature=", m.id(), " type=", m.geometryType());
  }

  client.disconnect();
}
```

## Modules

* `uim.gis`: package entrypoint and re-exports
* `uim.gis.interfaces`: geometry/feature/client contracts
* `uim.gis.helpers`: extent calculations and intersection checks
* `uim.gis.models`: concrete GIS feature implementation
* `uim.gis.client`: GIS storage/query/stream orchestration

## Notes

* The default client is an in-memory implementation for service and integration layers.
* You can adapt the same interfaces for PostGIS, GeoJSON stores, or external GIS services.
