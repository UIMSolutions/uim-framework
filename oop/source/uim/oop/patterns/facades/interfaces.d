/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.facades.interfaces;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Base facade interface.
 * Provides a simplified interface to a complex subsystem.
 */
interface IFacade {
  /**
   * Initialize the facade and its subsystems.
   * Returns: true if initialization successful
   */
  bool initialize();

  /**
   * Shutdown the facade and cleanup resources.
   */
  void shutdown();

  /**
   * Check if the facade is ready for operations.
   * Returns: true if ready
   */
  bool isReady();
}

/**
 * Subsystem component interface.
 * Represents a component in the subsystem managed by the facade.
 */
interface ISubsystemComponent {
  /**
   * Initialize the component.
   * Returns: true if initialization successful
   */
  bool initialize();

  /**
   * Shutdown the component.
   */
  void shutdown();

  /**
   * Get component name.
   * Returns: The name of the component
   */
  string name();
}

/**
 * Configurable facade interface.
 */
interface IConfigurableFacade : IFacade {
  /**
   * Configure the facade with options.
   * Params:
   *   options = Configuration options
   */
  void configure(string[string] options);

  /**
   * Get current configuration.
   * Returns: Current configuration options
   */
  string[string] configuration();
}

/**
 * Observable facade interface for monitoring.
 */
interface IObservableFacade : IFacade {
  /**
   * Get facade status information.
   * Returns: Status string
   */
  string status();

  /**
   * Get list of managed components.
   * Returns: Array of component names
   */
  string[] components();

  /**
   * Check if a specific component is active.
   * Params:
   *   componentName = Name of the component
   * Returns: true if component is active
   */
  bool isComponentActive(string componentName);
}
