/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.proxies.interfaces.remote;

import uim.oop;

mixin(ShowModule!());

@safe:


/**
 * Interface for remote proxy.
 */
interface IRemoteProxy : IProxy {
  /**
   * Get the remote endpoint.
   */
  string getEndpoint() @safe;

  /**
   * Check connection status.
   */
  bool isConnected() @safe;
}
