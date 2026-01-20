/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.commands.helpers.manager;

import uim.commands;

mixin(ShowModule!());

@safe:

/**
 * Command manager that combines registry, factory and execution management.
 * Provides a unified interface for command lifecycle management.
 */
class DCommandManager {
  private DCommandFactory _factory;
  private DCommandRegistry _registry;
  private ICommand[string] _instances;
  
  this() {
    _factory = CommandFactory();
    _registry = CommandRegistry();
  }

  /**
   * Register a command class.
   */
  DCommandManager register(string name, ICommand delegate() @safe creator) {
    _factory.register(name, creator);
    return this;
  }

  /**
   * Create a new command instance.
   */
  ICommand create(string name, Json[string] initData = null) {
    auto command = _factory.create(name);
    if (command && initData) {
      command.initialize(initData);
    }
    return command;
  }

  /**
   * Get or create a singleton command instance.
   */
  ICommand getInstance(string name, Json[string] initData = null) {
    if (auto cmd = name in _instances) {
      return *cmd;
    }

    auto command = create(name, initData);
    if (command) {
      _instances[name] = command;
    }
    return command;
  }

  /**
   * Execute a command by name.
   */
  bool execute(string name, Json[string] options = null) {
    auto command = create(name);
    if (!command) {
      return false;
    }
    return command.execute(options);
  }

  /**
   * Execute a command and return detailed result.
   */
  CommandResult executeWithResult(string name, Json[string] options = null) {
    auto command = create(name);
    if (!command) {
      return CommandResult.fail("Command '" ~ name ~ "' not found");
    }
    return command.executeWithResult(options);
  }

  /**
   * Check if a command is registered.
   */
  bool has(string name) {
    return _factory.contains(name);
  }

  /**
   * Remove a command registration.
   */
  bool unregister(string name) {
    _instances.remove(name);
    return _factory.remove(name);
  }

  /**
   * Clear all registered commands and instances.
   */
  void clear() {
    _factory.clear();
    _instances.clear();
  }

  /**
   * Get all registered command names.
   */
  string[] getRegisteredNames() {
    return _factory.keys();
  }

  /**
   * Get the factory instance.
   */
  DCommandFactory factory() {
    return _factory;
  }

  /**
   * Get the registry instance.
   */
  DCommandRegistry registry() {
    return _registry;
  }
}

/// Global command manager instance
private DCommandManager _globalManager;

/**
 * Get the global command manager instance.
 */
DCommandManager commandManager() {
  if (_globalManager is null) {
    _globalManager = new DCommandManager();
  }
  return _globalManager;
}

unittest {
  auto manager = new DCommandManager();
  assert(manager !is null, "Failed to create command manager");
}
