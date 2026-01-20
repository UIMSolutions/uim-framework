/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.edm;

/**
 * UIM EDM (Enterprise Data Model) Library
 * 
 * A comprehensive D library for working with the Entity Data Model (EDM) specification.
 * EDM is the metadata system used by OData to describe the structure and relationships
 * of data in a service. It provides a standardized way to define:
 * 
 * - Primitive types (strings, integers, dates, etc.)
 * - Complex types (structured data)
 * - Entity types (data with keys)
 * - Entity sets and singletons
 * - Navigation properties (relationships)
 * - Actions and functions
 * - Annotations and vocabularies
 * 
 * Features:
 * - Complete EDM type system implementation
 * - Schema definition and validation
 * - Metadata document parsing and generation
 * - Navigation property management
 * - Property constraints and facets
 * - Type inheritance support
 * - Namespace management
 * - Annotation support
 * 
 * Example:
 * ---
 * import uim.edm;
 * 
 * // Create a schema
 * auto schema = new EdmSchema("MyNamespace");
 * 
 * // Define an entity type
 * auto personType = schema.createEntityType("Person")
 *     .addKey("Id")
 *     .addProperty("Id", EdmPrimitiveType.Int32, false)
 *     .addProperty("Name", EdmPrimitiveType.String, false)
 *     .addProperty("Email", EdmPrimitiveType.String, true)
 *     .addProperty("BirthDate", EdmPrimitiveType.Date, true);
 * 
 * // Define relationships
 * personType.addNavigationProperty("Orders", "Order", true);
 * 
 * // Create entity set
 * schema.createEntitySet("People", personType);
 * ---
 */

public {
    // Core imports
    import uim.oop;
    import uim.jsons;
}

public {
    // EDM modules
    import uim.edm.classes;
    import uim.edm.enumerations;
    import uim.edm.interfaces;
    import uim.edm.mixins;
}
