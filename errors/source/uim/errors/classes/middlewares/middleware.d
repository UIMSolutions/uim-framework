/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.errors.classes.middlewares.middleware;

import uim.errors;

@safe:

/**
 * Base implementation of error middleware.
 * 
 * Provides common functionality for all middleware implementations including
 * priority management, enable/disable functionality, and basic error filtering.
 */
abstract class ErrorMiddleware : UIMObject, IErrorMiddleware {
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

    return true;
  }

  // Priority for middleware execution order (higher executes first)
  protected int _priority = 0;
  
  // Whether this middleware is enabled
  protected bool _enabled = true;

  // #region priority
  int priority() {
    return _priority;
  }

  ErrorMiddleware priority(int newPriority) {
    _priority = newPriority;
    return this;
  }
  // #endregion priority

  // #region enabled
  IErrorMiddleware enabled(bool newEnabled) {
    _enabled = newEnabled;
    return this;
  }

  bool isEnabled() {
    return _enabled;
  }
  // #endregion enabled

  /**
   * Default implementation always returns true.
   * Override in subclasses to add filtering logic.
   */
  bool shouldProcess(IError error) {
    return _enabled;
  }

  /**
   * Process the error. Must be implemented by subclasses.
   */
  abstract IError process(IError error, IError delegate(IError) @safe next);
}
