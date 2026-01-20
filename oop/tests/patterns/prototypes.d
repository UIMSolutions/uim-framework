module oop.tests.patterns.prototypes;

import uim.oop.patterns.prototypes;

@safe unittest {
    // Test basic prototype cloning
    auto original = new ConcretePrototype(100, "original", 99.9);
    auto clone = original.clone();
    
    assert(clone !is null);
    assert(clone.id == original.id);
    assert(clone.name == original.name);
    assert(clone.value == original.value);
    assert(clone !is original, "Clone should be a different object");
}

@safe unittest {
    // Test clone independence
    auto original = new ConcretePrototype(1, "original", 10.0);
    auto clone = original.clone();
    
    // Modify clone
    clone.id = 999;
    clone.name = "modified";
    clone.value = 999.9;
    
    // Original should remain unchanged
    assert(original.id == 1);
    assert(original.name == "original");
    assert(original.value == 10.0);
}

@safe unittest {
    // Test deep cloning with arrays
    auto original = new ComplexPrototype("deep", [10, 20, 30]);
    auto clone = original.deepClone();
    
    // Modify clone's array
    clone.data[0] = 999;
    
    // Original should be unaffected
    assert(original.data[0] == 10);
    assert(clone.data[0] == 999);
}

@safe unittest {
    // Test deep cloning with associative arrays
    auto original = new ComplexPrototype("deep");
    original.metadata = ["version": "1.0", "author": "test"];
    
    auto clone = original.deepClone();
    auto newMetadata = clone.metadata;
    newMetadata["version"] = "2.0";
    newMetadata["modified"] = "true";
    clone.metadata = newMetadata;
    
    assert(original.metadata["version"] == "1.0");
    assert("modified" !in original.metadata);
}

@safe unittest {
    // Test shallow cloning shares references
    auto original = new ComplexPrototype("shallow", [1, 2, 3]);
    auto clone = original.shallowClone();
    
    // Modify clone's array element
    clone.data[1] = 999;
    
    // Original is affected (shared reference)
    assert(original.data[1] == 999);
}

@safe unittest {
    // Test PrototypeRegistry register and create
    auto registry = new PrototypeRegistry!ConcretePrototype();
    auto prototype = new ConcretePrototype(42, "answer", 3.14);
    
    registry.register("answer", prototype);
    
    auto instance1 = registry.create("answer");
    auto instance2 = registry.create("answer");
    
    assert(instance1 !is null);
    assert(instance2 !is null);
    assert(instance1 !is instance2, "Should create separate instances");
    assert(instance1.id == 42);
    assert(instance2.id == 42);
}

@safe unittest {
    // Test registry with non-existent key
    auto registry = new PrototypeRegistry!ConcretePrototype();
    auto instance = registry.create("nonexistent");
    
    assert(instance is null);
    assert(!registry.has("nonexistent"));
}

@safe unittest {
    // Test registry unregister functionality
    auto registry = new PrototypeRegistry!ConcretePrototype();
    registry.register("temp", new ConcretePrototype(1, "temp", 1.0));
    
    assert(registry.has("temp"));
    assert(registry.count == 1);
    
    registry.unregister("temp");
    
    assert(!registry.has("temp"));
    assert(registry.count == 0);
    assert(registry.create("temp") is null);
}

@safe unittest {
    // Test registry clear
    auto registry = new PrototypeRegistry!ConcretePrototype();
    
    registry.register("proto1", new ConcretePrototype(1, "one", 1.0));
    registry.register("proto2", new ConcretePrototype(2, "two", 2.0));
    registry.register("proto3", new ConcretePrototype(3, "three", 3.0));
    
    assert(registry.count == 3);
    
    registry.clear();
    
    assert(registry.count == 0);
    assert(!registry.has("proto1"));
    assert(!registry.has("proto2"));
    assert(!registry.has("proto3"));
}

@safe unittest {
    // Test registry keys retrieval
    auto registry = new PrototypeRegistry!ConcretePrototype();
    
    registry.register("alpha", new ConcretePrototype(1, "a", 1.0));
    registry.register("beta", new ConcretePrototype(2, "b", 2.0));
    registry.register("gamma", new ConcretePrototype(3, "c", 3.0));
    
    auto keys = registry.keys;
    assert(keys.length == 3);
    
    import std.algorithm : canFind;
    assert(keys.canFind("alpha"));
    assert(keys.canFind("beta"));
    assert(keys.canFind("gamma"));
}

@safe unittest {
    // Test ConfigPrototype cloning
    auto devConfig = new ConfigPrototype("development", 3000, true);
    devConfig.addHost("localhost");
    devConfig.addHost("127.0.0.1");
    
    auto prodConfig = devConfig.clone();
    prodConfig.environment = "production";
    prodConfig.port = 8080;
    prodConfig.debugMode = false;
    prodConfig.addHost("example.com");
    
    // Original unchanged
    assert(devConfig.environment == "development");
    assert(devConfig.port == 3000);
    assert(devConfig.debugMode == true);
    assert(devConfig.allowedHosts.length == 2);
    
    // Clone modified independently
    assert(prodConfig.environment == "production");
    assert(prodConfig.port == 8080);
    assert(prodConfig.debugMode == false);
    assert(prodConfig.allowedHosts.length == 3);
}

@safe unittest {
    // Test using registry for configuration variants
    auto registry = new PrototypeRegistry!ConfigPrototype();
    
    auto baseConfig = new ConfigPrototype("base", 8000, false);
    registry.register("base", baseConfig);
    
    // Create development variant
    auto devConfig = registry.create("base");
    devConfig.environment = "development";
    devConfig.debugMode = true;
    
    // Create production variant
    auto prodConfig = registry.create("base");
    prodConfig.environment = "production";
    prodConfig.port = 80;
    
    assert(devConfig.port == 8000);  // Inherited from base
    assert(prodConfig.debugMode == false);  // Inherited from base
    assert(devConfig.environment != prodConfig.environment);
}

@safe unittest {
    // Test multiple clones from same prototype
    auto protoTemplate = new ConcretePrototype(0, "template", 0.0);
    
    ConcretePrototype[] instances;
    foreach (i; 0..5) {
        auto instance = protoTemplate.clone();
        instance.id = i + 1;
        instances ~= instance;
    }
    
    assert(instances.length == 5);
    foreach (i, instance; instances) {
        assert(instance.id == i + 1);
        assert(instance.name == "template");
    }
    
    // Template unchanged
    assert(protoTemplate.id == 0);
}

@safe unittest {
    // Test registry overwrite behavior
    auto registry = new PrototypeRegistry!ConcretePrototype();
    
    registry.register("key", new ConcretePrototype(1, "first", 1.0));
    auto instance1 = registry.create("key");
    assert(instance1.id == 1);
    
    // Overwrite with new prototype
    registry.register("key", new ConcretePrototype(2, "second", 2.0));
    auto instance2 = registry.create("key");
    assert(instance2.id == 2);
    assert(instance2.name == "second");
}
