module uim.oop.patterns.locators.interfaces.service;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Base interface for all services that can be registered with a Service Locator.
 */
interface IService {
  /**
   * Get the name of this service.
   */
  string serviceName() @safe;

  /**
   * Execute the service's main operation.
   */
  string execute() @safe;
}