/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/

# NAF v4 Architecture — UIM-BIM

**NATO Architecture Framework version 4 (NAFv4)** is a structured set of views describing an architecture from multiple perspectives. This document maps the `uim-bim` library to the six NAFv4 viewpoints.

---

## AV — All Views (Meta-Data & Overview)

### AV-1 Overview

| Attribute            | Value                                                            |
|----------------------|------------------------------------------------------------------|
| **Architecture Name**| UIM Building Information Modeling (BIM) Library                 |
| **Version**          | 26.x                                                             |
| **Date**             | 25 May 2026                                                      |
| **Author**           | Ozan Nurettin Süel                                               |
| **Status**           | Initial Release                                                  |
| **Language**         | D (dlang) 2.x                                                    |
| **Runtime**          | vibe.d 0.10.x, vibe-serialization 1.2.x                         |
| **Standard**         | ISO 16739-1:2018 (IFC 4.3)                                       |
| **Classification**   | Uniclass 2015, OmniClass, MasterFormat, UniFormat, ETIM          |

### AV-2 Integrated Dictionary

| Term              | Definition                                                                             |
|-------------------|----------------------------------------------------------------------------------------|
| **BIM**           | Building Information Modeling — digital representation of physical/functional building characteristics |
| **IFC**           | Industry Foundation Classes — open neutral data format for BIM exchange (ISO 16739)    |
| **IfcProduct**    | IFC base class for all physical entities                                               |
| **Site**          | Outermost spatial container (latitude/longitude/elevation)                              |
| **Building**      | A constructed asset on a site                                                          |
| **Storey**        | A horizontal section of a building at a defined elevation                              |
| **Space**         | A bounded volume with a specific function (room, corridor, shaft, etc.)                |
| **Component**     | A physical building element (wall, slab, column, beam, door, window, etc.)             |
| **PropertySet**   | A named collection of typed properties attached to any BIM element                     |
| **Material**      | Physical material definition with thermal and mechanical attributes                     |
| **Classification**| A reference to an external classification system (Uniclass, OmniClass, etc.)           |
| **Placement**     | Local coordinate system origin, X-axis, Z-axis, and rotation for an element            |
| **AABB**          | Axis-Aligned Bounding Box — used for spatial queries                                   |
| **globalId**      | Universally unique identifier (UUID) for a BIM element                                 |

---

## CV — Capability View

### CV-1 Capability Taxonomy

```
BIM Data Management
├── Spatial Structure Management
│   ├── Site Management          (UIMBimSite)
│   ├── Building Management      (UIMBimBuilding)
│   ├── Storey Management        (UIMBimStorey)
│   └── Space Management         (UIMBimSpace)
├── Building Component Management
│   ├── Structural Elements      (UIMBimColumn, UIMBimBeam, UIMBimSlab)
│   ├── Enclosure Elements       (UIMBimWall, UIMBimRoof)
│   ├── Opening Management       (UIMBimOpening, UIMBimDoor, UIMBimWindow)
│   └── Circulation Elements     (UIMBimStair)
├── Property & Material Management
│   ├── Property Sets            (UIMBimPropertySet, UIMBimProperty)
│   ├── Material Definitions     (UIMBimMaterial)
│   └── Classification Linking   (UIMBimClassification)
├── Geometric Representation
│   ├── Coordinate Points        (BimPoint3D)
│   ├── Local Placement          (BimPlacement)
│   └── Bounding Box Queries     (BimBoundingBox)
└── BIM Data Exchange
    ├── JSON Serialization        (toJson / fromJson on all entities)
    └── Factory Construction      (BimFactory)
```

### CV-2 Capability Dependencies

| Capability                  | Depends On                              |
|-----------------------------|-----------------------------------------|
| Building Component Mgmt     | Spatial Structure Management            |
| Property Set Mgmt           | Building Component Mgmt / Space Mgmt    |
| Material Definitions        | Building Component Mgmt                 |
| Classification Linking      | Any BIM Element                         |
| Bounding Box Queries        | Geometric Representation                |
| JSON Data Exchange          | All Model Classes                       |

---

## OV — Operational View

### OV-1 High-Level Operational Concept

The library supports a **data-centric BIM workflow**:

1. A `BimFactory` creates spatial containers (Site → Building → Storey → Space) and physical components (Wall, Slab, Column, …).  
2. Each entity carries a UUID `globalId` and maintains parent/child relationships through ID references, avoiding circular object graphs.  
3. Properties are attached via named `UIMBimPropertySet` instances (e.g., `Pset_WallCommon`), each containing typed `UIMBimProperty` values with units.  
4. Materials and Classifications are standalone objects referenced by ID, enabling reuse.  
5. The entire model is serializable to/from JSON for transport, storage, and IFC-JSON exchange.

### OV-2 Operational Node Connectivity

```
[BIM Consumer Application]
        |
        | uses
        v
[BimFactory] ──creates──> [UIMBimSite]
                                |
                          addBuildingId
                                |
                                v
                         [UIMBimBuilding]
                                |
                          addStoreyId
                                |
                                v
                         [UIMBimStorey]
                           |         |
                    addSpaceId  addComponentId
                           |         |
                    [UIMBimSpace] [UIMBimWall/Slab/…]
                                       |
                               materialId / classifications
                                       |
                         [UIMBimMaterial] / [UIMBimClassification]
```

### OV-5 Operational Activity Model

| Step | Activity                      | Actor              | Input                   | Output                     |
|------|-------------------------------|--------------------|-------------------------|----------------------------|
| 1    | Create site                   | BimFactory         | name, GPS coords        | UIMBimSite                 |
| 2    | Add buildings to site         | Developer          | UIMBimBuilding          | Site.buildingIds updated   |
| 3    | Define storeys                | BimFactory         | name, elevation         | UIMBimStorey               |
| 4    | Assign spaces to storey       | Developer          | UIMBimSpace             | Storey.spaceIds updated    |
| 5    | Create wall/slab/column…      | BimFactory         | type, dimensions        | UIMBimComponent subclass   |
| 6    | Attach property sets          | Developer          | UIMBimPropertySet       | Component.properties       |
| 7    | Assign material               | Developer          | UIMBimMaterial.globalId | Component.materialId       |
| 8    | Link classifications          | Developer          | system + code + label   | UIMBimClassification       |
| 9    | Serialise to JSON             | toJson()           | model graph             | Json object                |
| 10   | Deserialise from JSON         | fromJson()         | Json object             | Reconstructed model graph  |

---

## SV — Systems View

### SV-1 Systems Interface Description

```
┌─────────────────────────────────────────────────────────┐
│                   uim-bim (this library)                │
│                                                         │
│  ┌──────────────┐   ┌──────────────┐  ┌─────────────┐  │
│  │  Interfaces  │   │    Models    │  │  Components │  │
│  │  IBimElement │──>│ UIMBimSite   │  │ UIMBimWall  │  │
│  │  IBimSite    │   │ UIMBimBldg   │  │ UIMBimSlab  │  │
│  │  IBimBuilding│   │ UIMBimStorey │  │ UIMBimDoor  │  │
│  │  IBimStorey  │   │ UIMBimSpace  │  │ UIMBimWindow│  │
│  │  IBimSpace   │   └──────────────┘  │ UIMBimStair │  │
│  │  IBimCompnt  │                     └─────────────┘  │
│  └──────────────┘                                       │
│                                                         │
│  ┌──────────────┐   ┌──────────────┐  ┌─────────────┐  │
│  │  Properties  │   │   Geometry   │  │   Helpers   │  │
│  │  Property    │   │  BimPoint3D  │  │ BimFactory  │  │
│  │  PropertySet │   │  BimPlacmnt  │  │ BimQuery    │  │
│  │  Material    │   │  BimBBox     │  └─────────────┘  │
│  │  Classifctn  │   └──────────────┘                   │
│  └──────────────┘                                       │
└──────────────────────┬──────────────────────────────────┘
                       │ depends on
         ┌─────────────┼──────────────────┐
         v             v                  v
    uim-core      uim-oop            vibe-d / vibe-serialization
    (UIMObject,   (base classes,      (Json, serialization)
     mixins)       patterns)
```

### SV-4 Systems Functionality Description

| Module               | Responsibility                                                        |
|----------------------|-----------------------------------------------------------------------|
| `uim.bim.interfaces` | Define typed contracts; enable mocking/testing against interfaces     |
| `uim.bim.models`     | Spatial hierarchy: Site, Building, Storey, Space                      |
| `uim.bim.components` | Physical elements: Wall, Slab, Column, Beam, Door, Window, Opening, Stair, Roof |
| `uim.bim.properties` | Property / PropertySet / Material / Classification data               |
| `uim.bim.geometry`   | BimPoint3D, BimPlacement, BimBoundingBox value types                  |
| `uim.bim.helpers`    | BimFactory (construction) and BimQuery (filtering) utilities          |

### SV-6 Systems Data Exchange Matrix

| Data Exchange           | Format  | Direction        | Description                             |
|-------------------------|---------|------------------|-----------------------------------------|
| BIM element serialise   | JSON    | Library → Host   | `element.toJson()` returns vibe.d `Json`|
| BIM element deserialise | JSON    | Host → Library   | `element.fromJson(json)` populates model|
| Property set attach     | In-proc | Host → Element   | `addProperty()` on `UIMBimPropertySet`  |
| Classification link     | In-proc | Host → Element   | `addClassification(code)` on element    |
| Factory construction    | In-proc | Host → Library   | `BimFactory.wall("name")` etc.          |
| Collection query        | In-proc | Host → Library   | `BimQuery.byIfcClass(elements, "IfcWall")` |

---

## TV — Technical Standards View

### TV-1 Technical Standards Profile

| Standard / Specification           | Version    | Applicable To                              |
|------------------------------------|------------|--------------------------------------------|
| ISO 16739-1 (IFC)                  | 4.3 (2021) | Entity naming, predefined types, hierarchy |
| buildingSMART IFC-JSON             | 1.0        | JSON serialisation schema                  |
| Uniclass 2015                      | 2023       | Classification system (UK)                 |
| OmniClass                          | 2012       | Classification system (North America)      |
| MasterFormat                       | 2020       | Work results classification                |
| UniFormat                          | 2010       | Functional element classification          |
| ETIM International                 | 9.0        | Technical product classification           |
| WGS 84                             | G1762      | Geodetic coordinate system for sites       |
| D Language Specification           | 2.x        | Implementation language                    |
| vibe.d                             | 0.10.3     | Async I/O and JSON runtime                 |
| vibe-serialization                 | 1.2.x      | JSON (de)serialization                     |
| Apache 2.0 License                 | 2.0        | Licensing                                  |

### TV-2 Technology Forecast

| Technology             | Status    | Notes                                                      |
|------------------------|-----------|------------------------------------------------------------|
| IFC 4.3 Alignment      | Adopted   | Entity class names follow IfcXxx conventions               |
| IFC-JSON export        | Planned   | Full buildingSMART IFC-JSON schema export                  |
| vibe.d HTTP REST API   | Planned   | RESTful BIM model server via uim-framework:services        |
| OData query interface  | Planned   | Integration with uim-framework:odata for BIM queries       |
| Geometry kernel        | Future    | Full parametric geometry via external lib (e.g. OCCT)      |
| COBie export           | Future    | Construction Operations Building Information Exchange       |

---

## L — Logical Layer (Supplementary)

### L-1 Logical Data Model

```
Site (1) ──< Building (1) ──< Storey (1) ──< Space
                                     └──────< Component
                                                  |
                                        +---------+----------+
                                        |                    |
                                  PropertySet            Material
                                        |
                                   Property (*)

Component / Space / Element
     └── Classification (*)     [system, edition, code, label]
```

All relationships are maintained as arrays of `globalId` strings (foreign-key style) rather than object references, which:
- Prevents circular ownership graphs  
- Enables safe JSON round-tripping  
- Supports distributed/sparse model loading  

### L-2 Type Hierarchy

```
UIMObject (uim-oop)
  └── UIMBimElement          [IBimElement]
        ├── UIMBimSite        [IBimSite]
        ├── UIMBimBuilding    [IBimBuilding]
        ├── UIMBimStorey      [IBimStorey]
        ├── UIMBimSpace       [IBimSpace]
        └── UIMBimComponent   [IBimComponent]
              ├── UIMBimWall
              ├── UIMBimSlab
              ├── UIMBimColumn
              ├── UIMBimBeam
              ├── UIMBimDoor
              ├── UIMBimWindow
              ├── UIMBimOpening
              ├── UIMBimStair
              └── UIMBimRoof

(struct) BimPoint3D
(struct) BimPlacement
(struct) BimBoundingBox

(class)  UIMBimMaterial        [IBimMaterial]
(class)  UIMBimPropertySet     [IBimPropertySet]
(class)  UIMBimProperty        [IBimProperty]
(class)  UIMBimClassification  [IBimClassification]

(struct) BimFactory            — construction helper
(struct) BimQuery              — query/filter helper
```
