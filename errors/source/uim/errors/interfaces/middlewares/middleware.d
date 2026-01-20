/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.errors.interfaces.middlewares.middleware;

import uim.errors;

@safe:

/**
 * Interface for error middleware components.
 * 
 * Middleware can intercept, transform, filter, or log errors as they flow through the system.
 * Multiple middleware can be chained together to form a processing pipeline.
 */
interface IErrorMiddleware {
  /**
   * Process an error through this middleware.
   * 
   * Params:
   *   error = The error to process
   *   next = Delegate to call the next middleware in the chain
   * 
   * Returns:
   *   The processed error (may be the same, transformed, or null to filter)
   */
  IError process(IError error, IError delegate(IError) @safe next);

  /**
   * Check if this middleware should process the given error.
   * 
   * Params:
   *   error = The error to check
   * 
   * Returns:
   *   true if this middleware should process the error, false otherwise
   */
  bool shouldProcess(IError error);

  /**
   * Get the priority of this middleware (higher priority executes first).
   * 
   * Returns:
   *   Priority value (default is 0)
   */
  int priority();

  /**
   * Enable or disable this middleware.
   * 
   * Params:
   *   enabled = true to enable, false to disable
   * 
   * Returns:
   *   This middleware for chaining
   */
  IErrorMiddleware enabled(bool newEnabled);

  /**
   * Check if this middleware is enabled.
   * 
   * Returns:
   *   true if enabled, false otherwise
   */
  bool isEnabled();
}
