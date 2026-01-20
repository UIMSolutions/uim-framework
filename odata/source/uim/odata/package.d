/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.odata;

/**
 * UIM OData Library
 * 
 * A comprehensive D library for working with OData (Open Data Protocol) services.
 * OData is an open protocol to allow the creation and consumption of queryable 
 * and interoperable RESTful APIs in a simple and standard way.
 * 
 * Features:
 * - OData v4 query building with filter expressions
 * - Entity management and serialization
 * - HTTP client for consuming OData services
 * - Full support for OData query options ($filter, $orderby, $top, $skip, etc.)
 * - Type-safe filter expression building
 * - JSON serialization/deserialization
 * 
 * Example:
 * ---
 * import uim.odata;
 * 
 * // Create a client
 * auto client = new ODataClient("https://services.odata.org/V4/TripPinService/");
 * 
 * // Build a query
 * auto query = client.query("People")
 *     .filter(ODataFilter.equals("FirstName", "Russell"))
 *     .select(["FirstName", "LastName"])
 *     .top(10);
 * 
 * // Execute query
 * string result = client.execute(query);
 * 
 * // Create a new entity
 * auto person = new ODataEntity("Person");
 * person.set("FirstName", "John");
 * person.set("LastName", "Doe");
 * auto created = client.create("People", person);
 * ---
 */
public import uim.jsons;

public {
    import uim.odata.exceptions;
    import uim.odata.filter;
    import uim.odata.query;
    import uim.odata.entity;
    import uim.odata.client;
}