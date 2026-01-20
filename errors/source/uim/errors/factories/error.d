/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.errors.factories.error;

mixin(ShowModule!());

import uim.errors;

@safe:

class UIMErrorFactory : UIMFactory!(string, UIMError) {
    this() {
        super(() => new UIMError());
        registerCommonErrors();
    }

    // Register common error types
    private void registerCommonErrors() {
        registerError("InvalidArgument", () => new DInvalidArgumentError());
        registerError("UnknownEditor", () => new DUnknownEditorError());
    }

    // Register a custom error type
    UIMErrorFactory registerError(string errorType, UIMError delegate() creator) {
        this.register(errorType, creator);
        return this;
    }

    // Create error with specific type and message
    UIMError createError(string errorType, string message = null) {
        auto error = create(errorType);
        if (error && message) {
            error.message(message);
        }
        return error;
    }

    // Create error with full parameters
    UIMError createError(string errorType, string message, string fileName, size_t lineNumber) {
        auto error = createError(errorType, message);
        if (error) {
            error.fileName(fileName);
            error.lineNumber(lineNumber);
        }
        return error;
    }

    private static UIMErrorFactory _instance;
    static UIMErrorFactory instance() {
        if (_instance is null) {
            _instance = new UIMErrorFactory();
        }
        return _instance;
    }
}

auto errorFactory() {
    return UIMErrorFactory.instance;
}
