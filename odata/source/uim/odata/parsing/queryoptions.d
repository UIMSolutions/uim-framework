/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.odata.parsing.queryoptions;

import std.algorithm.iteration : splitter, map;
import std.algorithm.searching : endsWith, startsWith;
import std.array : array, split;
import std.conv : to;
import std.string : indexOf, strip, toLower;

import uim.odata.types.queryoptions;

@safe:

/// Parses an OData query string (everything after '?') into QueryOptions.
///
/// Recognised system query options: $filter, $select, $expand, $orderby,
/// $top, $skip, $count, $format.
QueryOptions parseQueryString(string qs) {
    QueryOptions opts;

    foreach (segment; qs.splitter('&')) {
        auto eqPos = indexOf(segment, '=');
        if (eqPos < 0)
            continue;

        auto key = segment[0 .. eqPos];
        auto value = segment[eqPos + 1 .. $];

        switch (key) {
            case "$filter":
                opts.filter = uriDecode(value);
                break;
            case "$select":
                opts.select = splitCsv(value);
                break;
            case "$expand":
                opts.expand = splitCsv(value);
                break;
            case "$orderby":
                opts.orderby = parseOrderBy(value);
                break;
            case "$top":
                try { opts.top = value.to!long; } catch (Exception) {}
                break;
            case "$skip":
                try { opts.skip = value.to!long; } catch (Exception) {}
                break;
            case "$count":
                opts.count = (value == "true");
                break;
            case "$format":
                opts.format = value;
                break;
            default:
                break;
        }
    }

    return opts;
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

private string[] splitCsv(string value) {
    return value.splitter(',').map!(s => s.strip).array;
}

private OrderByClause[] parseOrderBy(string value) {
    OrderByClause[] clauses;
    foreach (part; value.splitter(',')) {
        auto trimmed = part.strip;
        auto spacePos = indexOf(trimmed, ' ');
        if (spacePos >= 0) {
            clauses ~= OrderByClause(
                trimmed[0 .. spacePos],
                trimmed[spacePos + 1 .. $].strip.toLower == "desc"
            );
        } else {
            clauses ~= OrderByClause(trimmed, false);
        }
    }
    return clauses;
}

/// Minimal percent-decoding for OData filter strings.
private string uriDecode(string s) {
    import std.array : appender;

    auto result = appender!string;
    for (size_t i = 0; i < s.length; ++i) {
        if (s[i] == '%' && i + 2 < s.length) {
            try {
                result ~= cast(char) s[i + 1 .. i + 3].to!ubyte(16);
                i += 2;
            } catch (Exception) {
                result ~= s[i];
            }
        } else if (s[i] == '+') {
            result ~= ' ';
        } else {
            result ~= s[i];
        }
    }
    return result[];
}
