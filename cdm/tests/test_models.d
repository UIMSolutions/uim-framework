/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module tests.test_models;

import uim.cdm;

@safe:

unittest {
    // Test Contact model
    auto contact = new Contact();
    contact
        .firstName("John")
        .lastName("Doe")
        .email("john@example.com");

    assert(contact.fullName() == "John Doe");
    assert(contact.isValid());
}

unittest {
    // Test Account model
    auto account = new Account();
    account
        .name("Test Company")
        .accountNumber("ACC-001")
        .revenue(100000.0);

    assert(account.name() == "Test Company");
    assert(account.revenue() == 100000.0);
}

unittest {
    // Test Product model
    auto product = new Product();
    product
        .name("Test Product")
        .sku("TEST-001")
        .price(100.0)
        .cost(60.0)
        .stockQuantity(50)
        .reorderLevel(10);

    assert(product.sku() == "TEST-001");
    assert(product.needsReorder() == false);
    assert(product.margin() == 40.0);
}
