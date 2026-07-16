/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.services.presentation.http.controllers.response;

import uim.services;

mixin(ShowModule!());

@safe:

bool hasError(Json data) {
    if (data.isNull || !data.hasKey("status")) {
        return true;
    }
    auto status = data.getString("status");
    return status == "error";
}
///
unittest {
    auto errorJson = Json.emptyObject.set("status", "error").set("error", "Something went wrong");
    assert(hasError(errorJson) == true);

    auto successJson = Json.emptyObject.set("status", "success").set("data", "All good");
    assert(hasError(successJson) == false);

    auto invalidJson = Json.emptyObject.set("message", "No status field");
    assert(hasError(invalidJson) == true);
}

Json errorResponse(string message = "Internal Server Error", int code = 500) {
    return Json.emptyObject
        .set("status", "error")
        .set("message", message)
        .set("category", "General")
        .set("code", code);
}
///
unittest {
    auto response = errorResponse("Not Found", 404);
    assert(response.getString("status") == "error");
    assert(response.getString("message") == "Not Found");
    assert(response.getInteger("code") == 404);
    assert(response.getString("category") == "General");
}

Json errorResponse(string message = "Internal Server Error", string category, int code = 500) {
    return Json.emptyObject
        .set("status", "error")
        .set("message", message)
        .set("category", category)
        .set("code", code);
}
///
unittest {
    auto response = errorResponse("Not Found", "General", 404);
    assert(response.getString("status") == "error");
    assert(response.getString("message") == "Not Found");
    assert(response.getInteger("code") == 404);
    assert(response.getString("category") == "General");
}

Json errorResponse(Json json, string message = "Internal Server Error", int code = 500) {
    return json.isObject ? json
        .set("status", "error")
        .set("message", message)
        .set("code", code) : errorResponse(message, code);
}
///
unittest {
    auto baseJson = Json.emptyObject.set("info", "Additional info");
    auto response = errorResponse(baseJson, "Bad Request", 400);
    assert(response.getString("status") == "error");
    assert(response.getString("message") == "Bad Request");
    assert(response.getInteger("code") == 400);
    assert(response.getString("info") == "Additional info");
}


Json successResponse(string message = "Success", int code = 200) {
    return Json.emptyObject
        .set("status", "success")
        .set("message", message)
        .set("code", code);
}
///
unittest {
    auto response = successResponse("Operation completed", 201);
    assert(response.getString("status") == "success");
    assert(response.getString("message") == "Operation completed");
    assert(response.getInteger("code") == 201);
}

Json successResponse(string message = "Success", int code = 200, Json data) {
    return Json.emptyObject
        .set("status", "success")
        .set("message", message)
        .set("code", code)
        .set("data", data);
}
///
unittest {
    auto data = Json.emptyObject.set("id", 123).set("name", "Test");
    auto response = successResponse("Data retrieved", 200, data);
    assert(response.getString("status") == "success");
    assert(response.getString("message") == "Data retrieved");
    assert(response.getInteger("code") == 200);
    assert(response["data"].getInteger("id") == 123);
    assert(response["data"].getString("name") == "Test");
}

Json successResponse(string message, string status, int code = 200, Json data) {
    return Json.emptyObject
        .set("status", status)
        .set("message", message)
        .set("code", code)
        .set("data", data);
}

Json successResponse(Json json, string message = "Success", int code = 200) {
    return json.isObject ? json
        .set("status", "success")
        .set("message", message)
        .set("code", code) : successResponse(message, code);
}
///
unittest {
    auto baseJson = Json.emptyObject.set("info", "Additional info");
    auto response = successResponse(baseJson, "Operation successful", 200);
    assert(response.getString("status") == "success");
    assert(response.getString("message") == "Operation successful");
    assert(response.getInteger("code") == 200);
    assert(response.getString("info") == "Additional info");
}

Json successResponse(Json json, string message = "Success", int code = 200, Json data) {
    return json.isObject ? json
        .set("status", "success")
        .set("message", message)
        .set("code", code)
        .set("data", data) : successResponse(message, code);
}

Json successResponse(string message = "Success", int code = 200, CommandResult result) {
    return Json.emptyObject
        .set("status", "success")
        .set("message", message)
        .set("code", code)
        .set("data", Json.emptyObject
            .set("success", result.success)
            .set("message", result.message)
            .set("id", result.id));
}

///
unittest {
    auto baseJson = Json.emptyObject.set("info", "Additional info");
    auto data = Json.emptyObject.set("id", 123).set("name", "Test");
    // auto response = successResponse("Operation successful", 200, CommandResult(true, "Operation completed", 123));
    // assert(response.getString("status") == "success");
    // assert(response.getString("message") == "Operation successful");
    // assert(response.getInteger("code") == 200);
    // assert(response.getString("info") == "Additional info");
    // assert(response["data"].getInteger("id") == 123);
    // assert(response["data"].getString("name") == "Test");
}

int code(Json response) {
    if (response.isNull || !response.hasKey("code")) {
        return 500; // Default to 500 if no status code is provided
    }
    return response.getInteger("code");
}

string path(Json response) {
    if (response.isNull || !response.hasKey("path")) {
        return "/"; // Default to root path if no path is provided
    }
    return response.getString("path");
}

string statusMessage(Json response) {
    if (response.isNull || !response.hasKey("message")) {
        return "Internal Server Error"; // Default message
    }
    return response.getString("message");
}

unittest {
    auto response = successResponse("Operation completed", 201);
    assert(code(response) == 201);
    assert(statusMessage(response) == "Operation completed");

    auto errorResp = errorResponse("Not Found", 404);
    assert(code(errorResp) == 404);
    assert(statusMessage(errorResp) == "Not Found");

    auto invalidResp = Json.emptyObject; // No code or message
    assert(code(invalidResp) == 500);
    assert(statusMessage(invalidResp) == "Internal Server Error");
}