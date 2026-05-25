/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/

# Library 📚 uim-bim

Updated on 25. May 2026

[![uim-bim](https://github.com/UIMSolutions/uim-framework/actions/workflows/uim-bim.yml/badge.svg)](https://github.com/UIMSolutions/uim-framework/actions/workflows/uim-bim.yml) [![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

A type-safe Building Information Modeling (BIM) data management library for D language applications, built on `uim-core`, `uim-oop`, and `vibe.d`. It follows the [IFC 4.3](https://standards.buildingsmart.org/IFC/RELEASE/IFC4_3/) conceptual model and supports JSON-serialisation, property sets, material definitions, and classification references.

---

## Overview

`uim-bim` provides the data layer for BIM workflows: authoring, exchanging, validating, and querying building models programmatically. The library is intentionally model-centric — it stores, traverses and serialises BIM data without requiring a heavy geometry kernel.

### BIM Hierarchy

```
IBimSite
 └── IBimBuilding
      └── IBimStorey
           ├── IBimSpace          (rooms, zones, parking bays …)
           └── IBimComponent      (walls, slabs, columns, beams, doors, windows …)
```

---

## Key Features

### Spatial Structure
- **Site** (`UIMBimSite`) — WGS84 geo-coordinates, land title number, address
- **Building** (`UIMBimBuilding`) — gross/net floor area, height, year of construction
- **Storey** (`UIMBimStorey`) — elevation, floor/ceiling heights, storey number
- **Space** (`UIMBimSpace`) — room number, area, volume, predefined type

### Building Components
| Class | IFC Entity |
|---|---|
| `UIMBimWall` | `IfcWall` |
| `UIMBimSlab` | `IfcSlab` |
| `UIMBimColumn` | `IfcColumn` |
| `UIMBimBeam` | `IfcBeam` |
| `UIMBimDoor` | `IfcDoor` |
| `UIMBimWindow` | `IfcWindow` |
| `UIMBimOpening` | `IfcOpeningElement` |
| `UIMBimStair` | `IfcStair` |
| `UIMBimRoof` | `IfcRoof` |

### Property & Material Management
- **`UIMBimProperty`** — typed name/value pair with unit of measure
- **`UIMBimPropertySet`** — named collection of properties (e.g. `Pset_WallCommon`)
- **`UIMBimMaterial`** — density, thermal conductivity, specific heat, colour
- **`UIMBimClassification`** — Uniclass 2015, OmniClass, MasterFormat, UniFormat, ETIM

### Geometry Primitives
- **`BimPoint3D`** — 3D Cartesian point (metres); arithmetic operators and distance helper
- **`BimPlacement`** — local placement with origin, axisZ, axisX, rotation
- **`BimBoundingBox`** — AABB with width/depth/height/volume and intersection test

### Developer Utilities
- **`BimFactory`** — fluent factory for creating all BIM entities in one line
- **`BimQuery`** — filter collections by IFC class, name fragment, classification code, or property key
- Full **JSON serialisation** (`toJson` / `fromJson`) on every entity
- All classes implement a **fluent setter chain** (`element.name("X").tag("Y")…`)

---

## Quick Start

```d
import uim.bim;

void main() {
  // Build a minimal site → building → storey → space model
  auto site = BimFactory.site("Alexanderplatz Campus")
    .latitude(52.5219)
    .longitude(13.4132)
    .elevation(34.0);

  auto building = BimFactory.building("Tower A")
    .yearOfConstruction("2026")
    .numberOfStoreys(12)
    .grossFloorArea(15_000.0);

  site.addBuildingId(building.globalId());

  auto groundFloor = BimFactory.storey("Ground Floor", 0)
    .elevation(0.0)
    .floorHeight(3.5)
    .netHeight(2.8)
    .grossArea(1_200.0);

  building.addStoreyId(groundFloor.globalId());

  auto lobby = BimFactory.space("Lobby")
    .spaceNumber("GF-01")
    .grossFloorArea(180.0)
    .netFloorArea(165.0)
    .netHeight(6.0);

  groundFloor.addSpaceId(lobby.globalId());

  // Add a wall with a property set
  auto wall = BimFactory.wall("West Facade Wall")
    .length(12.0)
    .height(3.5)
    .thickness(0.3)
    .isExternal(true)
    .isLoadBearing(true);

  auto pset = BimFactory.propertySet("Pset_WallCommon");
  pset.addProperty(BimFactory.property("IsExternal",   Json(true)));
  pset.addProperty(BimFactory.property("LoadBearing",  Json(true)));
  pset.addProperty(BimFactory.property("ThermalTransmittance", Json(0.25), "W/(m2K)"));

  // Classify the wall (Uniclass 2015)
  wall.addClassification("EF_25_10");

  // Serialise to JSON
  import std.stdio : writeln;
  writeln(wall.toJson().toPrettyString());
}
```

---

## Module Structure

```
source/uim/bim/
├── package.d               ← public re-export of all sub-modules
├── interfaces/             ← IBimElement, IBimSite, IBimBuilding, IBimStorey,
│   │                          IBimSpace, IBimComponent, IBimProperty,
│   │                          IBimPropertySet, IBimMaterial, IBimClassification
│   └── package.d
├── models/                 ← UIMBimElement (base), UIMBimSite, UIMBimBuilding,
│   │                          UIMBimStorey, UIMBimSpace
│   └── package.d
├── components/             ← UIMBimComponent (base), Wall, Slab, Column, Beam,
│   │                          Door, Window, Opening, Stair, Roof
│   └── package.d
├── properties/             ← UIMBimProperty, UIMBimPropertySet,
│   │                          UIMBimMaterial, UIMBimClassification
│   └── package.d
├── geometry/               ← BimPoint3D, BimPlacement, BimBoundingBox
│   └── package.d
└── helpers/                ← BimFactory, BimQuery
    └── package.d
```

---

## Dependencies

| Dependency | Version | Purpose |
|---|---|---|
| `vibe-d` | ~>0.10.3 | JSON, async I/O |
| `uim-framework:core` | * | Base types, mixins |
| `uim-framework:oop` | * | `UIMObject` base class |
| `uim-framework:jsons` | * | JSON helpers |

---

## License

Apache 2.0 — see [LICENSE](../LICENSE).
