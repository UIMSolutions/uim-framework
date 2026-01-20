#!/usr/bin/env dub
/+ dub.sdl:
    name "cdm_test_app"
    dependency "uim-framework:cdm" path=".."
+//****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module cdm.test_app;

import uim.cdm;

void main() {
    writeln("=== UIM CDM Library Test ===\n");

    // Test Contact model
    writeln("1. Testing Contact Model:");
    auto contact = new Contact();
    contact
        .name("Jane Smith")
        .firstName("Jane")
        .lastName("Smith")
        .email("jane.smith@example.com")
        .phone("+1-555-9876")
        .title("Senior Developer")
        .city("New York");

    writeln("   Full Name: ", contact.fullName());
    writeln("   Email: ", contact.email());
    writeln("   Is Valid: ", contact.isValid());

    // Test Account model
    writeln("\n2. Testing Account Model:");
    auto account = new Account();
    account
        .name("TechCorp Inc.")
        .accountNumber("ACC-54321")
        .industry("Software")
        .revenue(5000000.0)
        .employeeCount(150);

    writeln("   Name: ", account.name());
    writeln("   Industry: ", account.industry());
    writeln("   Revenue: $", account.revenue());

    // Test Product model
    writeln("\n3. Testing Product Model:");
    auto product = new Product();
    product
        .name("Professional License")
        .sku("LIC-PRO-001")
        .price(299.99)
        .cost(100.00)
        .stockQuantity(1000)
        .reorderLevel(100);

    writeln("   SKU: ", product.sku());
    writeln("   Price: $", product.price());
    writeln("   Margin: ", product.margin(), "%");
    writeln("   Needs Reorder: ", product.needsReorder());

    // Test Schema and Validation
    writeln("\n4. Testing Schema & Validation:");
    auto schema = new Schema("TestEntity");
    schema
        .addField("id", FieldType.UUID, true)
        .addField("name", FieldType.String, true)
        .addField("email", FieldType.String, true);

    auto validator = new SchemaValidator(schema);

    Json validData = Json.emptyObject;
    validData["id"] = "550e8400-e29b-41d4-a716-446655440000";
    validData["name"] = "Test User";
    validData["email"] = "test@example.com";

    auto result = validator.validate(validData);
    writeln("   Valid data test - Is Valid: ", result.isValid());

    Json invalidData = Json.emptyObject;
    invalidData["id"] = "550e8400-e29b-41d4-a716-446655440000";
    // Missing required fields

    auto result2 = validator.validate(invalidData);
    writeln("   Invalid data test - Is Valid: ", result2.isValid());
    writeln("   Error count: ", result2.fieldErrors().length);

    writeln("\n✓ All CDM tests completed successfully!");
}
