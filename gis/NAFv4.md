# NAF v4 Architecture - UIM-GIS

This document maps uim-gis capabilities to NATO Architecture Framework v4 viewpoints.

## AV - All Views

### AV-1 Overview

| Attribute | Value |
| --- | --- |
| Architecture Name | UIM GIS Library |
| Version | 26.x |
| Date | 28 May 2026 |
| Language | D (dlang) |
| Runtime | vibe.d |
| Domain | Geospatial feature modeling and querying |
| License | Apache-2.0 |
| Status | Initial Release |

### AV-2 Integrated Dictionary

| Term | Definition |
| --- | --- |
| GIS | Geographic Information System |
| Feature | Spatial object with geometry and properties |
| Extent | Axis-aligned spatial bounding box |
| Geometry Type | Kind of geospatial shape (point, line, polygon, etc.) |
| Spatial Query | Selection of features by geometric predicates |

## CV - Capability View

### CV-1 Capability Taxonomy

```text
Geospatial Data Handling
|- Feature Management
|  |- add and retrieve features
|  |- feature property metadata
|- Spatial Operations
|  |- compute feature extents
|  |- extent intersection checks
|- Query Engine
|  |- query by extent
|  |- query by property
|- Async Delivery
   |- stream features with runTask callbacks
```

### CV-2 Capability Dependencies

| Capability | Depends On |
| --- | --- |
| Async feature stream | vibe.d runTask |
| Spatial predicates | GIS helper algorithms |
| Typed geospatial model | GIS interfaces and enums |
| Query orchestration | in-memory feature registry |

## OV - Operational View

### OV-1 Operational Concept

1. Application creates a GIS client and opens a session.
2. Application inserts geospatial features with geometry and attributes.
3. Application performs extent/property queries.
4. Application can stream matching features asynchronously for downstream handling.

### OV-5 Activity Model

| Step | Activity | Input | Output |
| --- | --- | --- | --- |
| 1 | Connect session | endpoint | active GIS client |
| 2 | Add feature | geometry + properties | feature store update |
| 3 | Spatial query | extent | matching features |
| 4 | Attribute query | key/value | filtered feature list |
| 5 | Async stream | extent + handler | callback dispatch events |

## SV - Systems View

### SV-1 Systems Interface Description

```text
+---------------------------+
| Application Layer         |
| - mapping and analytics   |
+-------------+-------------+
              |
              v
+---------------------------+
| uim.gis                   |
| - interfaces              |
| - feature model           |
| - geo helpers             |
| - query client            |
+-------------+-------------+
              |
              v
+---------------------------+
| vibe.d runtime            |
| - runTask scheduling      |
+---------------------------+
```

### SV-4 Function Mapping

| Module | Function |
| --- | --- |
| uim.gis.interfaces.geometry | GIS contracts, enums, and primitive structs |
| uim.gis.models.feature | Concrete feature implementation |
| uim.gis.helpers.geo | Extent/containment/intersection helpers |
| uim.gis.client | In-memory GIS client and query orchestration |

## TV - Technical View

### TV-1 Standards Profile

| Standard / Technology | Version | Use |
| --- | --- | --- |
| D Language | 2.x | implementation language |
| vibe.d | 0.10.x | async task dispatch |
| Bounding Box Query Pattern | common GIS technique | extent-based spatial filtering |

### TV-2 Technical Roadmap

| Item | Status | Description |
| --- | --- | --- |
| Feature model | Implemented | Geometry + property representation |
| Extent query | Implemented | Bounding-box intersection query |
| Async streaming | Implemented | Non-blocking callback flow |
| GeoJSON codec | Planned | Serialization/deserialization layer |
| Database adapter | Planned | PostGIS and external GIS integration |

## L - Logical Model

### L-1 Logical Data Model

```text
IGISFeature
  |- id: string
  |- geometryType: GISGeometryType
  |- coordinates: GISPoint[]
  |- properties: string[string]
  |- extent: GISExtent

GISExtent
  |- minX: double
  |- minY: double
  |- maxX: double
  |- maxY: double
```

### L-2 Constraints

* Feature insertion requires active client connection.
* Feature IDs are required for indexing and retrieval.
* Spatial selection uses axis-aligned extent intersection.
* Async stream handlers are isolated from runtime exceptions.
