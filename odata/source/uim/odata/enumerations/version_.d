/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.odata.enumerations.version_;

@safe:

/// Supported OData protocol versions.
enum ODataVersion {
    v2,
    v3,
    v4,
}

/// Returns the version string (e.g. "4.0").
string versionString(ODataVersion v) pure nothrow {
    final switch (v) {
        case ODataVersion.v2: return "2.0";
        case ODataVersion.v3: return "3.0";
        case ODataVersion.v4: return "4.0";
    }
}
