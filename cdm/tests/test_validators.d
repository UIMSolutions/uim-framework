/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module tests.test_validators;

import uim.cdm;

@safe:

unittest {
    // Test validation result
    auto result = new ValidationResult();
    assert(result.isValid());

    result.addError("Test error");
    assert(!result.isValid());
    assert(result.errors().length == 1);
}

unittest {
    // Test schema validator with valid data
    auto schema = new Schema("Test");
    schema.addField("name", FieldType.String, true);

    auto validator = new SchemaValidator(schema);
    
    Json data = Json.emptyObject;
    data["name"] = "Test Name";

    auto result = validator.validate(data);
    assert(result.isValid());
}

unittest {
    // Test schema validator with invalid data
    auto schema = new Schema("Test");
    schema.addField("name", FieldType.String, true);

    auto validator = new SchemaValidator(schema);
    
    Json data = Json.emptyObject;
    // Missing required field

    auto result = validator.validate(data);
    assert(!result.isValid());
}
