# Facade Pattern

The Facade pattern provides a unified interface to a set of interfaces in a subsystem. It defines a higher-level interface that makes the subsystem easier to use by hiding its complexity.

## Features

- **Unified Interface**: Single entry point to complex subsystems
- **Component Management**: Coordinate multiple subsystem components
- **Configuration Support**: Configurable facade with options
- **Status Monitoring**: Observable facade with component tracking
- **Initialization Control**: Managed startup and shutdown sequences
- **Delegate Support**: Simple facade creation with function delegates

## Basic Usage

### Simple Facade

```d
import uim.oop;

// Create a simple facade with delegates
auto facade = createSimpleFacade(
    () {
        // Initialization logic
        writeln("Initializing system...");
        return true;
    },
    () {
        // Shutdown logic
        writeln("Shutting down system...");
    }
);

facade.initialize();  // Calls init delegate
facade.shutdown();    // Calls shutdown delegate
```

### Composite Facade with Components

```d
// Define subsystem components
class DatabaseComponent : SubsystemComponent {
    this() { super("Database"); }
    
    override bool initialize() {
        // Setup database connection
        return true;
    }
    
    override void shutdown() {
        // Close connections
    }
}

class CacheComponent : SubsystemComponent {
    this() { super("Cache"); }
    
    override bool initialize() {
        // Initialize cache
        return true;
    }
    
    override void shutdown() {
        // Clear cache
    }
}

// Create facade managing multiple components
auto facade = new CompositeFacade();
facade.addComponent(new DatabaseComponent());
facade.addComponent(new CacheComponent());

facade.initialize();  // Initializes all components
facade.shutdown();    // Shuts down all components
```

### Configurable Facade

```d
auto facade = new ConfigurableFacade();

// Set configuration
string[string] config;
config["host"] = "localhost";
config["port"] = "8080";
config["debug"] = "true";

facade.configure(config);

// Use configuration
string host = facade.getConfig("host");
string port = facade.getConfig("port", "3000"); // With default
```

## Real-World Examples

### Home Theater System

```d
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
    
    void watchMovie(string movie) {
        initialize();  // Powers on all components
        _lights.dim(10);
        _projector.setInput("DVD");
        _amp.setVolume(50);
        _dvd.play(movie);
    }
    
    void endMovie() {
        shutdown();    // Powers off all components
        _lights.dim(100);
    }
}

// Client code - simple!
auto theater = new HomeTheaterFacade();
theater.watchMovie("The Matrix");
theater.endMovie();
```

### Database System Facade

```d
class DatabaseFacade : ConfigurableFacade {
    this() {
        addComponent(new ConnectionPool());
        addComponent(new QueryOptimizer());
        addComponent(new CacheManager());
        
        string[string] config;
        config["host"] = "localhost";
        config["port"] = "5432";
        configure(config);
    }
    
    void query(string sql) {
        if (!isReady()) {
            initialize();
        }
        // Execute query using all subsystems
    }
}

auto db = new DatabaseFacade();
db.query("SELECT * FROM users");
```

### Application Startup Facade

```d
class ApplicationFacade : CompositeFacade {
    this() {
        addComponent(new Logger());
        addComponent(new ConfigLoader());
        addComponent(new PluginManager());
        addComponent(new ServiceRegistry());
    }
    
    void start() {
        writeln("Starting application...");
        initialize();  // Starts all subsystems in order
        writeln("Application ready!");
    }
    
    void stop() {
        writeln("Stopping application...");
        shutdown();    // Stops all subsystems
        writeln("Application stopped.");
    }
}

auto app = new ApplicationFacade();
app.start();
// ... run application ...
app.stop();
```

## Monitoring and Status

```d
auto facade = new CompositeFacade();
facade.addComponent(new ServiceA());
facade.addComponent(new ServiceB());

facade.initialize();

// Check overall status
writeln(facade.status());  // "Active (2 components)"

// Check individual components
writeln(facade.isComponentActive("ServiceA"));  // true

// Get all component names
foreach (component; facade.components()) {
    writeln(component);
}
```

## Benefits

1. **Simplified Interface**: Hides complexity from clients
2. **Decoupling**: Reduces dependencies between clients and subsystems
3. **Layered Architecture**: Provides clear separation of concerns
4. **Easier Testing**: Can mock the facade instead of all components
5. **Centralized Control**: Single point for initialization and configuration
6. **Better Organization**: Groups related functionality together

## When to Use

- Complex subsystem with many interconnected classes
- Need to provide a simple interface to a complex system
- Want to decouple clients from subsystem implementation
- Need to layer your subsystems (each layer has a facade)
- Multiple entry points to a subsystem need coordination

## Pattern Relationships

**Facade vs Adapter**:
- Facade: Simplifies interface (many -> one)
- Adapter: Converts interface (one -> one)

**Facade vs Mediator**:
- Facade: Unidirectional (clients → subsystem)
- Mediator: Bidirectional (objects ↔ mediator)

**Combining Patterns**:
```
Facade + Factory
└─> Facade uses factories to create subsystem components

Facade + Singleton
└─> Facade itself often implemented as a singleton

Facade + Strategy
└─> Different facade strategies for different platforms
```

## Advanced Features

### Component Status Tracking

```d
auto facade = new CompositeFacade();
facade.addComponent(new ComponentA());
facade.addComponent(new ComponentB());

facade.initialize();

// Check which components are active
if (facade.isComponentActive("ComponentA")) {
    // Component A is running
}
```

### Configuration Management

```d
auto facade = new ConfigurableFacade();

string[string] config;
config["timeout"] = "30";
config["retries"] = "3";

facade.configure(config);

int timeout = facade.getConfig("timeout", "10").to!int;
```

### Error Handling

```d
class FailSafeComponent : SubsystemComponent {
    this() { super("FailSafe"); }
    
    override bool initialize() {
        try {
            // Risky initialization
            return true;
        } catch (Exception e) {
            return false;  // Facade detects failure
        }
    }
    
    override void shutdown() {
        // Cleanup
    }
}

auto facade = new CompositeFacade();
facade.addComponent(new FailSafeComponent());

if (!facade.initialize()) {
    // Handle initialization failure
}
```

## See Also

- [examples/facade.d](../examples/facade.d) - Complete working examples
- [tests/patterns/facades.d](../../tests/patterns/facades.d) - Unit tests
