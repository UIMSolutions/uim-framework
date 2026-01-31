/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.containers.plist;

/**
 * Property List (plist) library for UIM framework
 * 
 * This module provides comprehensive support for working with property lists,
 * a data structure commonly used for storing configuration data and settings.
 * 
 * Features:
 * - Multiple data types: string, integer, float, boolean, date, data, array, dictionary
 * - XML plist format support (Apple's traditional format)
 * - Json format support
 * - Type-safe value access with automatic conversions
 * - Reading and writing property lists
 * - Validation and error handling
 * 
 * Example:
 * ---
 * import uim.oop.containers.plist;
 * 
 * // Create a property list
 * auto plist = new PropertyList();
 * plist.set("name", "MyApp");
 * plist.set("version", "1.0");
 * plist.set("debug", true);
 * 
 * // Export to XML
 * auto writer = new XMLPlistWriter();
 * string xml = writer.write(plist);
 * 
 * // Parse from XML
 * auto parser = new XMLPlistParser();
 * auto loaded = parser.parse(xml);
 * 
 * // Convert to Json
 * auto converter = new JsonPlistConverter();
 * string json = converter.toJson(plist);
 * ---
 */

public {
    import uim.oop;

    import uim.oop.containers.plist.exceptions;
    import uim.oop.containers.plist.value;
    import uim.oop.containers.plist.propertylist;
    import uim.oop.containers.plist.xml;
    import uim.oop.containers.plist.json;
}
