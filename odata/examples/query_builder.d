/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module examples.query_builder;

import uim.odata;
import std.stdio;

void main() {
    writeln("=== OData Query Builder Examples ===\n");
    
    // Example 1: Basic query with filter and sorting
    writeln("Example 1: Basic Query");
    auto query1 = new ODataQueryBuilder("Products");
    query1
        .filter(ODataFilter.greaterThan("Price", 20.0))
        .orderBy("ProductName")
        .top(10);
    
    writeln("URL: ", query1.build());
    writeln();
    
    // Example 2: Complex filter expression
    writeln("Example 2: Complex Filter");
    auto filter = ODataFilter.and(
        ODataFilter.greaterThan("Price", 10.0),
        ODataFilter.lessThan("Price", 50.0),
        ODataFilter.equals("Category", "Electronics")
    );
    
    auto query2 = new ODataQueryBuilder("Products");
    query2.filter(filter);
    
    writeln("URL: ", query2.build());
    writeln();
    
    // Example 3: String functions
    writeln("Example 3: String Functions");
    auto filter3 = ODataFilter.or(
        ODataFilter.startsWith("ProductName", "Chai"),
        ODataFilter.contains("Description", "beverage")
    );
    
    auto query3 = new ODataQueryBuilder("Products");
    query3.filter(filter3).select(["ProductName", "Description"]);
    
    writeln("URL: ", query3.build());
    writeln();
    
    // Example 4: Pagination
    writeln("Example 4: Pagination");
    auto query4 = new ODataQueryBuilder("Customers");
    query4
        .orderBy("CompanyName")
        .skip(20)
        .top(10);
    
    writeln("URL: ", query4.build());
    writeln();
    
    // Example 5: Selecting specific fields
    writeln("Example 5: Field Selection");
    auto query5 = new ODataQueryBuilder("Orders");
    query5
        .select(["OrderID", "OrderDate", "ShipName"])
        .expand(["Customer", "OrderDetails"]);
    
    writeln("URL: ", query5.build());
    writeln();
    
    // Example 6: Count query
    writeln("Example 6: Count Query");
    auto query6 = new ODataQueryBuilder("Products");
    query6
        .filter(ODataFilter.greaterThan("UnitsInStock", 0))
        .count(true);
    
    writeln("URL: ", query6.build());
    writeln();
    
    // Example 7: Search functionality
    writeln("Example 7: Search");
    auto query7 = new ODataQueryBuilder("Products");
    query7
        .search("coffee OR tea")
        .top(5);
    
    writeln("URL: ", query7.build());
    writeln();
    
    // Example 8: Date functions
    writeln("Example 8: Date Filtering");
    auto filter8 = ODataFilter.and(
        ODataFilter.year("OrderDate", 2023),
        ODataFilter.greaterOrEqual("OrderDate", "2023-06-01")
    );
    
    auto query8 = new ODataQueryBuilder("Orders");
    query8.filter(filter8);
    
    writeln("URL: ", query8.build());
    writeln();
    
    // Example 9: Collection operations
    writeln("Example 9: Collection Operations");
    auto filter9 = ODataFilter.any("OrderDetails", "d", "d/Quantity gt 10");
    
    auto query9 = new ODataQueryBuilder("Orders");
    query9.filter(filter9);
    
    writeln("URL: ", query9.build());
    writeln();
}
