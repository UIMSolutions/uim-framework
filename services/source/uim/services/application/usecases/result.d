/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.services.application.usecases.result;

import uim.services;

mixin(ShowModule!());

@safe:

/// UsecaseResult represents the result of a use case execution.
struct UsecaseResult {
  /// Indicates whether the use case was successful.
  bool success = false;
  /// The ID of the resource affected by the use case, if applicable.
  string id  = "";
  /// A message providing additional information about the use case result.
  string message  = "";
  /// An optional error code associated with the use case result.
  size_t code = 0;
  /// A JSON representation of the UsecaseResult.
  Json data = Json.emptyObject;

  this(bool success, string id = "", string message = "", size_t code = 0, Json data = Json.emptyObject) {
    this.success = success;
    this.id = id;
    this.message = message;
    this.code = code;
    this.data = data;
  }

  /// Returns true if the use case was successful, false otherwise.
  bool isSuccess() const {
    return success;
  }

  /// Returns true if the use case resulted in an error, false otherwise.
  bool hasError() const {
    return !success && message.length > 0;
  }

  /// Returns the error message if the use case resulted in an error, or an empty string otherwise.
  string errorMessage() const {
    return hasError() ? message : "";
  }

  /// Returns a JSON representation of the UsecaseResult.
  Json toJson() const {
    return Json.emptyObject
      .set("success", success)
      .set("id", id)
      .set("message", message)
      .set("code", code)
      .set("data", data);
  }
}
///
unittest {
  mixin(ShowTest!("UsecaseResult Struct"));

  UsecaseResult r1 = UsecaseResult(true, "123", "");
  assert(r1.isSuccess());
  assert(!r1.hasError());
  assert(r1.id == "123");
  assert(r1.message == "");

  UsecaseResult r2 = UsecaseResult(false, "", "Something went wrong");
  assert(!r2.isSuccess());
  assert(r2.hasError());
  assert(r2.id == "");
  assert(r2.message == "Something went wrong");

  UsecaseResult r3 = UsecaseResult(false, "", "Error occurred", 404);
  assert(!r3.isSuccess());
  assert(r3.hasError());
  assert(r3.id == "");
  assert(r3.message == "Error occurred");
  assert(r3.code == 404);
}
