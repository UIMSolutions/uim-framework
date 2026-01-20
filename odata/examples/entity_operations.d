/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module examples.entity_operations;

import uim.odata;
import std.stdio;
import std.json;

void main() {
    writeln("=== OData Entity Operations Examples ===\n");
    
    // Example 1: Create a simple entity
    writeln("Example 1: Create Entity");
    auto product = new ODataEntity("Product");
    product.set("ProductID", 1);
    product.set("ProductName", "Chai");
    product.set("UnitPrice", 18.0);
    product.set("UnitsInStock", 39);
    product.set("Discontinued", false);
    
    writeln("Entity Type: ", product.entityType);
    writeln("JSON representation:");
    writeln(product.toJSON());
    writeln();
    
    // Example 2: Read properties
    writeln("Example 2: Read Properties");
    writeln("Product Name: ", product.getString("ProductName"));
    writeln("Unit Price: ", product.getFloat("UnitPrice"));
    writeln("Units in Stock: ", product.getInt("UnitsInStock"));
    writeln("Discontinued: ", product.getBool("Discontinued"));
    writeln();
    
    // Example 3: Check property existence
    writeln("Example 3: Property Existence");
    writeln("Has ProductName: ", product.has("ProductName"));
    writeln("Has Category: ", product.has("Category"));
    writeln();
    
    // Example 4: Load from JSON
    writeln("Example 4: Load from JSON");
    string jsonStr = `{
        "CustomerID": "ALFKI",
        "CompanyName": "Alfreds Futterkiste",
        "ContactName": "Maria Anders",
        "Country": "Germany"
    }`;
    
    auto customer = ODataEntity.fromJSON("Customer", jsonStr);
    writeln("Customer Name: ", customer.getString("CompanyName"));
    writeln("Contact: ", customer.getString("ContactName"));
    writeln();
    
    // Example 5: Clone an entity
    writeln("Example 5: Clone Entity");
    auto productCopy = product.clone();
    productCopy.set("ProductName", "Chai (Copy)");
    
    writeln("Original: ", product.getString("ProductName"));
    writeln("Copy: ", productCopy.getString("ProductName"));
    writeln();
    
    // Example 6: Merge entities
    writeln("Example 6: Merge Entities");
    auto update = new ODataEntity("Product");
    update.set("UnitPrice", 19.99);
    update.set("UnitsInStock", 35);
    
    writeln("Before merge:");
    writeln("  Price: ", product.getFloat("UnitPrice"));
    writeln("  Stock: ", product.getInt("UnitsInStock"));
    
    product.merge(update);
    
    writeln("After merge:");
    writeln("  Price: ", product.getFloat("UnitPrice"));
    writeln("  Stock: ", product.getInt("UnitsInStock"));
    writeln();
    
    // Example 7: List all properties
    writeln("Example 7: List Properties");
    auto order = new ODataEntity("Order");
    order.set("OrderID", 10248);
    order.set("CustomerID", "VINET");
    order.set("OrderDate", "2023-07-04");
    order.set("ShipCountry", "France");
    
    writeln("Order properties:");
    foreach (prop; order.propertyNames()) {
        writeln("  ", prop, ": ", order.get(prop));
    }
    writeln();
    
    // Example 8: Remove properties
    writeln("Example 8: Remove Properties");
    writeln("Properties before removal: ", order.propertyNames());
    order.remove("ShipCountry");
    writeln("Properties after removal: ", order.propertyNames());
    writeln();
    
    // Example 9: Working with complex objects
    writeln("Example 9: Complex Objects");
    auto employee = new ODataEntity("Employee");
    employee.set("EmployeeID", 1);
    employee.set("FirstName", "Nancy");
    employee.set("LastName", "Davolio");
    
    // Add address as JSON object
    JSONValue address = parseJSON(`{
        "Street": "507 - 20th Ave. E.",
        "City": "Seattle",
        "PostalCode": "98122",
        "Country": "USA"
    }`);
    employee.set("Address", address);
    
    writeln("Employee with complex address:");
    writeln(employee.toJSON());
    writeln();
}
