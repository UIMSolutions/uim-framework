/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.odbc.types;

public {
    // Nullable is re-exported from the standard library for convenience
    import std.typecons : Nullable, nullable;
    // Standard date/time types
    import std.datetime : Date, TimeOfDay, DateTime, SysTime;

    import uim.odbc.types.decimal_;
}

// ---------------------------------------------------------------------------
// Convenience type aliases that mirror the SAP C++ wrapper typedefs.
// All are Nullable so they can represent SQL NULL.
// ---------------------------------------------------------------------------

alias OdbcBoolean   = Nullable!bool;
alias OdbcByte      = Nullable!byte;
alias OdbcUByte     = Nullable!ubyte;
alias OdbcShort     = Nullable!short;
alias OdbcUShort    = Nullable!ushort;
alias OdbcInt       = Nullable!int;
alias OdbcUInt      = Nullable!uint;
alias OdbcLong      = Nullable!long;
alias OdbcULong     = Nullable!ulong;
alias OdbcFloat     = Nullable!float;
alias OdbcDouble    = Nullable!double;
alias OdbcString    = Nullable!string;
alias OdbcBinary    = Nullable!(ubyte[]);
alias OdbcDate      = Nullable!Date;
alias OdbcTime      = Nullable!TimeOfDay;
alias OdbcTimestamp = Nullable!DateTime;
alias OdbcDecimalN  = Nullable!OdbcDecimal;
