/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.odata.enumerations.primitives;

@safe:

/// OData Entity Data Model primitive types (OData v4.0 specification).
enum EdmPrimitiveType {
    binary,
    boolean_,
    byte_,
    date,
    dateTimeOffset,
    decimal,
    double_,
    duration,
    guid,
    int16,
    int32,
    int64,
    sbyte_,
    single,
    stream,
    string_,
    timeOfDay,
}

/// Returns the canonical OData EDM type name (e.g. "Edm.Int32").
string edmName(EdmPrimitiveType t) pure nothrow {
    // Indexed by enum ordinal — must stay in sync with EdmPrimitiveType.
    static immutable string[] names = [
        "Edm.Binary",
        "Edm.Boolean",
        "Edm.Byte",
        "Edm.Date",
        "Edm.DateTimeOffset",
        "Edm.Decimal",
        "Edm.Double",
        "Edm.Duration",
        "Edm.Guid",
        "Edm.Int16",
        "Edm.Int32",
        "Edm.Int64",
        "Edm.SByte",
        "Edm.Single",
        "Edm.Stream",
        "Edm.String",
        "Edm.TimeOfDay",
    ];
    return names[t];
}
