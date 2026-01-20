/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module plist.examples.json_plist;

import uim.plist;
import std.stdio;

void main() {
    writeln("=== JSON Property List Example ===\n");

    // Create a property list
    auto plist = new PropertyList();
    
    // Add user profile data
    plist.set("username", "john_doe");
    plist.set("email", "john@example.com");
    plist.set("age", 30);
    plist.set("active", true);
    plist.set("score", 95.5);

    // Add preferences array
    plist.set("preferences", ["darkMode", "notifications", "autoSave"]);

    // Add nested settings
    PlistValue[string] settings;
    settings["theme"] = PlistValue("dark");
    settings["fontSize"] = PlistValue(14);
    settings["lineNumbers"] = PlistValue(true);
    plist.set("editorSettings", settings);

    // Add nested array of dictionaries (tags)
    PlistValue[string] tag1;
    tag1["name"] = PlistValue("important");
    tag1["color"] = PlistValue("red");
    
    PlistValue[string] tag2;
    tag2["name"] = PlistValue("work");
    tag2["color"] = PlistValue("blue");
    
    plist.set("tags", [PlistValue(tag1), PlistValue(tag2)]);

    writeln("Created property list with ", plist.length(), " items\n");

    // Convert to JSON
    writeln("=== Converting to JSON ===\n");
    auto converter = new JSONPlistConverter();
    string jsonContent = converter.toJSON(plist);
    
    writeln(jsonContent);
    writeln("\n✓ JSON generated successfully\n");

    // Parse back from JSON
    writeln("=== Parsing from JSON ===\n");
    auto loadedPlist = converter.fromJSON(jsonContent);

    writeln("Parsed property list:");
    writeln("  Username: ", loadedPlist.getString("username"));
    writeln("  Email: ", loadedPlist.getString("email"));
    writeln("  Age: ", loadedPlist.getInt("age"));
    writeln("  Active: ", loadedPlist.getBool("active"));
    writeln("  Score: ", loadedPlist.getFloat("score"));

    writeln("\n  Preferences:");
    auto prefs = loadedPlist.getArray("preferences");
    foreach (i, pref; prefs) {
        writeln("    ", i + 1, ". ", pref.asString());
    }

    writeln("\n  Editor Settings:");
    auto editorSettings = loadedPlist.getDict("editorSettings");
    writeln("    Theme: ", editorSettings["theme"].asString());
    writeln("    Font Size: ", editorSettings["fontSize"].asInt());
    writeln("    Line Numbers: ", editorSettings["lineNumbers"].asBool());

    writeln("\n  Tags:");
    auto tags = loadedPlist.getArray("tags");
    foreach (i, tagValue; tags) {
        auto tag = tagValue.asDict();
        writeln("    ", i + 1, ". ", tag["name"].asString(), " (", tag["color"].asString(), ")");
    }

    // Demonstrate JSON to XML conversion
    writeln("\n=== Converting JSON to XML ===\n");
    auto writer = new XMLPlistWriter();
    string xmlContent = writer.write(loadedPlist);
    writeln(xmlContent);

    writeln("\n✓ Example completed successfully!");
}
