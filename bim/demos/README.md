# BIM Examples

This directory contains practical examples demonstrating the UIM BIM library functionality.

## Available Examples

### 1. simple_building.d
Demonstrates basic building information modeling:
- Creating a building with multiple storeys (floors)
- Adding spaces/rooms to each storey
- Setting space properties (area, volume, occupancy)
- Navigating the building hierarchy
- Calculating building metrics

**Run with:**
```bash
dmd -i simple_building.d -I../source
./simple_building
```

### 2. building_elements.d
Shows how to work with building elements:
- Creating walls (exterior and interior)
- Adding doors with fire ratings
- Creating windows with thermal properties
- Working with structural elements (columns, beams, slabs)
- Calculating material quantities
- Adding custom properties to elements

**Run with:**
```bash
dmd -i building_elements.d -I../source
./building_elements
```

### 3. materials.d
Demonstrates material management:
- Creating different material types (concrete, insulation, brick, plaster)
- Building multi-layer wall assemblies
- Calculating material quantities and costs
- Computing thermal properties (U-value, R-value)
- Determining structural weight
- Material cost estimation

**Run with:**
```bash
dmd -i materials.d -I../source
./materials
```

## Concepts Covered

### Building Hierarchy
```
Project
└── Building
    └── Storey (Floor)
        └── Space (Room)
```

### Building Elements
- **Walls**: Load-bearing and partition walls with fire resistance
- **Doors**: Various types with fire ratings
- **Windows**: Fixed and operable with thermal properties
- **Columns**: Structural vertical elements
- **Beams**: Structural horizontal elements
- **Slabs**: Floor and roof slabs

### Material Properties
- Density (kg/m³)
- Thermal conductivity (W/(m·K))
- Cost per unit
- Fire resistance
- Custom properties via key-value pairs

### Calculations
- Element areas and volumes
- Material quantities
- Cost estimation
- Thermal performance (U-value)
- Structural weight

## Building Information Modeling Standards

These examples follow common BIM practices and can be extended to support:
- IFC (Industry Foundation Classes) export/import
- Energy simulation data preparation
- Quantity takeoff
- Cost estimation
- Clash detection preparation
- 4D/5D BIM (time and cost scheduling)

## Next Steps

For production use, consider:
1. Adding geometry validation
2. Implementing IFC file I/O
3. Adding relationship management between elements
4. Implementing property sets (Psets)
5. Adding material libraries
6. Implementing building code compliance checks
7. Adding energy analysis integration
