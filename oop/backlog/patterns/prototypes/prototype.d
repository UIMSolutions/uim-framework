module uim.oop.patterns.prototypes.prototype;

import uim.oop.patterns.prototypes.interfaces;
import std.algorithm : remove;
import std.array;

@safe: 

/**
 * Abstract base class for prototypes.
 * Provides basic cloning functionality that can be extended by subclasses.
 */
abstract class Prototype(T) : IPrototype!T {
    /**
     * Creates and returns a clone of this object.
     * Subclasses should override this to provide specific cloning logic.
     */
    abstract T clone();
}

/**
 * Concrete prototype implementation with value-based data.
 * Demonstrates simple cloning of primitive and value types.
 */
class ConcretePrototype : Prototype!ConcretePrototype {
    private int _id;
    private string _name;
    private double _value;

    this(int id, string name, double value) {
        _id = id;
        _name = name;
        _value = value;
    }

    @property int id() const { return _id; }
    @property void id(int value) { _id = value; }

    @property string name() const { return _name; }
    @property void name(string value) { _name = value; }

    @property double value() const { return _value; }
    @property void value(double val) { _value = val; }

    override ConcretePrototype clone() {
        return new ConcretePrototype(_id, _name, _value);
    }
}

/**
 * Prototype with complex data demonstrating deep vs shallow cloning.
 */
class ComplexPrototype : IDeepCloneable!ComplexPrototype, IShallowCloneable!ComplexPrototype {
    private string _name;
    private int[] _data;
    private string[string] _metadata;

    this(string name, int[] data = null, string[string] metadata = null) {
        _name = name;
        _data = data ? data.dup : [];
        _metadata = metadata ? metadata.dup : null;
    }

    @property string name() const { return _name; }
    @property void name(string value) { _name = value; }

    @property int[] data() { return _data; }
    @property void data(int[] value) { _data = value; }

    @property string[string] metadata() { return _metadata; }
    @property void metadata(string[string] value) { _metadata = value; }

    ComplexPrototype clone() {
        return deepClone();
    }

    ComplexPrototype deepClone() {
        auto copy = new ComplexPrototype(_name);
        copy._data = _data.dup;
        if (_metadata !is null) {
            copy._metadata = _metadata.dup;
        }
        return copy;
    }

    ComplexPrototype shallowClone() {
        auto copy = new ComplexPrototype(_name);
        copy._data = _data;  // Reference copy
        copy._metadata = _metadata;  // Reference copy
        return copy;
    }
}

/**
 * Registry for managing and cloning prototype instances.
 * Allows storing prototypes by key and creating clones on demand.
 */
class PrototypeRegistry(T) : IPrototypeRegistry!T if (is(T : IPrototype!T)) {
    private T[string] _prototypes;

    void register(string key, T prototype) {
        _prototypes[key] = prototype;
    }

    void unregister(string key) {
        _prototypes.remove(key);
    }

    T create(string key) {
        if (auto prototype = key in _prototypes) {
            return (*prototype).clone();
        }
        return null;
    }

    bool has(string key) {
        return (key in _prototypes) !is null;
    }

    string[] keys() {
        return _prototypes.keys;
    }

    void clear() {
        _prototypes.clear();
    }

    size_t count() const {
        return _prototypes.length;
    }
}

/**
 * Specialized prototype for configuration objects.
 * Demonstrates practical use case for the Prototype pattern.
 */
class ConfigPrototype : Prototype!ConfigPrototype {
    private string _environment;
    private int _port;
    private bool _debug;
    private string[] _allowedHosts;

    this(string environment = "production", int port = 8080, bool debugMode = false) {
        _environment = environment;
        _port = port;
        _debug = debugMode;
        _allowedHosts = [];
    }

    @property string environment() const { return _environment; }
    @property void environment(string value) { _environment = value; }

    @property int port() const { return _port; }
    @property void port(int value) { _port = value; }

    @property bool debugMode() const { return _debug; }
    @property void debugMode(bool value) { _debug = value; }

    @property string[] allowedHosts() { return _allowedHosts; }
    @property void allowedHosts(string[] value) { _allowedHosts = value; }

    void addHost(string host) {
        _allowedHosts ~= host;
    }

    override ConfigPrototype clone() {
        auto copy = new ConfigPrototype(_environment, _port, _debug);
        copy._allowedHosts = _allowedHosts.dup;
        return copy;
    }
}

@safe unittest {
    // Test ConcretePrototype cloning
    auto original = new ConcretePrototype(1, "original", 42.5);
    auto cloned = original.clone();
    
    assert(cloned.id == 1);
    assert(cloned.name == "original");
    assert(cloned.value == 42.5);
    
    // Verify independence
    cloned.name = "modified";
    assert(original.name == "original");
}

@safe unittest {
    // Test ComplexPrototype deep cloning
    auto original = new ComplexPrototype("test", [1, 2, 3]);
    original.metadata = ["key1": "value1", "key2": "value2"];
    
    auto deepCopy = original.deepClone();
    
    // Modify the copy
    deepCopy.data[0] = 99;
    auto newMetadata = deepCopy.metadata;
    newMetadata["key1"] = "modified";
    deepCopy.metadata = newMetadata;
    
    // Original should be unchanged
    assert(original.data[0] == 1);
    assert(original.metadata["key1"] == "value1");
}

@safe unittest {
    // Test ComplexPrototype shallow cloning
    auto original = new ComplexPrototype("test", [1, 2, 3]);
    auto shallowCopy = original.shallowClone();
    
    // Modify the copy's data
    shallowCopy.data[0] = 99;
    
    // Original is affected (shallow copy shares the array)
    assert(original.data[0] == 99);
}

@safe unittest {
    // Test PrototypeRegistry basic operations
    auto registry = new PrototypeRegistry!ConcretePrototype();
    auto prototype = new ConcretePrototype(1, "template", 100.0);
    
    registry.register("default", prototype);
    assert(registry.has("default"));
    assert(registry.count == 1);
    
    auto instance = registry.create("default");
    assert(instance !is null);
    assert(instance.id == 1);
    assert(instance.name == "template");
}

@safe unittest {
    // Test registry with multiple prototypes
    auto registry = new PrototypeRegistry!ConcretePrototype();
    
    registry.register("proto1", new ConcretePrototype(1, "first", 1.0));
    registry.register("proto2", new ConcretePrototype(2, "second", 2.0));
    registry.register("proto3", new ConcretePrototype(3, "third", 3.0));
    
    assert(registry.count == 3);
    assert(registry.keys.length == 3);
    
    auto instance2 = registry.create("proto2");
    assert(instance2.id == 2);
    assert(instance2.name == "second");
}

@safe unittest {
    // Test registry unregister
    auto registry = new PrototypeRegistry!ConcretePrototype();
    registry.register("temp", new ConcretePrototype(1, "temp", 1.0));
    
    assert(registry.has("temp"));
    registry.unregister("temp");
    assert(!registry.has("temp"));
    assert(registry.create("temp") is null);
}

@safe unittest {
    // Test registry clear
    auto registry = new PrototypeRegistry!ConcretePrototype();
    registry.register("proto1", new ConcretePrototype(1, "first", 1.0));
    registry.register("proto2", new ConcretePrototype(2, "second", 2.0));
    
    assert(registry.count == 2);
    registry.clear();
    assert(registry.count == 0);
    assert(!registry.has("proto1"));
}

@safe unittest {
    // Test ConfigPrototype cloning
    auto original = new ConfigPrototype("development", 3000, true);
    original.addHost("localhost");
    original.addHost("127.0.0.1");
    
    auto cloned = original.clone();
    assert(cloned.environment == "development");
    assert(cloned.port == 3000);
    assert(cloned.debugMode == true);
    assert(cloned.allowedHosts.length == 2);
    
    // Verify independence
    cloned.addHost("0.0.0.0");
    assert(original.allowedHosts.length == 2);
    assert(cloned.allowedHosts.length == 3);
}

@safe unittest {
    // Test creating instances from prototype template
    auto protoTemplate = new ConcretePrototype(0, "template", 0.0);
    
    auto instance1 = protoTemplate.clone();
    instance1.id = 1;
    instance1.name = "instance1";
    
    auto instance2 = protoTemplate.clone();
    instance2.id = 2;
    instance2.name = "instance2";
    
    assert(instance1.id != instance2.id);
    assert(instance1.name != instance2.name);
    assert(protoTemplate.id == 0);
    assert(protoTemplate.name == "template");
}
