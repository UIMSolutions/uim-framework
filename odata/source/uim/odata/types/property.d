/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.odata.types.property;

import uim.odata.enumerations.primitives;

@safe:

/// Represents a property definition in an OData entity type (EDM).
struct EdmProperty {
    string name;
    EdmPrimitiveType type;
    bool nullable = true;
    string defaultValue;
    int maxLength = -1;

    /// Returns the canonical EDM type name of this property.
    string typeName() const pure nothrow {
        return type.edmName;
    }
}
