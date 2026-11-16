module uim.oop.patterns.proxies.interfaces.subject;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Base interface for subjects that can be proxied.
 */
interface IProxySubject {
  /**
   * Execute the subject's main operation.
   */
  string execute() @safe;
}