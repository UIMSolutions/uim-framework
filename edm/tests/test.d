/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module edm.tests.test;

import uim.edm;
import std.stdio;

@safe:

// Test primitive types
unittest {
    writeln("Testing EDM Primitive Types...");
    
    assert(isPrimitiveType("Edm.String"));
    assert(isPrimitiveType("Edm.Int32"));
    assert(isPrimitiveType("Edm.Boolean"));
    assert(!isPrimitiveType("Custom.Type"));
    
    auto stringType = primitiveType(EdmPrimitiveType.String);
    assert(stringType !is null);
    assert(stringType.name() == "Edm.String");
    
    writeln("  ✓ Primitive types work correctly");
}

// Test schema creation
unittest {
    writeln("Testing EDM Schema...");
    
    auto schema = createSchema("Test.Namespace", "Test");
    assert(schema !is null);
    assert(schema.namespace() == "Test.Namespace");
    assert(schema.alias_() == "Test");
    
    writeln("  ✓ Schema creation works");
}

// Test entity type
unittest {
    writeln("Testing EDM Entity Type...");
    
    auto schema = createSchema("Test.Models");
    auto personType = schema.createEntityType("Person");
    
    assert(personType !is null);
    assert(personType.name() == "Person");
    assert(personType.fullName() == "Test.Models.Person");
    assert(personType.typeKind() == EdmTypeKind.Entity);
    
    // Add properties
    personType
        .addProperty("Id", primitiveType(EdmPrimitiveType.Int32), false)
        .addProperty("Name", primitiveType(EdmPrimitiveType.String), false);
    
    assert(personType.declaredProperties().length == 2);
    
    // Add key
    personType.addKey("Id");
    assert(personType.keyProperties().length == 1);
    
    writeln("  ✓ Entity type creation and properties work");
}

// Test complex type
unittest {
    writeln("Testing EDM Complex Type...");
    
    auto schema = createSchema("Test.Models");
    auto addressType = schema.createComplexType("Address");
    
    assert(addressType !is null);
    assert(addressType.name() == "Address");
    assert(addressType.typeKind() == EdmTypeKind.Complex);
    
    addressType
        .addProperty("Street", primitiveType(EdmPrimitiveType.String), false)
        .addProperty("City", primitiveType(EdmPrimitiveType.String), false);
    
    assert(addressType.declaredProperties().length == 2);
    
    writeln("  ✓ Complex type creation works");
}

// Test navigation properties
unittest {
    writeln("Testing EDM Navigation Properties...");
    
    auto schema = createSchema("Test.Models");
    
    auto customerType = schema.createEntityType("Customer")
        .addProperty("Id", primitiveType(EdmPrimitiveType.Int32), false);
    
    auto orderType = schema.createEntityType("Order")
        .addProperty("Id", primitiveType(EdmPrimitiveType.Int32), false);
    
    // Add navigation
    auto ordersNav = customerType.addNavigationProperty("Orders", orderType, true);
    assert(ordersNav !is null);
    assert(ordersNav.isCollection() == true);
    
    auto customerNav = orderType.addNavigationProperty("Customer", customerType, false);
    assert(customerNav !is null);
    assert(customerNav.isCollection() == false);
    
    writeln("  ✓ Navigation properties work");
}

// Test type inheritance
unittest {
    writeln("Testing EDM Type Inheritance...");
    
    auto schema = createSchema("Test.Models");
    
    auto personType = schema.createEntityType("Person")
        .addProperty("Id", primitiveType(EdmPrimitiveType.Int32), false)
        .addProperty("Name", primitiveType(EdmPrimitiveType.String), false);
    
    auto employeeType = schema.createEntityType("Employee")
        .baseType(personType)
        .addProperty("EmployeeId", primitiveType(EdmPrimitiveType.String), false);
    
    assert(employeeType.baseType() !is null);
    assert(employeeType.baseType() == personType);
    
    // Employee should have 3 properties (2 inherited + 1 declared)
    assert(employeeType.declaredProperties().length == 1);
    assert(employeeType.properties().length == 3);
    
    writeln("  ✓ Type inheritance works");
}

// Test finding types and properties
unittest {
    writeln("Testing EDM Type and Property Lookup...");
    
    auto schema = createSchema("Test.Models");
    auto personType = schema.createEntityType("Person")
        .addProperty("Id", primitiveType(EdmPrimitiveType.Int32), false)
        .addProperty("Name", primitiveType(EdmPrimitiveType.String), false);
    
    // Find type
    auto foundType = schema.findType("Person");
    assert(foundType !is null);
    assert(foundType.name() == "Person");
    
    // Find property
    auto idProp = personType.findProperty("Id");
    assert(idProp !is null);
    assert(idProp.name() == "Id");
    
    auto nameProp = personType.findProperty("Name");
    assert(nameProp !is null);
    
    writeln("  ✓ Type and property lookup works");
}

void main() {
    writeln("\n=== Running EDM Tests ===\n");
    writeln("All tests passed! ✓\n");
}
