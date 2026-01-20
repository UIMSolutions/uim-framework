/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module odata.examples.client_usage;

import uim.odata;
import std.stdio;

/**
 * This example demonstrates how to use the OData client
 * to interact with an OData service.
 * 
 * Note: This example uses the public TripPin OData service for demonstration.
 * You can run this against a local OData service as well.
 */

void main() {
    writeln("=== OData Client Usage Examples ===\n");
    
    // Initialize the client with the service root URL
    auto client = new ODataClient("https://services.odata.org/V4/TripPinServiceRW/");
    
    // Set optional headers (authentication, etc.)
    client.setHeader("Authorization", "Bearer your-token-here");
    client.setTimeout(60); // Set timeout to 60 seconds
    
    // Example 1: Simple query
    writeln("Example 1: Simple Query");
    try {
        auto query1 = client.query("People")
            .top(5)
            .select(["FirstName", "LastName", "UserName"]);
        
        writeln("Query URL: ", query1.build());
        // Uncomment to execute:
        // string result = client.execute(query1);
        // writeln("Result: ", result);
    } catch (ODataException e) {
        writeln("Error: ", e.msg);
    }
    writeln();
    
    // Example 2: Filtered query
    writeln("Example 2: Filtered Query");
    try {
        auto filter = ODataFilter.equals("FirstName", "Russell");
        auto query2 = client.query("People")
            .filter(filter)
            .select(["FirstName", "LastName", "Emails"]);
        
        writeln("Query URL: ", query2.build());
        // Uncomment to execute:
        // string result = client.execute(query2);
        // writeln("Result: ", result);
    } catch (ODataException e) {
        writeln("Error: ", e.msg);
    }
    writeln();
    
    // Example 3: Get single entity
    writeln("Example 3: Get Single Entity");
    try {
        // Uncomment to execute:
        // auto person = client.get("People", "'russellwhyte'");
        // writeln("Person: ", person.toJSON());
    } catch (ODataException e) {
        writeln("Error: ", e.msg);
    }
    writeln();
    
    // Example 4: Create new entity
    writeln("Example 4: Create Entity");
    try {
        auto newPerson = new ODataEntity("Person");
        newPerson.set("UserName", "johndoe");
        newPerson.set("FirstName", "John");
        newPerson.set("LastName", "Doe");
        
        writeln("Entity to create:");
        writeln(newPerson.toJSON());
        
        // Uncomment to execute:
        // auto created = client.create("People", newPerson);
        // writeln("Created entity: ", created.toJSON());
    } catch (ODataException e) {
        writeln("Error: ", e.msg);
    }
    writeln();
    
    // Example 5: Update entity
    writeln("Example 5: Update Entity");
    try {
        auto updates = new ODataEntity("Person");
        updates.set("FirstName", "Johnny");
        
        writeln("Updates to apply:");
        writeln(updates.toJSON());
        
        // Uncomment to execute:
        // auto updated = client.update("People", "'johndoe'", updates);
        // writeln("Updated entity: ", updated.toJSON());
    } catch (ODataException e) {
        writeln("Error: ", e.msg);
    }
    writeln();
    
    // Example 6: Delete entity
    writeln("Example 6: Delete Entity");
    try {
        // Uncomment to execute:
        // client.delete_("People", "'johndoe'");
        // writeln("Entity deleted successfully");
    } catch (ODataException e) {
        writeln("Error: ", e.msg);
    }
    writeln();
    
    // Example 7: Complex query with multiple options
    writeln("Example 7: Complex Query");
    try {
        auto complexFilter = ODataFilter.and(
            ODataFilter.contains("FirstName", "r"),
            ODataFilter.greaterThan("Age", 25)
        );
        
        auto query7 = client.query("People")
            .filter(complexFilter)
            .orderBy("LastName")
            .select(["FirstName", "LastName", "Age"])
            .expand(["Trips"])
            .top(10)
            .skip(5);
        
        writeln("Query URL: ", query7.build());
        // Uncomment to execute:
        // string result = client.execute(query7);
        // writeln("Result: ", result);
    } catch (ODataException e) {
        writeln("Error: ", e.msg);
    }
    writeln();
    
    // Example 8: Get service metadata
    writeln("Example 8: Get Metadata");
    try {
        // Uncomment to execute:
        // string metadata = client.getMetadata();
        // writeln("Metadata: ", metadata);
    } catch (ODataException e) {
        writeln("Error: ", e.msg);
    }
    writeln();
    
    // Example 9: Get service document
    writeln("Example 9: Get Service Document");
    try {
        // Uncomment to execute:
        // string serviceDoc = client.getServiceDocument();
        // writeln("Service Document: ", serviceDoc);
    } catch (ODataException e) {
        writeln("Error: ", e.msg);
    }
    writeln();
    
    writeln("Note: Most HTTP calls are commented out to avoid hitting the actual service.");
    writeln("Uncomment the execute() calls to test against a real OData service.");
}
