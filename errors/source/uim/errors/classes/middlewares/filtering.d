/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.errors.classes.middlewares.filtering;

import uim.errors;
import std.algorithm : canFind;

@safe:

/**
 * Middleware that filters errors based on various criteria.
 * 
 * Can filter by:
 * - Error codes
 * - Severity levels
 * - Custom predicates
 * 
 * Filtered errors return null, effectively stopping the middleware chain.
 */
class FilteringMiddleware : ErrorMiddleware {
  mixin(ObjThis!("FilteringMiddleware"));

  // Codes to filter out (block)
  protected int[] _blockedCodes;
  
  // Codes to allow (whitelist)
  protected int[] _allowedCodes;
  
  // Severities to filter out
  protected string[] _blockedSeverities;
  
  // Custom filter predicate
  protected bool delegate(IError) @safe _filterPredicate;

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    _priority = 50; // Medium priority

    return true;
  }

  // #region blockedCodes
  int[] blockedCodes() {
    return _blockedCodes;
  }

  FilteringMiddleware blockedCodes(int[] codes) {
    _blockedCodes = codes;
    return this;
  }

  FilteringMiddleware addBlockedCode(int code) {
    _blockedCodes ~= code;
    return this;
  }
  // #endregion blockedCodes

  // #region allowedCodes
  int[] allowedCodes() {
    return _allowedCodes;
  }

  FilteringMiddleware allowedCodes(int[] codes) {
    _allowedCodes = codes;
    return this;
  }

  FilteringMiddleware addAllowedCode(int code) {
    _allowedCodes ~= code;
    return this;
  }
  // #endregion allowedCodes

  // #region blockedSeverities
  string[] blockedSeverities() {
    return _blockedSeverities;
  }

  FilteringMiddleware blockedSeverities(string[] severities) {
    _blockedSeverities = severities;
    return this;
  }

  FilteringMiddleware addBlockedSeverity(string severity) {
    _blockedSeverities ~= severity;
    return this;
  }
  // #endregion blockedSeverities

  // #region filterPredicate
  FilteringMiddleware filterPredicate(bool delegate(IError) @safe predicate) {
    _filterPredicate = predicate;
    return this;
  }
  // #endregion filterPredicate

  override bool shouldProcess(IError error) {
    if (!_enabled) {
      return false;
    }

    // Check if error should be blocked
    return !isBlocked(error);
  }

  override IError process(IError error, IError delegate(IError) @safe next) {
    if (!shouldProcess(error)) {
      // Filter out this error
      return null;
    }

    // Continue to next middleware
    return next(error);
  }

  protected bool isBlocked(IError error) {
    // Check allowed codes whitelist (if set, only these pass)
    if (_allowedCodes.length > 0 && !canFind(_allowedCodes, error.errorCode())) {
      return true;
    }

    // Check blocked codes
    if (canFind(_blockedCodes, error.errorCode())) {
      return true;
    }

    // Check blocked severities
    if (canFind(_blockedSeverities, error.severity())) {
      return true;
    }

    // Check custom predicate (returns true if should filter)
    if (_filterPredicate !is null && !_filterPredicate(error)) {
      return true;
    }

    return false;
  }
}

/**
 * Create a filtering middleware with default settings.
 */
FilteringMiddleware filteringMiddleware() {
  return new FilteringMiddleware();
}
