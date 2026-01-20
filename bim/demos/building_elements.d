/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module bim.demos.building_elements;

import std.stdio;
import uim.bim;

void main() {
    writeln("=== BIM Library - Building Elements Example ===\n");

    // Example 1: Create walls
    writeln("1. Creating exterior and interior walls:");
    
    auto exteriorWall = new DBIMWall();
    exteriorWall.name = "Exterior Wall - North";
    exteriorWall.guid = "wall-ext-001";
    exteriorWall.length = 10.0;
    exteriorWall.height = 3.5;
    exteriorWall.thickness = 0.35;
    exteriorWall.isLoadBearing = true;
    exteriorWall.fireResistance = "REI 120";
    
    writeln("  Created wall: ", exteriorWall.name);
    writeln("    Dimensions: ", exteriorWall.length, "m × ", exteriorWall.height, "m × ", 
            exteriorWall.thickness, "m");
    writeln("    Load bearing: ", exteriorWall.isLoadBearing);
    writeln("    Fire resistance: ", exteriorWall.fireResistance);
    writeln("    Area: ", exteriorWall.area, " m²");
    writeln();

    auto interiorWall = new DBIMWall();
    interiorWall.name = "Interior Wall - Partition";
    interiorWall.guid = "wall-int-001";
    interiorWall.length = 5.0;
    interiorWall.height = 3.0;
    interiorWall.thickness = 0.12;
    interiorWall.isLoadBearing = false;
    interiorWall.fireResistance = "EI 30";
    
    writeln("  Created wall: ", interiorWall.name);
    writeln("    Dimensions: ", interiorWall.length, "m × ", interiorWall.height, "m × ", 
            interiorWall.thickness, "m");
    writeln("    Load bearing: ", interiorWall.isLoadBearing);
    writeln();

    // Example 2: Create doors
    writeln("2. Creating doors:");
    
    auto mainDoor = new DBIMDoor();
    mainDoor.name = "Main Entrance Door";
    mainDoor.guid = "door-main-001";
    mainDoor.width = 1.2;
    mainDoor.height = 2.1;
    mainDoor.doorType = "Double Swing";
    mainDoor.isFireRated = true;
    mainDoor.fireRating = "EI2 60";
    
    writeln("  Created door: ", mainDoor.name);
    writeln("    Type: ", mainDoor.doorType);
    writeln("    Dimensions: ", mainDoor.width, "m × ", mainDoor.height, "m");
    writeln("    Fire rated: ", mainDoor.isFireRated, " (", mainDoor.fireRating, ")");
    writeln();

    auto officeDoor = new DBIMDoor();
    officeDoor.name = "Office Door";
    officeDoor.guid = "door-office-001";
    officeDoor.width = 0.9;
    officeDoor.height = 2.1;
    officeDoor.doorType = "Single Swing";
    officeDoor.isFireRated = false;
    
    writeln("  Created door: ", officeDoor.name);
    writeln("    Type: ", officeDoor.doorType);
    writeln("    Dimensions: ", officeDoor.width, "m × ", officeDoor.height, "m");
    writeln();

    // Example 3: Create windows
    writeln("3. Creating windows:");
    
    auto officeWindow = new DBIMWindow();
    officeWindow.name = "Office Window";
    officeWindow.guid = "window-001";
    officeWindow.width = 1.5;
    officeWindow.height = 1.8;
    officeWindow.windowType = "Fixed";
    officeWindow.glazingType = "Double Glazed";
    officeWindow.uValue = 1.1;
    officeWindow.isOperable = false;
    
    writeln("  Created window: ", officeWindow.name);
    writeln("    Type: ", officeWindow.windowType);
    writeln("    Glazing: ", officeWindow.glazingType);
    writeln("    Dimensions: ", officeWindow.width, "m × ", officeWindow.height, "m");
    writeln("    Area: ", officeWindow.area, " m²");
    writeln("    U-Value: ", officeWindow.uValue, " W/(m²·K)");
    writeln("    Operable: ", officeWindow.isOperable);
    writeln();

    auto operableWindow = new DBIMWindow();
    operableWindow.name = "Operable Window";
    operableWindow.guid = "window-002";
    operableWindow.width = 1.2;
    operableWindow.height = 1.5;
    operableWindow.windowType = "Casement";
    operableWindow.glazingType = "Triple Glazed";
    operableWindow.uValue = 0.8;
    operableWindow.isOperable = true;
    
    writeln("  Created window: ", operableWindow.name);
    writeln("    Type: ", operableWindow.windowType);
    writeln("    Glazing: ", operableWindow.glazingType);
    writeln("    U-Value: ", operableWindow.uValue, " W/(m²·K)");
    writeln();

    // Example 4: Create structural elements
    writeln("4. Creating structural elements:");
    
    auto column = new DBIMColumn();
    column.name = "Column C1";
    column.guid = "column-001";
    column.width = 0.4;
    column.depth = 0.4;
    column.height = 3.5;
    column.crossSection = "Square";
    column.isLoadBearing = true;
    column.fireResistance = "R 120";
    
    writeln("  Created column: ", column.name);
    writeln("    Cross section: ", column.crossSection);
    writeln("    Dimensions: ", column.width, "m × ", column.depth, "m × ", column.height, "m");
    writeln("    Load bearing: ", column.isLoadBearing);
    writeln();

    auto beam = new DBIMBeam();
    beam.name = "Main Beam B1";
    beam.guid = "beam-001";
    beam.width = 0.3;
    beam.height = 0.6;
    beam.length = 8.0;
    beam.crossSection = "Rectangular";
    beam.isLoadBearing = true;
    beam.fireResistance = "R 90";
    
    writeln("  Created beam: ", beam.name);
    writeln("    Cross section: ", beam.crossSection);
    writeln("    Dimensions: ", beam.width, "m × ", beam.height, "m × ", beam.length, "m");
    writeln();

    auto slab = new DBIMSlab();
    slab.name = "Floor Slab";
    slab.guid = "slab-001";
    slab.thickness = 0.25;
    slab.area = 250.0;
    slab.slabType = "Concrete Slab";
    slab.isLoadBearing = true;
    slab.fireResistance = "REI 90";
    
    writeln("  Created slab: ", slab.name);
    writeln("    Type: ", slab.slabType);
    writeln("    Thickness: ", slab.thickness, "m");
    writeln("    Area: ", slab.area, " m²");
    writeln("    Volume: ", slab.volume, " m³");
    writeln();

    // Example 5: Calculate material quantities
    writeln("5. Calculating material quantities:");
    
    double totalWallArea = exteriorWall.area + interiorWall.area;
    double totalWindowArea = officeWindow.area + operableWindow.area;
    double totalSlabVolume = slab.volume;
    
    writeln("  Total wall area: ", totalWallArea, " m²");
    writeln("  Total window area: ", totalWindowArea, " m²");
    writeln("  Total slab volume: ", totalSlabVolume, " m³");
    writeln("  Wall-to-window ratio: ", (totalWindowArea / totalWallArea * 100), "%");
    writeln();

    // Example 6: Element properties
    writeln("6. Working with element properties:");
    
    auto prop1 = new DBIMProperty();
    prop1.name = "Thermal Transmittance";
    prop1.value = Json(exteriorWall.thermalTransmittance);
    prop1.unit = "W/(m²·K)";
    prop1.dataType = "Double";
    exteriorWall.addProperty(prop1);
    
    writeln("  Added property to ", exteriorWall.name, ":");
    writeln("    ", prop1.name, ": ", prop1.value.get!double, " ", prop1.unit);
    writeln();

    writeln("=== Example Complete ===");
}
