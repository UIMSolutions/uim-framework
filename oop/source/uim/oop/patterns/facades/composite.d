/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.facades.composite;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Composite facade that manages multiple subsystems.
 */
class CompositeFacade : Facade, IObservableFacade {
  protected ISubsystemComponent[] _components;
  protected string[string] _componentStatus;

  /**
   * Add a subsystem component to the facade.
   * Params:
   *   component = The component to add
   */
  void addComponent(ISubsystemComponent component) {
    if (component !is null) {
      _components ~= component;
      _componentStatus[component.name()] = "inactive";
    }
  }

  /**
   * Initialize all subsystem components.
   * Returns: true if all components initialized successfully
   */
  override bool initialize() {
    if (_initialized) {
      return true;
    }

    foreach (component; _components) {
      if (component.initialize()) {
        _componentStatus[component.name()] = "active";
      } else {
        _componentStatus[component.name()] = "failed";
        return false;
      }
    }

    _initialized = true;
    return true;
  }

  /**
   * Shutdown all subsystem components.
   */
  override void shutdown() {
    foreach (component; _components) {
      component.shutdown();
      _componentStatus[component.name()] = "inactive";
    }
    _initialized = false;
  }

  /**
   * Get facade status information.
   * Returns: Status string
   */
  string status() {
    import std.conv : to;

    return _initialized ? "Active (" ~ _components.length.to!string ~ " components)" : "Inactive";
  }

  /**
   * Get list of managed components.
   * Returns: Array of component names
   */
  string[] components() {
    import std.algorithm : map;
    import std.array : array;

    return _components.map!(c => c.name()).array;
  }

  /**
   * Check if a specific component is active.
   * Params:
   *   componentName = Name of the component
   * Returns: true if component is active
   */
  bool isComponentActive(string componentName) {
    if (auto status = componentName in _componentStatus) {
      return *status == "active";
    }
    return false;
  }
}
