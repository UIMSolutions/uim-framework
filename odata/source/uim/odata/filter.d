/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.odata.filter;

import uim.odata.exceptions;
import std.conv;
import std.array;
import std.string;
import std.algorithm;

@safe:

/**
 * ODataFilter - Builder for OData filter expressions
 * 
 * Provides a fluent API for constructing complex filter expressions
 * following the OData v4 specification.
 */
class ODataFilter {
    private string[] _parts;
    private bool _needsOperator = false;

    /**
     * Equals operator (eq)
     */
    ODataFilter equals(T)(string field, T value) {
        addOperatorIfNeeded();
        _parts ~= field ~ " eq " ~ formatValue(value);
        _needsOperator = true;
        return this;
    }

    /**
     * Not equals operator (ne)
     */
    ODataFilter notEquals(T)(string field, T value) {
        addOperatorIfNeeded();
        _parts ~= field ~ " ne " ~ formatValue(value);
        _needsOperator = true;
        return this;
    }

    /**
     * Greater than operator (gt)
     */
    ODataFilter greaterThan(T)(string field, T value) {
        addOperatorIfNeeded();
        _parts ~= field ~ " gt " ~ formatValue(value);
        _needsOperator = true;
        return this;
    }

    /**
     * Less than operator (lt)
     */
    ODataFilter lessThan(T)(string field, T value) {
        addOperatorIfNeeded();
        _parts ~= field ~ " lt " ~ formatValue(value);
        _needsOperator = true;
        return this;
    }

    /**
     * Greater or equal operator (ge)
     */
    ODataFilter greaterOrEqual(T)(string field, T value) {
        addOperatorIfNeeded();
        _parts ~= field ~ " ge " ~ formatValue(value);
        _needsOperator = true;
        return this;
    }

    /**
     * Less or equal operator (le)
     */
    ODataFilter lessOrEqual(T)(string field, T value) {
        addOperatorIfNeeded();
        _parts ~= field ~ " le " ~ formatValue(value);
        _needsOperator = true;
        return this;
    }

    /**
     * Logical AND operator
     */
    ODataFilter and() {
        if (!_needsOperator) {
            throw new ODataFilterException("Cannot add 'and' without a preceding condition");
        }
        _parts ~= " and ";
        _needsOperator = false;
        return this;
    }

    /**
     * Logical OR operator
     */
    ODataFilter or() {
        if (!_needsOperator) {
            throw new ODataFilterException("Cannot add 'or' without a preceding condition");
        }
        _parts ~= " or ";
        _needsOperator = false;
        return this;
    }

    /**
     * Logical NOT operator
     */
    ODataFilter not() {
        addOperatorIfNeeded();
        _parts ~= "not ";
        return this;
    }

    /**
     * Contains function (string)
     */
    ODataFilter contains(string field, string value) {
        addOperatorIfNeeded();
        _parts ~= "contains(" ~ field ~ ", " ~ formatValue(value) ~ ")";
        _needsOperator = true;
        return this;
    }

    /**
     * Starts with function (string)
     */
    ODataFilter startsWith(string field, string value) {
        addOperatorIfNeeded();
        _parts ~= "startswith(" ~ field ~ ", " ~ formatValue(value) ~ ")";
        _needsOperator = true;
        return this;
    }

    /**
     * Ends with function (string)
     */
    ODataFilter endsWith(string field, string value) {
        addOperatorIfNeeded();
        _parts ~= "endswith(" ~ field ~ ", " ~ formatValue(value) ~ ")";
        _needsOperator = true;
        return this;
    }

    /**
     * Length function (string)
     */
    ODataFilter length(string field) {
        addOperatorIfNeeded();
        _parts ~= "length(" ~ field ~ ")";
        _needsOperator = true;
        return this;
    }

    /**
     * To lower function (string)
     */
    ODataFilter toLower(string field) {
        addOperatorIfNeeded();
        _parts ~= "tolower(" ~ field ~ ")";
        _needsOperator = true;
        return this;
    }

    /**
     * To upper function (string)
     */
    ODataFilter toUpper(string field) {
        addOperatorIfNeeded();
        _parts ~= "toupper(" ~ field ~ ")";
        _needsOperator = true;
        return this;
    }

    /**
     * Year function (date)
     */
    ODataFilter year(string field) {
        addOperatorIfNeeded();
        _parts ~= "year(" ~ field ~ ")";
        _needsOperator = true;
        return this;
    }

    /**
     * Month function (date)
     */
    ODataFilter month(string field) {
        addOperatorIfNeeded();
        _parts ~= "month(" ~ field ~ ")";
        _needsOperator = true;
        return this;
    }

    /**
     * Day function (date)
     */
    ODataFilter day(string field) {
        addOperatorIfNeeded();
        _parts ~= "day(" ~ field ~ ")";
        _needsOperator = true;
        return this;
    }

    /**
     * Any operator for collections
     */
    ODataFilter any(string collection, string alias, string condition) {
        addOperatorIfNeeded();
        _parts ~= collection ~ "/any(" ~ alias ~ ": " ~ condition ~ ")";
        _needsOperator = true;
        return this;
    }

    /**
     * All operator for collections
     */
    ODataFilter all(string collection, string alias, string condition) {
        addOperatorIfNeeded();
        _parts ~= collection ~ "/all(" ~ alias ~ ": " ~ condition ~ ")";
        _needsOperator = true;
        return this;
    }

    /**
     * Group expressions with parentheses
     */
    ODataFilter group(ODataFilter innerFilter) {
        addOperatorIfNeeded();
        _parts ~= "(" ~ innerFilter.build() ~ ")";
        _needsOperator = true;
        return this;
    }

    /**
     * Builds the filter expression
     */
    string build() const {
        return _parts.join("");
    }

    /**
     * Clears the filter
     */
    void clear() {
        _parts.length = 0;
        _needsOperator = false;
    }

    private void addOperatorIfNeeded() {
        // Space handling is done by explicit " and " / " or " additions
    }

    private string formatValue(T)(T value) const {
        static if (is(T == string)) {
            return "'" ~ value.replace("'", "''") ~ "'";
        } else static if (is(T == bool)) {
            return value ? "true" : "false";
        } else static if (is(T == int) || is(T == long) || is(T == double) || is(T == float)) {
            return value.to!string;
        } else {
            return value.to!string;
        }
    }
}

// Unit tests
unittest {
    auto filter = new ODataFilter();
    filter.equals("Status", "Active");
    assert(filter.build() == "Status eq 'Active'");
}

unittest {
    auto filter = new ODataFilter();
    filter.equals("Age", 18)
          .and()
          .equals("Country", "USA");
    assert(filter.build() == "Age eq 18 and Country eq 'USA'");
}

unittest {
    auto filter = new ODataFilter();
    filter.greaterThan("Price", 100)
          .and()
          .lessThan("Price", 1000);
    assert(filter.build() == "Price gt 100 and Price lt 1000");
}

unittest {
    auto filter = new ODataFilter();
    filter.startsWith("Name", "A")
          .or()
          .endsWith("Name", "Z");
    assert(filter.build() == "startswith(Name, 'A') or endswith(Name, 'Z')");
}
