/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module oop.examples.facade;

import uim.oop;
import std.stdio;

/**
 * Example demonstrating the Facade pattern.
 * 
 * The Facade pattern provides a unified interface to a set of interfaces
 * in a subsystem. It defines a higher-level interface that makes the
 * subsystem easier to use.
 */

void main() @safe {
  writeln("\n=== Facade Pattern Examples ===\n");
  
  // Example 1: Home Theater System
  homeTheaterExample();
  
  // Example 2: Database System
  databaseExample();
  
  // Example 3: Application Startup
  applicationExample();
}

void homeTheaterExample() @safe {
  writeln("1. Home Theater System Example:");
  writeln("--------------------------------");
  
  // Complex subsystem components
  class DVDPlayer : SubsystemComponent {
    this() { super("DVD Player"); }
    
    override bool initialize() {
      writeln("  [DVD] Initializing DVD player...");
      _initialized = true;
      return true;
    }
    
    override void shutdown() {
      writeln("  [DVD] Shutting down DVD player...");
      _initialized = false;
    }
    
    void play(string movie) @safe {
      writeln("  [DVD] Playing: ", movie);
    }
  }
  
  class Amplifier : SubsystemComponent {
    this() { super("Amplifier"); }
    
    override bool initialize() {
      writeln("  [AMP] Powering on amplifier...");
      _initialized = true;
      return true;
    }
    
    override void shutdown() {
      writeln("  [AMP] Powering off amplifier...");
      _initialized = false;
    }
    
    void setVolume(int level) @safe {
      import std.conv : to;
      writeln("  [AMP] Volume set to: ", level);
    }
  }
  
  class Projector : SubsystemComponent {
    this() { super("Projector"); }
    
    override bool initialize() {
      writeln("  [PRJ] Starting projector...");
      _initialized = true;
      return true;
    }
    
    override void shutdown() {
      writeln("  [PRJ] Stopping projector...");
      _initialized = false;
    }
    
    void setInput(string input) @safe {
      writeln("  [PRJ] Input set to: ", input);
    }
  }
  
  class Lights : SubsystemComponent {
    this() { super("Lights"); }
    
    override bool initialize() {
      _initialized = true;
      return true;
    }
    
    override void shutdown() {
      _initialized = false;
    }
    
    void dim(int level) @safe {
      import std.conv : to;
      writeln("  [LGT] Lights dimmed to: ", level, "%");
    }
  }
  
  // Facade simplifies the complex subsystem
  class HomeTheaterFacade : CompositeFacade {
    private DVDPlayer _dvd;
    private Amplifier _amp;
    private Projector _projector;
    private Lights _lights;
    
    this() {
      _dvd = new DVDPlayer();
      _amp = new Amplifier();
      _projector = new Projector();
      _lights = new Lights();
      
      addComponent(_dvd);
      addComponent(_amp);
      addComponent(_projector);
      addComponent(_lights);
    }
    
    void watchMovie(string movie) @safe {
      writeln("\nPreparing to watch movie...");
      if (!isReady()) {
        initialize();
      }
      _lights.dim(10);
      _projector.setInput("DVD");
      _amp.setVolume(50);
      _dvd.play(movie);
      writeln("Enjoy your movie!\n");
    }
    
    void endMovie() @safe {
      writeln("\nShutting down movie...");
      shutdown();
      _lights.dim(100);
      writeln("Movie ended.\n");
    }
  }
  
  // Client code - simple!
  auto homeTheater = new HomeTheaterFacade();
  homeTheater.watchMovie("The Matrix");
  homeTheater.endMovie();
  
  writeln();
}

void databaseExample() @safe {
  writeln("2. Database System Example:");
  writeln("---------------------------");
  
  class ConnectionPool : SubsystemComponent {
    this() { super("Connection Pool"); }
    
    override bool initialize() {
      writeln("  [POOL] Creating connection pool...");
      _initialized = true;
      return true;
    }
    
    override void shutdown() {
      writeln("  [POOL] Closing all connections...");
      _initialized = false;
    }
  }
  
  class QueryOptimizer : SubsystemComponent {
    this() { super("Query Optimizer"); }
    
    override bool initialize() {
      writeln("  [OPT] Initializing query optimizer...");
      _initialized = true;
      return true;
    }
    
    override void shutdown() {
      writeln("  [OPT] Shutting down optimizer...");
      _initialized = false;
    }
  }
  
  class CacheManager : SubsystemComponent {
    this() { super("Cache Manager"); }
    
    override bool initialize() {
      writeln("  [CACHE] Starting cache manager...");
      _initialized = true;
      return true;
    }
    
    override void shutdown() {
      writeln("  [CACHE] Clearing cache...");
      _initialized = false;
    }
  }
  
  class DatabaseFacade : ConfigurableFacade {
    this() {
      addComponent(new ConnectionPool());
      addComponent(new QueryOptimizer());
      addComponent(new CacheManager());
      
      string[string] config;
      config["host"] = "localhost";
      config["port"] = "5432";
      config["database"] = "myapp";
      configure(config);
    }
    
    void query(string sql) @safe {
      if (!isReady()) {
        writeln("Database not ready. Initializing...");
        initialize();
      }
      writeln("  [DB] Executing query: ", sql);
    }
  }
  
  auto db = new DatabaseFacade();
  writeln("\nDatabase configuration:");
  writeln("  Host: ", db.getConfig("host"));
  writeln("  Port: ", db.getConfig("port"));
  writeln("  Database: ", db.getConfig("database"));
  
  writeln("\nExecuting queries:");
  db.query("SELECT * FROM users");
  db.query("INSERT INTO logs VALUES (...)");
  
  writeln("\nShutting down database:");
  db.shutdown();
  
  writeln();
}

void applicationExample() @safe {
  writeln("3. Application Startup Example:");
  writeln("--------------------------------");
  
  class Logger : SubsystemComponent {
    this() { super("Logger"); }
    override bool initialize() {
      writeln("  [LOG] Logger initialized");
      return true;
    }
    override void shutdown() {
      writeln("  [LOG] Logger shutdown");
    }
  }
  
  class ConfigLoader : SubsystemComponent {
    this() { super("Config Loader"); }
    override bool initialize() {
      writeln("  [CFG] Configuration loaded");
      return true;
    }
    override void shutdown() {
      writeln("  [CFG] Configuration cleared");
    }
  }
  
  class PluginManager : SubsystemComponent {
    this() { super("Plugin Manager"); }
    override bool initialize() {
      writeln("  [PLG] Plugins loaded");
      return true;
    }
    override void shutdown() {
      writeln("  [PLG] Plugins unloaded");
    }
  }
  
  class ApplicationFacade : CompositeFacade {
    this() {
      addComponent(new Logger());
      addComponent(new ConfigLoader());
      addComponent(new PluginManager());
    }
    
    void start() @safe {
      writeln("\nStarting application...");
      initialize();
      writeln("Application ready!");
      writeln("Status: ", status());
    }
    
    void stop() @safe {
      writeln("\nStopping application...");
      shutdown();
      writeln("Application stopped.");
    }
  }
  
  auto app = new ApplicationFacade();
  app.start();
  
  writeln("\nApplication components:");
  foreach (component; app.components()) {
    writeln("  - ", component, ": ", 
            app.isComponentActive(component) ? "Active" : "Inactive");
  }
  
  app.stop();
  
  writeln();
}
