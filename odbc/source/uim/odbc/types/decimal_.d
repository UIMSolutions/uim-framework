/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.odbc.types.decimal_;

import std.format   : format;
import std.conv     : to;
import std.algorithm: cmp;
import std.string   : strip;

// ---------------------------------------------------------------------------
// OdbcDecimal – a fixed-point decimal number with precision and scale.
//
// This mirrors the SAP odbc-cpp-wrapper `decimal` class.
// Internally the value is stored as its unscaled integer string, e.g.
// the decimal 1.23 (precision=3, scale=2) is stored as "123".
// ---------------------------------------------------------------------------

/**
 * Represents a signed fixed-point decimal number.
 *
 * The precision is the total number of significant digits (1–38).
 * The scale is the number of digits after the decimal point (0 ≤ scale ≤ precision).
 */
struct OdbcDecimal {

    // ── Construction ──────────────────────────────────────────────────────────

    /// Constructs the value 0 with precision 1 and scale 0.
    static OdbcDecimal zero() pure nothrow @safe {
        OdbcDecimal d;
        d._unscaled  = "0";
        d._precision = 1;
        d._scale     = 0;
        d._sign      = 1;
        return d;
    }

    /**
     * Constructs a decimal from a signed integer, applying the given scale.
     *
     * Applying the scale means the integer is divided by 10^scale, e.g.
     * `fromInt(123, 3, 2)` yields 1.23.
     *
     * Params:
     *   value     = The unscaled integer value.
     *   precision = The total number of digits (1–38).
     *   scale     = The number of digits after the decimal point.
     */
    static OdbcDecimal fromInt(long value, ubyte precision, ubyte scale = 0) pure @safe {
        OdbcDecimal d;
        d._sign      = value >= 0 ? cast(byte)1 : cast(byte)-1;
        d._unscaled  = (value < 0 ? -value : value).to!string;
        d._precision = precision;
        d._scale     = scale;
        return d;
    }

    /**
     * Constructs a decimal from a string representation such as "3.14".
     *
     * Params:
     *   value     = String representation (optional leading '-').
     *   precision = Total digit count.
     *   scale     = Digits after decimal point.
     */
    static OdbcDecimal fromString(string value, ubyte precision, ubyte scale = 0) pure @safe {
        import std.string : indexOf, replace;
        OdbcDecimal d;
        string v = value.strip;
        d._sign     = (v.length > 0 && v[0] == '-') ? cast(byte)-1 : cast(byte)1;
        if (v.length > 0 && (v[0] == '-' || v[0] == '+'))
            v = v[1 .. $];
        // Remove decimal point and remember scale from string if not overridden
        ptrdiff_t dot = v.indexOf('.');
        if (dot >= 0) {
            v = v[0 .. dot] ~ v[dot + 1 .. $];
        }
        // Strip leading zeros
        size_t start = 0;
        while (start + 1 < v.length && v[start] == '0')
            start++;
        d._unscaled  = v[start .. $].length == 0 ? "0" : v[start .. $];
        d._precision = precision;
        d._scale     = scale;
        return d;
    }

    // ── Properties ────────────────────────────────────────────────────────────

    /// The total number of significant digits.
    ubyte precision() const pure nothrow @safe { return _precision; }

    /// The number of digits after the decimal point.
    ubyte scale() const pure nothrow @safe { return _scale; }

    /// Returns 1 if positive, -1 if negative, 0 if zero.
    byte signum() const pure nothrow @safe {
        if (_unscaled == "0") return 0;
        return _sign;
    }

    /// The raw unscaled integer digits (without sign or decimal point).
    string unscaledValue() const pure nothrow @safe { return _unscaled; }

    // ── Formatting ────────────────────────────────────────────────────────────

    /**
     * Returns a human-readable string with the decimal point in the correct
     * position, e.g. "1.23" for unscaled="123", scale=2.
     */
    string toString() const pure @safe {
        if (_scale == 0)
            return (_sign < 0 ? "-" : "") ~ _unscaled;

        // Pad unscaled to at least scale+1 digits
        string u = _unscaled;
        while (u.length <= _scale)
            u = "0" ~ u;

        size_t intLen = u.length - _scale;
        string result = u[0 .. intLen] ~ "." ~ u[intLen .. $];
        return (_sign < 0 ? "-" : "") ~ result;
    }

    // ── Comparison ────────────────────────────────────────────────────────────

    bool opEquals(const OdbcDecimal other) const pure @safe {
        return _cmp(other) == 0;
    }

    int opCmp(const OdbcDecimal other) const pure @safe {
        return _cmp(other);
    }

    // ── Private ───────────────────────────────────────────────────────────────

private:
    string _unscaled  = "0";  // digits without sign or decimal point
    ubyte  _precision = 1;
    ubyte  _scale     = 0;
    byte   _sign      = 1;    // 1 = positive/zero, -1 = negative

    // Simple sign-aware magnitude comparison
    int _cmp(const OdbcDecimal other) const pure @safe {
        if (_sign != other._sign) return _sign > other._sign ? 1 : -1;
        // Same sign – compare by converting both to long-scale strings
        // (good enough for typical precision ≤ 38)
        int mag = _cmpMagnitude(other);
        return _sign >= 0 ? mag : -mag;
    }

    // Compare magnitudes as decimal-scaled integers
    int _cmpMagnitude(const OdbcDecimal other) const pure @safe {
        // Normalise to the same scale by appending trailing zeros
        int diff = cast(int)_scale - cast(int)other._scale;
        string a = _unscaled;
        string b = other._unscaled;
        if (diff > 0) {
            foreach (_; 0 .. diff) b ~= '0';
        } else if (diff < 0) {
            foreach (_; 0 .. -diff) a ~= '0';
        }
        // Compare by length first, then lexicographically
        if (a.length != b.length)
            return a.length < b.length ? -1 : 1;
        return .cmp(a, b);
    }
}

///
unittest {
    auto d = OdbcDecimal.fromInt(123, 5, 2);
    assert(d.toString() == "1.23");
    assert(d.precision == 5);
    assert(d.scale == 2);

    auto neg = OdbcDecimal.fromInt(-456, 6, 3);
    assert(neg.toString() == "-0.456");
    assert(neg.signum() == -1);

    auto zero_ = OdbcDecimal.zero();
    assert(zero_.toString() == "0");
    assert(zero_.signum() == 0);
}
