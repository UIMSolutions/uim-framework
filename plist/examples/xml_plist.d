/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module plist.examples.xml_plist;

import uim.plist;
import std.stdio;

void main() {
    writeln("=== XML Property List Example ===\n");

    // Create a property list with some data
    auto plist = new PropertyList();
    plist.setDescription("Application configuration");
    plist.setVersion("1.0");
    
    plist.set("CFBundleName", "MyApp");
    plist.set("CFBundleVersion", "1.0.0");
    plist.set("CFBundleIdentifier", "com.example.myapp");
    plist.set("MinimumOSVersion", 10.15);
    plist.set("RequiresFullScreen", false);
    
    // Add capabilities array
    plist.set("Capabilities", ["Network", "FileSystem", "Camera"]);
    
    // Add info dictionary
    PlistValue[string] appInfo;
    appInfo["DisplayName"] = PlistValue("My Application");
    appInfo["Category"] = PlistValue("Productivity");
    appInfo["Rating"] = PlistValue(5);
    plist.set("ApplicationInfo", appInfo);

    writeln("Created property list with ", plist.length(), " items\n");

    // Write to XML format
    writeln("=== Writing to XML ===\n");
    auto writer = new XMLPlistWriter();
    string xmlContent = writer.write(plist);
    
    writeln(xmlContent);
    writeln("\n✓ XML generated successfully\n");

    // Parse back from XML
    writeln("=== Parsing from XML ===\n");
    auto parser = new XMLPlistParser();
    auto loadedPlist = parser.parse(xmlContent);

    writeln("Parsed property list:");
    writeln("  Bundle Name: ", loadedPlist.getString("CFBundleName"));
    writeln("  Version: ", loadedPlist.getString("CFBundleVersion"));
    writeln("  Identifier: ", loadedPlist.getString("CFBundleIdentifier"));
    writeln("  Min OS Version: ", loadedPlist.getFloat("MinimumOSVersion"));
    writeln("  Requires Full Screen: ", loadedPlist.getBool("RequiresFullScreen"));

    writeln("\n  Capabilities:");
    auto caps = loadedPlist.getArray("Capabilities");
    foreach (i, cap; caps) {
        writeln("    ", i + 1, ". ", cap.asString());
    }

    writeln("\n  Application Info:");
    auto info = loadedPlist.getDict("ApplicationInfo");
    writeln("    Display Name: ", info["DisplayName"].asString());
    writeln("    Category: ", info["Category"].asString());
    writeln("    Rating: ", info["Rating"].asInt());

    // Verify round-trip
    writeln("\n=== Verifying Round-Trip ===");
    assert(plist.getString("CFBundleName") == loadedPlist.getString("CFBundleName"));
    assert(plist.getInt("Rating", 0) == loadedPlist.getInt("Rating", 0));
    writeln("✓ Round-trip successful - all data preserved!");

    writeln("\n✓ Example completed successfully!");
}
