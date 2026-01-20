/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module edm.examples.relationships;

import std.stdio;
import uim.edm;

void main() {
    writeln("=== EDM Relationships Example ===\n");
    
    // Create schema
    auto schema = createSchema("Shop.Models");
    
    // Create Customer entity
    auto customerType = schema.createEntityType("Customer")
        .addKey("Id")
        .addProperty("Id", primitiveType(EdmPrimitiveType.Int32), false)
        .addProperty("Name", primitiveType(EdmPrimitiveType.String), false)
        .addProperty("Email", primitiveType(EdmPrimitiveType.String), false);
    
    // Create Order entity
    auto orderType = schema.createEntityType("Order")
        .addKey("Id")
        .addProperty("Id", primitiveType(EdmPrimitiveType.Int32), false)
        .addProperty("OrderDate", primitiveType(EdmPrimitiveType.DateTimeOffset), false)
        .addProperty("TotalAmount", primitiveType(EdmPrimitiveType.Decimal), false);
    
    // Create OrderItem entity
    auto orderItemType = schema.createEntityType("OrderItem")
        .addKey("Id")
        .addProperty("Id", primitiveType(EdmPrimitiveType.Int32), false)
        .addProperty("Quantity", primitiveType(EdmPrimitiveType.Int32), false)
        .addProperty("UnitPrice", primitiveType(EdmPrimitiveType.Decimal), false);
    
    // Create Product entity
    auto productType = schema.createEntityType("Product")
        .addKey("Id")
        .addProperty("Id", primitiveType(EdmPrimitiveType.Int32), false)
        .addProperty("Name", primitiveType(EdmPrimitiveType.String), false)
        .addProperty("Price", primitiveType(EdmPrimitiveType.Decimal), false)
        .addProperty("InStock", primitiveType(EdmPrimitiveType.Int32), false);
    
    writeln("Created entities: Customer, Order, OrderItem, Product\n");
    
    // Add navigation properties
    
    // Customer <-> Orders (one-to-many)
    writeln("Adding Customer <-> Orders relationship (one-to-many)");
    auto ordersNav = customerType.addNavigationProperty("Orders", orderType, true);
    auto customerNav = orderType.addNavigationProperty("Customer", customerType, false);
    ordersNav.partner(customerNav);
    customerNav.partner(ordersNav);
    
    // Order <-> OrderItems (one-to-many)
    writeln("Adding Order <-> OrderItems relationship (one-to-many)");
    auto itemsNav = orderType.addNavigationProperty("Items", orderItemType, true);
    auto orderNav = orderItemType.addNavigationProperty("Order", orderType, false);
    itemsNav.partner(orderNav);
    orderNav.partner(itemsNav);
    
    // OrderItem <-> Product (many-to-one)
    writeln("Adding OrderItem <-> Product relationship (many-to-one)");
    orderItemType.addNavigationProperty("Product", productType, false);
    productType.addNavigationProperty("OrderItems", orderItemType, true);
    
    writeln("\n=== Navigation Properties Summary ===\n");
    
    // Display Customer navigation properties
    writeln("Customer navigation properties:");
    foreach (prop; customerType.declaredProperties()) {
        if (prop.propertyKind() == EdmPropertyKind.Navigation) {
            auto navProp = cast(IEdmNavigationProperty)prop;
            writeln("  - ", prop.name(), " -> ", navProp.targetType().name(),
                    " (", (navProp.isCollection() ? "collection" : "single"), ")");
        }
    }
    
    // Display Order navigation properties
    writeln("\nOrder navigation properties:");
    foreach (prop; orderType.declaredProperties()) {
        if (prop.propertyKind() == EdmPropertyKind.Navigation) {
            auto navProp = cast(IEdmNavigationProperty)prop;
            writeln("  - ", prop.name(), " -> ", navProp.targetType().name(),
                    " (", (navProp.isCollection() ? "collection" : "single"), ")");
        }
    }
    
    // Display OrderItem navigation properties
    writeln("\nOrderItem navigation properties:");
    foreach (prop; orderItemType.declaredProperties()) {
        if (prop.propertyKind() == EdmPropertyKind.Navigation) {
            auto navProp = cast(IEdmNavigationProperty)prop;
            writeln("  - ", prop.name(), " -> ", navProp.targetType().name(),
                    " (", (navProp.isCollection() ? "collection" : "single"), ")");
        }
    }
    
    // Display Product navigation properties
    writeln("\nProduct navigation properties:");
    foreach (prop; productType.declaredProperties()) {
        if (prop.propertyKind() == EdmPropertyKind.Navigation) {
            auto navProp = cast(IEdmNavigationProperty)prop;
            writeln("  - ", prop.name(), " -> ", navProp.targetType().name(),
                    " (", (navProp.isCollection() ? "collection" : "single"), ")");
        }
    }
}
