/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
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
  this() {
    super();
  }

  this(Json initData) {
    super(initData.toMap);
  }

  this(Json[string] initData) {
    super(initData);
  }

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    _priority = 50; // Medium priority

    return true;
  }

  // Severities to filter out
  protected string[] _blockedSeverities;

  // Custom filter predicate
  protected bool delegate(IError) @safe _filterPredicate;

  // #region blockedCodes
  // Codes to filter out (block)
  protected int[] _blockedCodes;
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
  // Codes to allow (whitelist)
  protected int[] _allowedCodes;
  /** 
    * Set allowed codes whitelist. If set, only these codes will pass through.
    *
    * If empty, all codes are allowed (subject to blocked codes and other criteria).
    * If non-empty, only codes in this list will be allowed (subject to blocked codes and other criteria).
    *
    * This allows for a "whitelist" approach where only specific codes are allowed, and all others are blocked.
    * If both allowedCodes and blockedCodes are set, allowedCodes is checked first (only those can pass), then blockedCodes is checked (those are blocked even if in allowedCodes).
    * This provides flexible filtering options based on error codes.
    */
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
  /** 
    * Set a custom filter predicate. This is a delegate that takes an IError and returns true if the error should be allowed (not filtered) or false if it should be blocked (filtered out).
    *
    * This allows for complex filtering logic that can't be easily expressed with just codes or severities. For example, you could filter based on message content, file name, or any other property of the error.
    *
    * If this predicate is set, it will be called for each error. If it returns false, the error will be filtered out (return null). If it returns true, the error will continue through the middleware chain (subject to other filters).
    */
  FilteringMiddleware filterPredicate(bool delegate(IError) @safe predicate) {
    _filterPredicate = predicate;
    return this;
  }
  // #endregion filterPredicate

  override bool shouldProcess(IError error) {
    // Always process if enabled
    return _enabled;
  }

  override IError process(IError error, IError delegate(IError) @safe next) {
    if (!_enabled) {
      return next(error);
    }

    // Check if error should be blocked
    if (isBlocked(error)) {
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

  /**
    * Create a filtering middleware with default settings.
    */
  static FilteringMiddleware opCall() {
    return new FilteringMiddleware();
  }
}
