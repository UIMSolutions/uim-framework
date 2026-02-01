/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.errors.classes.middlewares.transforming;

import uim.errors;

@safe:

/**
 * Middleware that transforms errors.
 * 
 * Can:
 * - Modify error properties (message, severity, code)
 * - Add or modify attributes
 * - Wrap errors in different error types
 * - Enrich errors with additional context
 */
class TransformingMiddleware : ErrorMiddleware {
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

    _priority = 25; // Lower priority (transform after logging)

    return true;
  }

  // Transform function
  protected IError delegate(IError) @safe _transformer;
  
  // Whether to transform all errors or only matching ones
  protected bool delegate(IError) @safe _shouldTransform;

  // #region transformer
  TransformingMiddleware transformer(IError delegate(IError) @safe transformer) {
    _transformer = transformer;
    return this;
  }
  // #endregion transformer

  // #region shouldTransform
  TransformingMiddleware shouldTransform(bool delegate(IError) @safe predicate) {
    _shouldTransform = predicate;
    return this;
  }
  // #endregion shouldTransform

  override bool shouldProcess(IError error) {
    if (!_enabled || _transformer is null) {
      return false;
    }

    if (_shouldTransform !is null) {
      return _shouldTransform(error);
    }

    return true;
  }

  override IError process(IError error, IError delegate(IError) @safe next) {
    IError transformed = error;

    if (shouldProcess(error)) {
      transformed = _transformer(error);
    }

    // Continue with transformed error
    return next(transformed);
  }
}

/**
 * Create a transforming middleware with a transformer function.
 */
TransformingMiddleware transformingMiddleware(IError delegate(IError) @safe transformer) {
  auto middleware = new TransformingMiddleware();
  middleware.transformer(transformer);
  return middleware;
}

/**
 * Create a transforming middleware that upgrades severity.
 */
TransformingMiddleware severityUpgradeMiddleware(string fromSeverity, string toSeverity) {
  auto middleware = new TransformingMiddleware();
  
  middleware.shouldTransform((IError error) @safe {
    return error.severity() == fromSeverity;
  });
  
  middleware.transformer((IError error) @safe {
    error.severity(toSeverity);
    return error;
  });
  
  return middleware;
}
