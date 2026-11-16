/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.commands.result;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Result of a command execution.
 */
struct CommandResult {
  bool success;
  string message;
  Json data;

  /// Create a successful result
  static CommandResult ok(string msg = "", Json resultData = Json(null)) {
    return CommandResult(true, msg, resultData);
  }

  /// Create a failed result
  static CommandResult fail(string msg = "Command execution failed", Json resultData = Json(null)) {
    return CommandResult(false, msg, resultData);
  }

  /// Check if the result is successful
  bool isSuccess() const {
    return success;
  }

  /// Check if the result is a failure
  bool isFailure() const {
    return !success;
  }
}




