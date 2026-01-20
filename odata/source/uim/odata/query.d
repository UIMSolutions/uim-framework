/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.odata.query;

import uim.odata.exceptions;
import uim.odata.filter;
import std.conv;
import std.array;
import std.string;
import std.algorithm;
import std.uri;

@safe:

/**
 * ODataQueryBuilder - Builds OData query URLs
 * 
 * Provides a fluent API for constructing OData queries with support for
 * all standard query options ($filter, $orderby, $top, $skip, etc.)
 */
class ODataQueryBuilder {
    private string _entitySet;
    private string _filterExpression;
    private string _orderByExpression;
    private int _topCount = -1;
    private int _skipCount = -1;
    private string[] _selectFields;
    private string[] _expandNavigations;
    private bool _includeCount = false;
    private string _searchExpression;
    private string[string] _customParams;

    /**
     * Constructor
     * 
     * Params:
     *   entitySet = The entity set name (e.g., "Products", "Customers")
     */
    this(string entitySet) {
        _entitySet = entitySet;
    }

    /**
     * Sets the filter expression ($filter)
     * 
     * Params:
     *   expression = The filter expression (e.g., "Price gt 20")
     */
    ODataQueryBuilder filter(string expression) {
        _filterExpression = expression;
        return this;
    }

    /**
     * Sets the filter using a filter builder
     */
    ODataQueryBuilder filter(ODataFilter filterBuilder) {
        _filterExpression = filterBuilder.build();
        return this;
    }

    /**
     * Sets the order by expression ($orderby)
     * 
     * Params:
     *   expression = The order expression (e.g., "Name asc", "Price desc")
     */
    ODataQueryBuilder orderBy(string expression) {
        _orderByExpression = expression;
        return this;
    }

    /**
     * Sets the top count ($top) - limits results
     * 
     * Params:
     *   count = Maximum number of results to return
     */
    ODataQueryBuilder top(int count) {
        if (count < 0) {
            throw new ODataQueryException("Top count must be non-negative");
        }
        _topCount = count;
        return this;
    }

    /**
     * Sets the skip count ($skip) - for pagination
     * 
     * Params:
     *   count = Number of results to skip
     */
    ODataQueryBuilder skip(int count) {
        if (count < 0) {
            throw new ODataQueryException("Skip count must be non-negative");
        }
        _skipCount = count;
        return this;
    }

    /**
     * Sets the select fields ($select)
     * 
     * Params:
     *   fields = Array of field names to select
     */
    ODataQueryBuilder select(string[] fields) {
        _selectFields = fields.dup;
        return this;
    }

    /**
     * Adds a field to select
     */
    ODataQueryBuilder select(string field) {
        _selectFields ~= field;
        return this;
    }

    /**
     * Sets the expand navigations ($expand)
     * 
     * Params:
     *   navigation = Navigation property to expand
     */
    ODataQueryBuilder expand(string navigation) {
        _expandNavigations ~= navigation;
        return this;
    }

    /**
     * Sets multiple expand navigations
     */
    ODataQueryBuilder expand(string[] navigations) {
        _expandNavigations ~= navigations;
        return this;
    }

    /**
     * Includes count in response ($count)
     * 
     * Params:
     *   include = Whether to include count
     */
    ODataQueryBuilder count(bool include = true) {
        _includeCount = include;
        return this;
    }

    /**
     * Sets the search expression ($search)
     * 
     * Params:
     *   expression = The search expression
     */
    ODataQueryBuilder search(string expression) {
        _searchExpression = expression;
        return this;
    }

    /**
     * Adds a custom query parameter
     * 
     * Params:
     *   name = Parameter name
     *   value = Parameter value
     */
    ODataQueryBuilder customParam(string name, string value) {
        _customParams[name] = value;
        return this;
    }

    /**
     * Builds the complete OData query URL
     * 
     * Returns: The complete URL with query string
     */
    string build() const {
        return _entitySet ~ buildQueryString();
    }

    /**
     * Builds just the query string part
     * 
     * Returns: The query string (e.g., "?$filter=Price gt 20&$top=10")
     */
    string buildQueryString() const {
        auto params = appender!(string[]);

        if (_filterExpression.length > 0) {
            params ~= "$filter=" ~ encodeComponent(_filterExpression);
        }

        if (_orderByExpression.length > 0) {
            params ~= "$orderby=" ~ encodeComponent(_orderByExpression);
        }

        if (_topCount >= 0) {
            params ~= "$top=" ~ _topCount.to!string;
        }

        if (_skipCount >= 0) {
            params ~= "$skip=" ~ _skipCount.to!string;
        }

        if (_selectFields.length > 0) {
            params ~= "$select=" ~ encodeComponent(_selectFields.join(","));
        }

        if (_expandNavigations.length > 0) {
            params ~= "$expand=" ~ encodeComponent(_expandNavigations.join(","));
        }

        if (_includeCount) {
            params ~= "$count=true";
        }

        if (_searchExpression.length > 0) {
            params ~= "$search=" ~ encodeComponent(_searchExpression);
        }

        foreach (key, value; _customParams) {
            params ~= key ~ "=" ~ encodeComponent(value);
        }

        if (params.data.length == 0) {
            return "";
        }

        return "?" ~ params.data.join("&");
    }

    /**
     * Gets the entity set name
     */
    string entitySet() const {
        return _entitySet;
    }

    /**
     * Clears all query options
     */
    void clear() {
        _filterExpression = "";
        _orderByExpression = "";
        _topCount = -1;
        _skipCount = -1;
        _selectFields.length = 0;
        _expandNavigations.length = 0;
        _includeCount = false;
        _searchExpression = "";
        _customParams.clear();
    }
}

// Unit tests
unittest {
    auto query = new ODataQueryBuilder("Products");
    assert(query.build() == "Products");
}

unittest {
    auto query = new ODataQueryBuilder("Products");
    query.filter("Price gt 20");
    auto url = query.build();
    assert(url.startsWith("Products?"));
    assert(url.indexOf("$filter=") > 0);
}

unittest {
    auto query = new ODataQueryBuilder("Products");
    query.filter("Price gt 20")
         .orderBy("Name")
         .top(10)
         .skip(0);
    
    auto queryString = query.buildQueryString();
    assert(queryString.indexOf("$filter=") >= 0);
    assert(queryString.indexOf("$orderby=") >= 0);
    assert(queryString.indexOf("$top=10") >= 0);
    assert(queryString.indexOf("$skip=0") >= 0);
}

unittest {
    auto query = new ODataQueryBuilder("Customers");
    query.select(["Name", "Email", "Phone"])
         .expand("Orders");
    
    auto queryString = query.buildQueryString();
    assert(queryString.indexOf("$select=") >= 0);
    assert(queryString.indexOf("$expand=") >= 0);
}

unittest {
    auto query = new ODataQueryBuilder("Products");
    auto filter = new ODataFilter();
    filter.greaterThan("Price", 50)
          .and()
          .lessThan("Price", 100);
    
    query.filter(filter);
    auto url = query.build();
    assert(url.indexOf("Price") > 0);
}
