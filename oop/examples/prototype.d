module oop.examples.prototype;

import std.stdio;
import uim.oop.patterns.prototypes;

void main() {
    writeln("=== Prototype Pattern Examples ===\n");
    
    // Example 1: Basic Prototype Cloning
    writeln("1. Basic Prototype Cloning:");
    auto original = new ConcretePrototype(1, "Original Product", 99.99);
    writeln("   Original: ID=", original.id, ", Name=", original.name, ", Value=", original.value);
    
    auto clone = original.clone();
    clone.id = 2;
    clone.name = "Cloned Product";
    writeln("   Clone:    ID=", clone.id, ", Name=", clone.name, ", Value=", clone.value);
    writeln();
    
    // Example 2: Prototype Registry
    writeln("2. Prototype Registry:");
    auto registry = new PrototypeRegistry!ConcretePrototype();
    
    // Register product templates
    registry.register("basic", new ConcretePrototype(0, "Basic Product", 9.99));
    registry.register("premium", new ConcretePrototype(0, "Premium Product", 99.99));
    registry.register("enterprise", new ConcretePrototype(0, "Enterprise Product", 999.99));
    
    writeln("   Registered prototypes: ", registry.keys);
    
    // Create instances from prototypes
    auto product1 = registry.create("basic");
    product1.id = 101;
    writeln("   Created from 'basic': ", product1.name, " - $", product1.value);
    
    auto product2 = registry.create("premium");
    product2.id = 102;
    writeln("   Created from 'premium': ", product2.name, " - $", product2.value);
    writeln();
    
    // Example 3: Deep vs Shallow Cloning
    writeln("3. Deep vs Shallow Cloning:");
    auto complexOriginal = new ComplexPrototype("DataSet", [10, 20, 30, 40, 50]);
    complexOriginal.metadata = ["version": "1.0", "type": "numeric"];
    
    // Deep clone - independent copy
    auto deepCopy = complexOriginal.deepClone();
    deepCopy.data[0] = 999;
    deepCopy.metadata["version"] = "2.0";
    
    writeln("   Original data[0]: ", complexOriginal.data[0]);
    writeln("   Deep copy data[0]: ", deepCopy.data[0]);
    writeln("   Original metadata version: ", complexOriginal.metadata["version"]);
    writeln("   Deep copy metadata version: ", deepCopy.metadata["version"]);
    writeln();
    
    // Shallow clone - shared references
    auto shallowCopy = complexOriginal.shallowClone();
    shallowCopy.data[1] = 888;
    
    writeln("   After shallow clone modification:");
    writeln("   Original data[1]: ", complexOriginal.data[1]);
    writeln("   Shallow copy data[1]: ", shallowCopy.data[1]);
    writeln("   (Both share the same array reference)");
    writeln();
    
    // Example 4: Configuration Management
    writeln("4. Configuration Management:");
    auto configRegistry = new PrototypeRegistry!ConfigPrototype();
    
    // Base configuration template
    auto baseConfig = new ConfigPrototype("base", 8080, false);
    baseConfig.addHost("localhost");
    configRegistry.register("base", baseConfig);
    
    // Create environment-specific configs from base
    auto devConfig = configRegistry.create("base");
    devConfig.environment = "development";
    devConfig.port = 3000;
    devConfig.debugMode = true;
    devConfig.addHost("dev.local");
    
    auto prodConfig = configRegistry.create("base");
    prodConfig.environment = "production";
    prodConfig.port = 80;
    prodConfig.addHost("example.com");
    prodConfig.addHost("www.example.com");
    
    writeln("   Development Config:");
    writeln("     Environment: ", devConfig.environment);
    writeln("     Port: ", devConfig.port);
    writeln("     Debug: ", devConfig.debugMode);
    writeln("     Hosts: ", devConfig.allowedHosts);
    
    writeln("   Production Config:");
    writeln("     Environment: ", prodConfig.environment);
    writeln("     Port: ", prodConfig.port);
    writeln("     Debug: ", prodConfig.debugMode);
    writeln("     Hosts: ", prodConfig.allowedHosts);
    writeln();
    
    // Example 5: Mass Object Creation
    writeln("5. Mass Object Creation from Prototype:");
    auto userTemplate = new ConcretePrototype(0, "User", 0.0);
    
    ConcretePrototype[] users;
    foreach (i; 1..6) {
        auto user = userTemplate.clone();
        user.id = i;
        user.name = "User" ~ i.to!string;
        user.value = i * 10.0;
        users ~= user;
    }
    
    writeln("   Created ", users.length, " user objects:");
    foreach (user; users) {
        writeln("     ", user.name, " (ID:", user.id, ", Value:", user.value, ")");
    }
}

// Import for to!string conversion
import std.conv : to;
