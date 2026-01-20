/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.facades.configurable;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Configurable facade with configuration support.
 */
class ConfigurableFacade : CompositeFacade, IConfigurableFacade {
  protected string[string] _configuration;

  /**
   * Configure the facade with options.
   * Params:
   *   options = Configuration options
   */
  void configure(string[string] options) {
    _configuration = options.dup;
  }

  /**
   * Get current configuration.
   * Returns: Current configuration options
   */
  string[string] configuration() {
    return _configuration.dup;
  }

  /**
   * Get a configuration value.
   * Params:
   *   key = Configuration key
   *   defaultValue = Default value if key not found
   * Returns: Configuration value or default
   */
  string getConfig(string key, string defaultValue = "") {
    if (auto value = key in _configuration) {
      return *value;
    }
    return defaultValue;
  }
}
