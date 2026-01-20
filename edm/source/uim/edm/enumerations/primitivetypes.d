/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.edm.enumerations.primitivetypes;

/**
 * EDM Primitive Types as defined in the OData specification.
 * These are the built-in scalar types supported by EDM.
 */
enum EdmPrimitiveType : string {
    // Binary data
    Binary = "Edm.Binary",
    
    // Boolean
    Boolean = "Edm.Boolean",
    
    // Byte (unsigned 8-bit integer)
    Byte = "Edm.Byte",
    
    // Date (date without time)
    Date = "Edm.Date",
    
    // DateTimeOffset (date and time with timezone)
    DateTimeOffset = "Edm.DateTimeOffset",
    
    // Decimal (precise numeric value)
    Decimal = "Edm.Decimal",
    
    // Double (64-bit floating point)
    Double = "Edm.Double",
    
    // Duration (time span)
    Duration = "Edm.Duration",
    
    // Guid (globally unique identifier)
    Guid = "Edm.Guid",
    
    // Int16 (signed 16-bit integer)
    Int16 = "Edm.Int16",
    
    // Int32 (signed 32-bit integer)
    Int32 = "Edm.Int32",
    
    // Int64 (signed 64-bit integer)
    Int64 = "Edm.Int64",
    
    // SByte (signed 8-bit integer)
    SByte = "Edm.SByte",
    
    // Single (32-bit floating point)
    Single = "Edm.Single",
    
    // Stream (binary stream)
    Stream = "Edm.Stream",
    
    // String (character data)
    String = "Edm.String",
    
    // TimeOfDay (time without date)
    TimeOfDay = "Edm.TimeOfDay",
    
    // Geography (geographic data)
    Geography = "Edm.Geography",
    GeographyPoint = "Edm.GeographyPoint",
    GeographyLineString = "Edm.GeographyLineString",
    GeographyPolygon = "Edm.GeographyPolygon",
    GeographyMultiPoint = "Edm.GeographyMultiPoint",
    GeographyMultiLineString = "Edm.GeographyMultiLineString",
    GeographyMultiPolygon = "Edm.GeographyMultiPolygon",
    GeographyCollection = "Edm.GeographyCollection",
    
    // Geometry (geometric data)
    Geometry = "Edm.Geometry",
    GeometryPoint = "Edm.GeometryPoint",
    GeometryLineString = "Edm.GeometryLineString",
    GeometryPolygon = "Edm.GeometryPolygon",
    GeometryMultiPoint = "Edm.GeometryMultiPoint",
    GeometryMultiLineString = "Edm.GeometryMultiLineString",
    GeometryMultiPolygon = "Edm.GeometryMultiPolygon",
    GeometryCollection = "Edm.GeometryCollection"
}

/// Helper function to check if a type name is a primitive type
bool isPrimitiveType(string typeName) {
    switch (typeName) {
        case "Edm.Binary":
        case "Edm.Boolean":
        case "Edm.Byte":
        case "Edm.Date":
        case "Edm.DateTimeOffset":
        case "Edm.Decimal":
        case "Edm.Double":
        case "Edm.Duration":
        case "Edm.Guid":
        case "Edm.Int16":
        case "Edm.Int32":
        case "Edm.Int64":
        case "Edm.SByte":
        case "Edm.Single":
        case "Edm.Stream":
        case "Edm.String":
        case "Edm.TimeOfDay":
        case "Edm.Geography":
        case "Edm.GeographyPoint":
        case "Edm.GeographyLineString":
        case "Edm.GeographyPolygon":
        case "Edm.GeographyMultiPoint":
        case "Edm.GeographyMultiLineString":
        case "Edm.GeographyMultiPolygon":
        case "Edm.GeographyCollection":
        case "Edm.Geometry":
        case "Edm.GeometryPoint":
        case "Edm.GeometryLineString":
        case "Edm.GeometryPolygon":
        case "Edm.GeometryMultiPoint":
        case "Edm.GeometryMultiLineString":
        case "Edm.GeometryMultiPolygon":
        case "Edm.GeometryCollection":
            return true;
        default:
            return false;
    }
}
