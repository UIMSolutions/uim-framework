module uim.oop.patterns.proxies.interfaces.protection;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Interface for protection proxy (access control).
 */
interface IProtectionProxy : IProxy {
  /**
   * Check if access is allowed.
   */
  bool isAccessAllowed() @safe;

  /**
   * Set access permission.
   */
  void setAccessAllowed(bool allowed) @safe;
}