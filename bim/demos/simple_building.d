/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module bim.demos.simple_building;

import std.stdio;
import uim.bim;

void main() {
    writeln("=== BIM Library - Simple Building Example ===\n");

    // Example 1: Create a simple building structure
    writeln("1. Creating a building with multiple storeys:");
    
    auto building = new DBIMBuilding();
    building.name = "Office Building A";
    building.guid = "building-001";
    writeln("  Created building: ", building.name);
    writeln("  GUID: ", building.guid);
    writeln();

    // Create ground floor
    auto groundFloor = new DBIMStorey();
    groundFloor.name = "Ground Floor";
    groundFloor.guid = "storey-ground";
    groundFloor.elevation = 0.0;
    building.addStorey(groundFloor);
    writeln("  Added storey: ", groundFloor.name, " at elevation ", groundFloor.elevation, "m");

    // Create first floor
    auto firstFloor = new DBIMStorey();
    firstFloor.name = "First Floor";
    firstFloor.guid = "storey-first";
    firstFloor.elevation = 3.5;
    building.addStorey(firstFloor);
    writeln("  Added storey: ", firstFloor.name, " at elevation ", firstFloor.elevation, "m");

    // Create second floor
    auto secondFloor = new DBIMStorey();
    secondFloor.name = "Second Floor";
    secondFloor.guid = "storey-second";
    secondFloor.elevation = 7.0;
    building.addStorey(secondFloor);
    writeln("  Added storey: ", secondFloor.name, " at elevation ", secondFloor.elevation, "m");
    writeln();

    // Example 2: Add spaces/rooms to ground floor
    writeln("2. Adding spaces to ground floor:");
    
    auto lobby = new DBIMSpace();
    lobby.name = "Main Lobby";
    lobby.guid = "space-lobby";
    lobby.spaceType = "Circulation";
    lobby.area = 120.0;
    lobby.volume = 420.0;
    lobby.occupancy = 50;
    groundFloor.addSpace(lobby);
    writeln("  Added space: ", lobby.name);
    writeln("    Type: ", lobby.spaceType);
    writeln("    Area: ", lobby.area, " m²");
    writeln("    Volume: ", lobby.volume, " m³");
    writeln("    Occupancy: ", lobby.occupancy, " people");

    auto reception = new DBIMSpace();
    reception.name = "Reception";
    reception.guid = "space-reception";
    reception.spaceType = "Service";
    reception.area = 25.0;
    reception.volume = 87.5;
    reception.occupancy = 5;
    groundFloor.addSpace(reception);
    writeln("  Added space: ", reception.name);
    writeln("    Type: ", reception.spaceType);
    writeln("    Area: ", reception.area, " m²");
    writeln();

    // Example 3: Add spaces to first floor
    writeln("3. Adding office spaces to first floor:");
    
    auto office1 = new DBIMSpace();
    office1.name = "Office 101";
    office1.guid = "space-office-101";
    office1.spaceType = "Office";
    office1.area = 40.0;
    office1.volume = 140.0;
    office1.occupancy = 8;
    firstFloor.addSpace(office1);

    auto office2 = new DBIMSpace();
    office2.name = "Office 102";
    office2.guid = "space-office-102";
    office2.spaceType = "Office";
    office2.area = 35.0;
    office2.volume = 122.5;
    office2.occupancy = 6;
    firstFloor.addSpace(office2);

    auto meetingRoom = new DBIMSpace();
    meetingRoom.name = "Meeting Room";
    meetingRoom.guid = "space-meeting";
    meetingRoom.spaceType = "Conference";
    meetingRoom.area = 50.0;
    meetingRoom.volume = 175.0;
    meetingRoom.occupancy = 12;
    firstFloor.addSpace(meetingRoom);

    writeln("  Added ", firstFloor.spaces().length, " spaces to ", firstFloor.name);
    writeln();

    // Example 4: Query and navigate building hierarchy
    writeln("4. Building hierarchy navigation:");
    writeln("  Building: ", building.name);
    writeln("  Number of storeys: ", building.storeys().length);
    
    foreach (i, storey; building.storeys()) {
        writeln("    Storey ", i + 1, ": ", storey.name);
        writeln("      Elevation: ", storey.elevation, "m");
        writeln("      Spaces: ", storey.spaces().length);
        
        double totalArea = 0;
        foreach (space; storey.spaces()) {
            totalArea += space.area;
            writeln("        - ", space.name, " (", space.spaceType, "): ", space.area, " m²");
        }
        writeln("      Total floor area: ", totalArea, " m²");
    }
    writeln();

    // Example 5: Calculate building metrics
    writeln("5. Building metrics:");
    
    double totalBuildingArea = 0;
    int totalOccupancy = 0;
    
    foreach (storey; building.storeys()) {
        foreach (space; storey.spaces()) {
            totalBuildingArea += space.area;
            totalOccupancy += space.occupancy;
        }
    }
    
    writeln("  Total building area: ", totalBuildingArea, " m²");
    writeln("  Total occupancy capacity: ", totalOccupancy, " people");
    writeln("  Building height: ~", secondFloor.elevation + 3.5, " m (estimated)");
    writeln();

    // Example 6: Create a BIM project
    writeln("6. Creating a BIM project:");
    
    auto project = new DBIMProject();
    project.name = "Downtown Office Complex";
    project.phase = "Design Development";
    writeln("  Project: ", project.name);
    writeln("  Phase: ", project.phase);
    writeln();

    writeln("=== Example Complete ===");
}
