/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.cdm.validators.result;

import uim.cdm;

/**
 * Validation result
 */
class ValidationResult : UIMObject {
    mixin(ObjThis!("ValidationResult"));

    protected bool _isValid = true;
    protected string[] _errors;
    protected string[string] _fieldErrors;

    // Property getters
    bool isValid() const { return _isValid && _errors.length == 0; }
    string[] errors() const { return cast(string[])_errors; }
    const(string[string]) fieldErrors() const { return _fieldErrors; }

    auto addError(string error) {
        _isValid = false;
        _errors ~= error;
        return this;
    }

    auto addFieldError(string field, string error) {
        _isValid = false;
        _fieldErrors[field] = error;
        return this;
    }

    Json toJson() const {
        Json result = Json.emptyObject;
        result["isValid"] = isValid;
        result["errors"] = Json.emptyArray;
        foreach (error; _errors) {
            result["errors"] ~= error;
        }
        if (_fieldErrors.length > 0) {
            result["fieldErrors"] = Json.emptyObject;
            foreach (field, error; _fieldErrors) {
                result["fieldErrors"][field] = error;
            }
        }
        return result;
    }
}
