module uim.oop.patterns.proxies.interfaces.proxy;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Interface for proxy objects.
 * Provides the same interface as the real subject.
 */
interface IProxy : IProxySubject {
  /**
   * Get the real subject.
   */
  IProxySubject getRealSubject() @safe;
}