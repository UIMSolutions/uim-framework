module uim.oop.patterns.delegates.interfaces.delegate_;

import uim.oop;

mixin(ShowModule!());

@safe:

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