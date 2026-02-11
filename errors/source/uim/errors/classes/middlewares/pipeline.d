/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.errors.classes.middlewares.pipeline;

import uim.errors;

@safe:

/**
 * Pipeline that chains multiple error middleware together.
 * 
 * Middleware are executed in priority order (highest first).
 * Each middleware can:
 * - Pass the error to the next middleware
 * - Transform the error
 * - Filter the error (return null)
 * - Short-circuit the pipeline
 */
class ErrorMiddlewarePipeline : UIMObject {
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

  // Registered middleware
  protected IErrorMiddleware[] _middleware;
  
  // Whether the pipeline has been sorted by priority
  protected bool _sorted = false;

  /**
   * Add middleware to the pipeline.
   */
  ErrorMiddlewarePipeline add(IErrorMiddleware middleware) {
    _middleware ~= middleware;
    _sorted = false;
    return this;
  }

  /**
   * Add multiple middleware to the pipeline.
   */
  ErrorMiddlewarePipeline addAll(IErrorMiddleware[] middleware) {
    _middleware ~= middleware;
    _sorted = false;
    return this;
  }

  /**
   * Remove middleware from the pipeline.
   */
  ErrorMiddlewarePipeline remove(IErrorMiddleware middleware) {
    import std.algorithm : remove, countUntil;
    
    // TODO : Syntax issue with remove, needs investigation
    /* 
    auto index = _middleware.countUntil(middleware);
    if (index >= 0) {
      _middleware = _middleware.remove(index);
    }
    */ 
    
    return this;
  }

  /**
   * Clear all middleware from the pipeline.
   */
  ErrorMiddlewarePipeline clear() {
    _middleware = [];
    _sorted = false;
    return this;
  }

  /**
   * Get all middleware in the pipeline.
   */
  IErrorMiddleware[] middleware() {
    return _middleware;
  }

  /**
   * Process an error through the pipeline.
   * 
   * Returns:
   *   The processed error, or null if filtered
   */
  IError process(IError error) {
    if (_middleware.length == 0) {
      return error;
    }

    // Sort middleware by priority if needed
    if (!_sorted) {
      sortMiddleware();
    }

    // Start the pipeline
    return executeMiddleware(error, 0);
  }

  protected void sortMiddleware() @trusted {
    _middleware = _middleware
      .sort!((a, b) => a.priority() > b.priority())
      .array;
    _sorted = true;
  }

  protected IError executeMiddleware(IError error, size_t index) {
    if (index >= _middleware.length) {
      // End of pipeline, return the error
      return error;
    }

    auto current = _middleware[index];
    
    // Skip disabled middleware
    if (!current.isEnabled() || !current.shouldProcess(error)) {
      return executeMiddleware(error, index + 1);
    }

    // Execute current middleware with continuation
    return current.process(error, (IError err) {
      if (err is null) {
        // Error was filtered, stop pipeline
        return null;
      }
      // Continue to next middleware
      return executeMiddleware(err, index + 1);
    });
  }

  /**
   * Create a new pipeline with standard middleware.
   */
  static ErrorMiddlewarePipeline standard() {
    auto pipeline = new ErrorMiddlewarePipeline();
    
    // Add logging middleware (high priority)
    pipeline.add(loggingMiddleware());
    
    return pipeline;
  }
}

/**
 * Create a new empty middleware pipeline.
 */
ErrorMiddlewarePipeline errorPipeline() {
  return new ErrorMiddlewarePipeline();
}

/**
 * Create a pipeline with standard middleware.
 */
ErrorMiddlewarePipeline standardErrorPipeline() {
  return ErrorMiddlewarePipeline.standard();
}
