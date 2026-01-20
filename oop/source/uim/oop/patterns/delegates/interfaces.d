/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.delegates.interfaces;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Business Service interface.
 * Defines the contract for business services that perform actual business logic.
 */
interface IBusinessService {
  /**
   * Execute a business operation.
   * Returns: Result of the business operation
   */
  string execute();

  /**
   * Get the service name.
   * Returns: The name of this service
   */
  string serviceName();
}

/**
 * Generic Business Service interface with typed input and output.
 */
interface IGenericBusinessService(TInput, TOutput) {
  /**
   * Execute a business operation with input data.
   * Params:
   *   input = The input data for the operation
   * Returns: Result of the business operation
   */
  TOutput execute(TInput input);

  /**
   * Get the service name.
   * Returns: The name of this service
   */
  string serviceName();
}

/**
 * Business Lookup Service interface.
 * Responsible for locating and retrieving business services.
 */
interface IBusinessLookup {
  /**
   * Look up a business service by name.
   * Params:
   *   serviceName = The name of the service to look up
   * Returns: The business service if found
   */
  IBusinessService getBusinessService(string serviceName);

  /**
   * Register a business service.
   * Params:
   *   serviceName = The name to register the service under
   *   service = The business service to register
   */
  void registerService(string serviceName, IBusinessService service);

  /**
   * Check if a service is registered.
   * Params:
   *   serviceName = The name of the service to check
   * Returns: true if the service is registered
   */
  bool hasService(string serviceName);

  /**
   * Remove a registered service.
   * Params:
   *   serviceName = The name of the service to remove
   * Returns: true if the service was removed
   */
  bool removeService(string serviceName);
}

/**
 * Business Delegate interface.
 * Provides an abstraction layer between client and business service.
 */
interface IBusinessDelegate {
  /**
   * Execute a business operation through the delegate.
   * Returns: Result of the business operation
   */
  string doTask();

  /**
   * Get the service type this delegate works with.
   * Returns: The service type name
   */
  string serviceType();
}

/**
 * Generic Business Delegate interface with typed operations.
 */
interface IGenericBusinessDelegate(TInput, TOutput) {
  /**
   * Execute a business operation with input data.
   * Params:
   *   input = The input data for the operation
   * Returns: Result of the business operation
   */
  TOutput doTask(TInput input);

  /**
   * Get the service type this delegate works with.
   * Returns: The service type name
   */
  string serviceType();
}

/**
 * Cacheable Business Delegate interface.
 * Adds caching capabilities to business delegate operations.
 */
interface ICacheableBusinessDelegate : IBusinessDelegate {
  /**
   * Enable caching for this delegate.
   */
  void enableCache();

  /**
   * Disable caching for this delegate.
   */
  void disableCache();

  /**
   * Clear the cache.
   */
  void clearCache();

  /**
   * Check if caching is enabled.
   * Returns: true if caching is enabled
   */
  bool isCacheEnabled();
}

/**
 * Async Business Delegate interface.
 * Supports asynchronous business operations.
 */
interface IAsyncBusinessDelegate {
  /**
   * Execute a business operation asynchronously.
   * Params:
   *   callback = Callback function to execute when operation completes
   */
  void doTaskAsync(void delegate(string) @safe callback);

  /**
   * Check if an async operation is in progress.
   * Returns: true if operation is in progress
   */
  bool isOperationInProgress();
}

/**
 * Business Delegate with retry capabilities.
 */
interface IRetryableBusinessDelegate : IBusinessDelegate {
  /**
   * Set maximum retry attempts.
   * Params:
   *   attempts = Maximum number of retry attempts
   */
  void setMaxRetries(int attempts);

  /**
   * Get current retry count.
   * Returns: Number of retries performed
   */
  int retryCount();
}
