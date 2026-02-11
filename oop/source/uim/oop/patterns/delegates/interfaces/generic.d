module uim.oop.patterns.delegates.interfaces.generic;

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