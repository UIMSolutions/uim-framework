/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.cdm.schemas.fieldtype;

/**
 * Field data types for schema definitions
 */
enum FieldType {
    String,
    Integer,
    Long,
    Double,
    Boolean,
    DateTime,
    Date,
    Time,
    UUID,
    Binary,
    JSON,
    Array,
    Object
}
