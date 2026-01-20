/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module bim.demos.materials;

import std.stdio;
import uim.bim;

void main() {
    writeln("=== BIM Library - Materials Example ===\n");

    // Example 1: Create concrete material
    writeln("1. Creating concrete material:");
    
    auto concrete = new DBIMMaterial();
    concrete.name = "Structural Concrete C30/37";
    concrete.guid = "mat-concrete-001";
    concrete.materialType = "Concrete";
    concrete.density = 2400.0; // kg/m³
    concrete.thermalConductivity = 1.75; // W/(m·K)
    concrete.costPerUnit = 85.0; // € per m³
    
    writeln("  Material: ", concrete.name);
    writeln("    Type: ", concrete.materialType);
    writeln("    Density: ", concrete.density, " kg/m³");
    writeln("    Thermal conductivity: ", concrete.thermalConductivity, " W/(m·K)");
    writeln("    Cost: ", concrete.costPerUnit, " € per m³");
    writeln();

    // Example 2: Create insulation material
    writeln("2. Creating insulation material:");
    
    auto insulation = new DBIMMaterial();
    insulation.name = "Mineral Wool Insulation";
    insulation.guid = "mat-insulation-001";
    insulation.materialType = "Insulation";
    insulation.density = 50.0; // kg/m³
    insulation.thermalConductivity = 0.035; // W/(m·K)
    insulation.costPerUnit = 25.0; // € per m³
    
    writeln("  Material: ", insulation.name);
    writeln("    Type: ", insulation.materialType);
    writeln("    Density: ", insulation.density, " kg/m³");
    writeln("    Thermal conductivity: ", insulation.thermalConductivity, " W/(m·K)");
    writeln("    Cost: ", insulation.costPerUnit, " € per m³");
    writeln();

    // Example 3: Create brick material
    writeln("3. Creating brick material:");
    
    auto brick = new DBIMMaterial();
    brick.name = "Clay Brick";
    brick.guid = "mat-brick-001";
    brick.materialType = "Masonry";
    brick.density = 1800.0; // kg/m³
    brick.thermalConductivity = 0.7; // W/(m·K)
    brick.costPerUnit = 450.0; // € per m³
    
    writeln("  Material: ", brick.name);
    writeln("    Type: ", brick.materialType);
    writeln("    Density: ", brick.density, " kg/m³");
    writeln("    Thermal conductivity: ", brick.thermalConductivity, " W/(m·K)");
    writeln();

    // Example 4: Create plaster material
    writeln("4. Creating finishing materials:");
    
    auto plaster = new DBIMMaterial();
    plaster.name = "Gypsum Plaster";
    plaster.guid = "mat-plaster-001";
    plaster.materialType = "Finishing";
    plaster.density = 1200.0; // kg/m³
    plaster.thermalConductivity = 0.35; // W/(m·K)
    plaster.costPerUnit = 120.0; // € per m³
    
    writeln("  Material: ", plaster.name);
    writeln("    Density: ", plaster.density, " kg/m³");
    writeln();

    // Example 5: Create a multi-layer wall with materials
    writeln("5. Creating multi-layer exterior wall:");
    
    auto exteriorWall = new DBIMWall();
    exteriorWall.name = "Insulated Exterior Wall";
    exteriorWall.guid = "wall-multi-001";
    exteriorWall.length = 10.0;
    exteriorWall.height = 3.5;
    
    // Add material layers (from exterior to interior)
    exteriorWall.addMaterial(plaster, 0.02);  // Exterior plaster
    exteriorWall.addMaterial(brick, 0.12);     // Brick layer
    exteriorWall.addMaterial(insulation, 0.15); // Insulation
    exteriorWall.addMaterial(concrete, 0.20);   // Structural concrete
    exteriorWall.addMaterial(plaster, 0.015);   // Interior plaster
    
    double totalThickness = 0.02 + 0.12 + 0.15 + 0.20 + 0.015;
    exteriorWall.thickness = totalThickness;
    
    writeln("  Wall: ", exteriorWall.name);
    writeln("  Material layers (exterior to interior):");
    int layerNum = 1;
    foreach (material; exteriorWall.materials()) {
        writeln("    Layer ", layerNum++, ": ", material.name);
    }
    writeln("  Total thickness: ", totalThickness, " m");
    writeln("  Wall area: ", exteriorWall.area, " m²");
    writeln();

    // Example 6: Calculate material quantities and costs
    writeln("6. Calculating material quantities and costs:");
    
    double wallArea = exteriorWall.area;
    double plasterVolume = wallArea * (0.02 + 0.015);
    double brickVolume = wallArea * 0.12;
    double insulationVolume = wallArea * 0.15;
    double concreteVolume = wallArea * 0.20;
    
    writeln("  For wall area of ", wallArea, " m²:");
    writeln("    Plaster volume: ", plasterVolume, " m³");
    writeln("    Brick volume: ", brickVolume, " m³");
    writeln("    Insulation volume: ", insulationVolume, " m³");
    writeln("    Concrete volume: ", concreteVolume, " m³");
    writeln();
    
    double plasterCost = plasterVolume * plaster.costPerUnit;
    double brickCost = brickVolume * brick.costPerUnit;
    double insulationCost = insulationVolume * insulation.costPerUnit;
    double concreteCost = concreteVolume * concrete.costPerUnit;
    double totalCost = plasterCost + brickCost + insulationCost + concreteCost;
    
    writeln("  Material costs:");
    writeln("    Plaster: ", plasterCost, " €");
    writeln("    Brick: ", brickCost, " €");
    writeln("    Insulation: ", insulationCost, " €");
    writeln("    Concrete: ", concreteCost, " €");
    writeln("    Total wall cost: ", totalCost, " €");
    writeln("    Cost per m²: ", totalCost / wallArea, " €/m²");
    writeln();

    // Example 7: Calculate thermal properties
    writeln("7. Calculating thermal properties:");
    
    // U-value calculation (simplified - series resistance)
    double R_plaster_ext = 0.02 / plaster.thermalConductivity;
    double R_brick = 0.12 / brick.thermalConductivity;
    double R_insulation = 0.15 / insulation.thermalConductivity;
    double R_concrete = 0.20 / concrete.thermalConductivity;
    double R_plaster_int = 0.015 / plaster.thermalConductivity;
    double R_si = 0.13;  // Interior surface resistance
    double R_se = 0.04;  // Exterior surface resistance
    
    double R_total = R_si + R_plaster_int + R_concrete + R_insulation + R_brick + R_plaster_ext + R_se;
    double U_value = 1.0 / R_total;
    
    writeln("  Wall thermal resistance (R-value): ", R_total, " m²·K/W");
    writeln("  Wall thermal transmittance (U-value): ", U_value, " W/(m²·K)");
    writeln();
    
    if (U_value < 0.3) {
        writeln("  ✓ Wall meets passive house standard (U < 0.3)");
    } else if (U_value < 0.4) {
        writeln("  ✓ Wall meets low-energy building standard (U < 0.4)");
    } else {
        writeln("  ⚠ Wall exceeds recommended U-value for energy efficiency");
    }
    writeln();

    // Example 8: Calculate material weight
    writeln("8. Calculating structural weight:");
    
    double plasterWeight = plasterVolume * plaster.density;
    double brickWeight = brickVolume * brick.density;
    double insulationWeight = insulationVolume * insulation.density;
    double concreteWeight = concreteVolume * concrete.density;
    double totalWeight = plasterWeight + brickWeight + insulationWeight + concreteWeight;
    
    writeln("  Material weights:");
    writeln("    Plaster: ", plasterWeight, " kg");
    writeln("    Brick: ", brickWeight, " kg");
    writeln("    Insulation: ", insulationWeight, " kg");
    writeln("    Concrete: ", concreteWeight, " kg");
    writeln("    Total wall weight: ", totalWeight, " kg");
    writeln("    Weight per m²: ", totalWeight / wallArea, " kg/m²");
    writeln();

    writeln("=== Example Complete ===");
}
