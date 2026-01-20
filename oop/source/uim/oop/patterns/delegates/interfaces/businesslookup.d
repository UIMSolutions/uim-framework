module uim.oop.patterns.delegates.interfaces.businesslookup;

import uim.oop;

mixin(ShowModule!());

@safe:

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