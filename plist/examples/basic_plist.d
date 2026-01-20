/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module plist.examples.basic_plist;

import uim.plist;
import std.stdio;

void main() {
    writeln("=== Basic Property List Example ===\n");

    // Create a new property list
    auto plist = new PropertyList();

    // Set various types of values
    writeln("Setting values...");
    plist.set("appName", "MyApplication");
    plist.set("version", "1.0.5");
    plist.set("buildNumber", 142);
    plist.set("debugMode", false);
    plist.set("maxConnections", 100);
    plist.set("timeout", 30.5);

    // Set an array
    plist.set("supportedLanguages", ["en", "de", "fr", "es"]);

    // Set nested dictionary
    PlistValue[string] serverConfig;
    serverConfig["host"] = PlistValue("localhost");
    serverConfig["port"] = PlistValue(8080);
    serverConfig["ssl"] = PlistValue(true);
    plist.set("serverConfig", serverConfig);

    writeln("✓ Values set successfully\n");

    // Read values back
    writeln("Reading values:");
    writeln("  App Name: ", plist.getString("appName"));
    writeln("  Version: ", plist.getString("version"));
    writeln("  Build Number: ", plist.getInt("buildNumber"));
    writeln("  Debug Mode: ", plist.getBool("debugMode"));
    writeln("  Max Connections: ", plist.getInt("maxConnections"));
    writeln("  Timeout: ", plist.getFloat("timeout"));

    // Read array
    writeln("\n  Supported Languages:");
    auto languages = plist.getArray("supportedLanguages");
    foreach (i, lang; languages) {
        writeln("    ", i + 1, ". ", lang.asString());
    }

    // Read nested dictionary
    writeln("\n  Server Configuration:");
    auto serverCfg = plist.getDict("serverConfig");
    writeln("    Host: ", serverCfg["host"].asString());
    writeln("    Port: ", serverCfg["port"].asInt());
    writeln("    SSL: ", serverCfg["ssl"].asBool());

    // Check if key exists
    writeln("\n  Checking keys:");
    writeln("    Has 'appName': ", plist.has("appName"));
    writeln("    Has 'missing': ", plist.has("missing"));

    // Get with default values
    writeln("\n  Getting with defaults:");
    writeln("    Existing key: ", plist.getString("appName", "Default"));
    writeln("    Missing key: ", plist.getString("missing", "Default"));

    // List all keys
    writeln("\n  All keys:");
    foreach (key; plist.keys()) {
        writeln("    - ", key);
    }

    writeln("\n✓ Example completed successfully!");
}
