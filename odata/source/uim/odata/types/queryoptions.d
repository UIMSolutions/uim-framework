/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.odata.types.queryoptions;

@safe:

/// OData query options parsed from the URL query string.
struct QueryOptions {
    string filter;           // raw $filter expression
    string[] select;         // $select property names
    string[] expand;         // $expand navigation properties
    OrderByClause[] orderby; // $orderby clauses
    long top = -1;           // $top limit (-1 = not set)
    long skip = 0;           // $skip offset
    bool count = false;      // $count=true
    string format = "json";  // $format

    bool hasFilter() const pure nothrow { return filter.length > 0; }
    bool hasSelect() const pure nothrow { return select.length > 0; }
    bool hasExpand() const pure nothrow { return expand.length > 0; }
    bool hasOrderBy() const pure nothrow { return orderby.length > 0; }
    bool hasTop() const pure nothrow { return top >= 0; }
}

/// A single clause within $orderby.
struct OrderByClause {
    string property;
    bool descending = false;
}
