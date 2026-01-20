module uim.oop.patterns.delegates.interfaces.businessservice;

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