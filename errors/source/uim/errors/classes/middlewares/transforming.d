/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
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

  /** 
   * 
    * Determine if this middleware should process the given error. If a _shouldTransform predicate is set, it will be used to decide. Otherwise, all errors will be processed.
    
    * This allows for conditional transformation, where only certain errors are modified by the transformer function.
    * For example, you could set a predicate that only transforms errors of a certain severity or with certain codes, while leaving others unchanged.
    * If no predicate is set, the default behavior is to transform all errors that reach this middleware.
    * This method is called by the pipeline to check if the transformer should be applied to a given error.
    * If this returns false, the error will be passed through unchanged. If it returns true, the transformer function will be applied to the error.
    * This allows for flexible error transformation based on custom criteria defined in the predicate.
    * If you want to <b>transform all errors</b>, simply do not set a predicate or set it to a function that always returns true.
    * If you want to only transform specific errors, set a predicate that checks the error properties and returns true for those that should be transformed.
    * This method is part of the IErrorMiddleware interface and is used by the pipeline to determine which middleware should process each error.
    * The actual transformation logic is implemented in the process method, which will call this shouldProcess method to decide whether to apply the transformer function to each error.
    */
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
  
  middleware.shouldTransform((IError error) {
    return error.severity() == fromSeverity;
  });
  
  middleware.transformer((IError error) {
    error.severity(toSeverity);
    return error;
  });
  
  return middleware;
}
