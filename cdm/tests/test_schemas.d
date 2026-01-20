/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module tests.test_schemas;

import uim.cdm;

@safe:

unittest {
    // Test Schema creation
    auto schema = new Schema("TestEntity");
    schema.addField("id", FieldType.UUID, true);
    schema.addField("name", FieldType.String, true);

    assert(schema.name() == "TestEntity");
    assert(schema.hasField("id"));
    assert(schema.hasField("name"));
    assert(!schema.hasField("nonexistent"));
}

unittest {
    // Test SchemaField
    auto field = new SchemaField("testField", FieldType.String, true);
    field.minLength(5).maxLength(100);

    assert(field.name() == "testField");
    assert(field.type() == FieldType.String);
    assert(field.required());
    assert(field.minLength() == 5);
    assert(field.maxLength() == 100);
}
