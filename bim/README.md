# UIM-BIM - Building Information Modeling Library

**Version**: 1.0.0  
**Author**: Ozan Nurettin Süel (aka UIManufaktur)  
**License**: Apache 2.0  
**Language**: D

## Overview

UIM-BIM is a comprehensive Building Information Modeling (BIM) library for the D programming language, part of the UIM framework ecosystem. It provides object-oriented abstractions for creating, managing, and analyzing building models.

## Features

### Core Components

- **BIM Elements**: Base classes for all building elements
  - Properties and metadata management
  - GUID generation and tracking
  - Geometry representation

- **Building Elements**:
  - Walls (load-bearing, fire resistance)
  - Doors (single, double, sliding, fire-rated)
  - Windows (glazing types, U-values)
  - Slabs/Floors (various types and materials)
  - Columns (structural elements)
  - Beams (load-bearing elements)

- **Spatial Hierarchy**:
  - Projects
  - Sites
  - Buildings
  - Storeys/Floors
  - Spaces/Rooms

- **Materials**:
  - Material properties (thermal, density, cost)
  - Predefined materials (concrete, steel, brick)
  - Custom material definitions

- **Geometry**:
  - Box geometry
  - Cylinder geometry
  - Bounding boxes
  - Volume and surface area calculations

- **Properties**:
  - Property sets
  - Custom properties with units
  - Data type support

## Installation

Add to your `dub.sdl`:

```sdl
dependency "uim-bim" path="../bim"
```

Or in `dub.json`:

```json
{
  "dependencies": {
    "uim-bim": {"path": "../bim"}
  }
}
```

## Usage Examples

### Creating a Simple Building Model

```d
import uim.bim;

// Create a project
auto project = new DBIMProject("Office Building");

// Create a building
auto building = new DBIMBuilding();
building.name = "Main Building";
building.height = 30.0;

// Create a storey
auto storey = new DBIMStorey();
storey.name = "Ground Floor";
storey.elevation = 0.0;
building.addStorey(storey);

// Create a space
auto space = new DBIMSpace();
space.name = "Office 101";
space.spaceType = "Office";
space.area = 25.0;
space.volume = 75.0;
storey.addSpace(space);

// Add building to project
project.addBuilding(building);
```

### Creating Building Elements

```d
// Create a wall
auto wall = new DBIMWall();
wall.name = "External Wall North";
wall.height = 3.0;
wall.length = 5.0;
wall.isLoadBearing = true;
wall.fireResistance = "EI60";

// Add materials to wall
auto concrete = createConcrete();
wall.addMaterial(concrete, 0.20); // 20cm concrete

// Create a door
auto door = new DBIMDoor();
door.name = "Main Entrance";
door.width = 0.9;
door.height = 2.1;
door.openingType = "Single";
door.fireResistance = "EI30";

// Create a window
auto window = new DBIMWindow();
window.name = "Window 01";
window.width = 1.2;
window.height = 1.5;
window.glazingType = "Triple";
window.uValue = 0.8; // Better insulation
```

### Working with Properties

```d
// Add custom properties to an element
auto heightProp = new DBIMProperty("Height", Json(3.5), "m", "double");
wall.addProperty(heightProp);

// Create a property set
auto propSet = new DBIMPropertySet("Thermal Properties", "Physical");
auto uValueProp = new DBIMProperty("U-Value", Json(0.25), "W/(m²·K)");
propSet.addProperty(uValueProp);

// Retrieve property
auto height = wall.getProperty("Height");
writeln("Wall height: ", height.value.get!double, " ", height.unit);
```

### Working with Materials

```d
// Use predefined materials
auto concrete = createConcrete();
auto steel = createSteel();
auto brick = createBrick();

// Create custom material
auto customMaterial = new DBIMMaterial("Insulation");
customMaterial.density = 30.0;
customMaterial.thermalConductivity = 0.035;
customMaterial.costPerUnit = 45.0;
```

### Geometry Calculations

```d
// Box geometry for a room
auto roomGeom = new DBoxGeometry(5.0, 4.0, 3.0);
writeln("Room volume: ", roomGeom.volume, " m³");
writeln("Room surface area: ", roomGeom.surfaceArea, " m²");

// Cylinder geometry for a column
auto columnGeom = new DCylinderGeometry(0.3, 3.0);
writeln("Column volume: ", columnGeom.volume, " m³");

// Attach geometry to element
auto column = new DBIMColumn();
column.geometry = columnGeom;
```

### Hierarchical Structure

```d
auto project = new DBIMProject("Campus Development");

auto site = new DBIMSite();
site.address = "123 University Ave";
site.coordinates(40.7128, -74.0060);
site.siteArea = 50000.0; // m²
project.site = site;

auto building1 = new DBIMBuilding();
building1.name = "Academic Building A";
site.addChild(building1);

auto storey1 = new DBIMStorey();
storey1.name = "First Floor";
storey1.elevation = 4.0;
building1.addStorey(storey1);

// Traverse hierarchy
foreach (building; project.buildings) {
  foreach (storey; building.storeys) {
    foreach (space; storey.spaces) {
      writeln("Space: ", space.name);
    }
  }
}
```

## Architecture

### Interface Hierarchy

```
IObject (from UIM)
├── IBIMElement
│   ├── IBIMSpatialElement
│   │   ├── IBIMSite
│   │   ├── IBIMBuilding
│   │   ├── IBIMStorey
│   │   └── IBIMSpace
│   └── IBIMBuildingElement
│       ├── DBIMWall
│       ├── DBIMDoor
│       ├── DBIMWindow
│       ├── DBIMSlab
│       ├── DBIMColumn
│       └── DBIMBeam
├── IBIMProperty
├── IBIMMaterial
└── IBIMProject
```

### Module Structure

```
uim.bim
├── core          - Base classes and project management
├── elements      - Building elements (walls, doors, windows, etc.)
├── materials     - Material definitions and properties
├── geometry      - Geometric representations
├── properties    - Property sets and custom properties
└── interfaces    - All interface definitions
```

## Standards Compliance

This library is designed to support:
- IFC (Industry Foundation Classes) - data structure compatible
- Building SMART standards - element classification
- Energy modeling - thermal properties
- Cost estimation - material costs and quantities

## Future Enhancements

Planned features for future releases:
- IFC import/export
- Clash detection
- Quantity take-off
- Energy analysis integration
- Cost estimation tools
- 3D visualization support
- MEP (Mechanical, Electrical, Plumbing) elements
- Structural analysis integration

## Contributing

Contributions are welcome! Please ensure:
- Code follows D best practices
- Unit tests are included
- Documentation is updated
- Copyright headers are maintained

## License

Copyright © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)

Licensed under the Apache License, Version 2.0. See LICENSE file for details.

## Dependencies

- uim-oop - Object-oriented patterns
- uim-core - Core utilities
- uim-entities - Entity management

## Building

```bash
cd bim
dub build
dub test
```

## Contact

**Author**: Ozan Nurettin Süel (UIManufaktur)  
**Project**: UIM Framework  
**Year**: 2026
