module uim.oop.patterns.bridges.bridge;

import uim.oop.patterns.bridges.interfaces;

/**
 * Base class for the Abstraction side of the bridge.
 * Maintains a reference to an IImplementor object.
 */
class BridgeAbstraction : IBridgeAbstraction {
    protected IImplementor _implementor;
    
    this(IImplementor implementor) @safe {
        _implementor = implementor;
    }
    
    string operation() @safe {
        return "Abstraction: Base operation with:\n" ~ _implementor.operationImpl();
    }
    
    IImplementor implementor() @safe {
        return _implementor;
    }
    
    void implementor(IImplementor impl) @safe {
        _implementor = impl;
    }
}

/**
 * Extended abstraction provides additional functionality.
 */
class ExtendedAbstraction : BridgeAbstraction, IExtendedAbstraction {
    this(IImplementor implementor) @safe {
        super(implementor);
    }
    
    override string operation() @safe {
        return "ExtendedAbstraction: Extended operation with:\n" ~ _implementor.operationImpl();
    }
    
    string extendedOperation() @safe {
        return "ExtendedAbstraction: Extended operation with extra features:\n" ~ 
               _implementor.operationImpl() ~ "\n+ Additional processing";
    }
}

/**
 * Concrete implementor A.
 */
class ConcreteImplementorA : IImplementor {
    string operationImpl() @safe {
        return "ConcreteImplementorA: Implementation A processing";
    }
}

/**
 * Concrete implementor B.
 */
class ConcreteImplementorB : IImplementor {
    string operationImpl() @safe {
        return "ConcreteImplementorB: Implementation B processing";
    }
}

/**
 * Refined abstraction with specific behavior.
 */
class RefinedAbstraction : BridgeAbstraction {
    private string _name;
    
    this(string name, IImplementor implementor) @safe {
        super(implementor);
        _name = name;
    }
    
    @property string name() const @safe { return _name; }
    
    override string operation() @safe {
        return "RefinedAbstraction [" ~ _name ~ "]: Operation with:\n" ~ 
               _implementor.operationImpl();
    }
    
    string specialOperation() @safe {
        return "RefinedAbstraction [" ~ _name ~ "]: Special operation:\n" ~ 
               _implementor.operationImpl() ~ "\n+ Refined processing";
    }
}

/**
 * Generic implementor for processing strings.
 */
class StringProcessorImpl : IGenericImplementor!string {
    private string _name;
    private string delegate(string) _processor;
    
    this(string name, string delegate(string) processor) @safe {
        _name = name;
        _processor = processor;
    }
    
    string process(string data) @trusted {
        return _processor(data);
    }
    
    string name() @safe {
        return _name;
    }
}

/**
 * Generic implementor for processing integers.
 */
class IntProcessorImpl : IGenericImplementor!int {
    private string _name;
    private int delegate(int) _processor;
    
    this(string name, int delegate(int) processor) @safe {
        _name = name;
        _processor = processor;
    }
    
    int process(int data) @trusted {
        return _processor(data);
    }
    
    string name() @safe {
        return _name;
    }
}

/**
 * Generic abstraction implementation.
 */
class GenericAbstraction(T) : IGenericAbstraction!T {
    protected IGenericImplementor!T _implementor;
    
    this(IGenericImplementor!T implementor) @safe {
        _implementor = implementor;
    }
    
    T execute(T data) @trusted {
        return _implementor.process(data);
    }
    
    IGenericImplementor!T implementor() @safe {
        return _implementor;
    }
    
    void implementor(IGenericImplementor!T impl) @safe {
        _implementor = impl;
    }
}

/**
 * Refined generic abstraction with caching.
 */
class CachingAbstraction(T) : GenericAbstraction!T {
    private T _cachedResult;
    private bool _hasCached;
    
    this(IGenericImplementor!T implementor) @safe {
        super(implementor);
        _hasCached = false;
    }
    
    override T execute(T data) @trusted {
        if (!_hasCached) {
            _cachedResult = _implementor.process(data);
            _hasCached = true;
        }
        return _cachedResult;
    }
    
    void clearCache() @safe {
        _hasCached = false;
    }
    
    bool hasCached() const @safe {
        return _hasCached;
    }
}

// Real-world example: Device abstraction with platform implementations

/**
 * Platform interface for device operations.
 */
interface IPlatform {
    string getName() @safe;
    string renderButton(string text) @safe;
    string renderCheckbox(string label, bool checked) @safe;
    string renderInput(string placeholder) @safe;
}

/**
 * Windows platform implementation.
 */
class WindowsPlatform : IPlatform {
    string getName() @safe {
        return "Windows";
    }
    
    string renderButton(string text) @safe {
        return "[Windows Button: " ~ text ~ "]";
    }
    
    string renderCheckbox(string label, bool checked) @safe {
        return "[Windows Checkbox: " ~ label ~ " - " ~ (checked ? "☑" : "☐") ~ "]";
    }
    
    string renderInput(string placeholder) @safe {
        return "[Windows Input: " ~ placeholder ~ "]";
    }
}

/**
 * Linux platform implementation.
 */
class LinuxPlatform : IPlatform {
    string getName() @safe {
        return "Linux";
    }
    
    string renderButton(string text) @safe {
        return "[ " ~ text ~ " ]";
    }
    
    string renderCheckbox(string label, bool checked) @safe {
        return "[" ~ (checked ? "x" : " ") ~ "] " ~ label;
    }
    
    string renderInput(string placeholder) @safe {
        return "[ ___" ~ placeholder ~ "___ ]";
    }
}

/**
 * Device abstraction using platform implementor.
 */
abstract class Device {
    protected IPlatform _platform;
    
    this(IPlatform platform) @safe {
        _platform = platform;
    }
    
    @property IPlatform platform() @safe {
        return _platform;
    }
    
    @property void platform(IPlatform p) @safe {
        _platform = p;
    }
    
    abstract string render() @safe;
}

/**
 * Remote control device.
 */
class RemoteControl : Device {
    private string _deviceName;
    
    this(string deviceName, IPlatform platform) @safe {
        super(platform);
        _deviceName = deviceName;
    }
    
    override string render() @safe {
        string result = "Remote Control for " ~ _deviceName ~ " on " ~ _platform.getName() ~ ":\n";
        result ~= _platform.renderButton("Power") ~ "\n";
        result ~= _platform.renderButton("Volume Up") ~ "\n";
        result ~= _platform.renderButton("Volume Down") ~ "\n";
        return result;
    }
}

/**
 * Advanced remote control with more features.
 */
class AdvancedRemote : RemoteControl {
    this(string deviceName, IPlatform platform) @safe {
        super(deviceName, platform);
    }
    
    override string render() @safe {
        string result = super.render();
        result ~= _platform.renderButton("Mute") ~ "\n";
        result ~= _platform.renderCheckbox("Smart Mode", true) ~ "\n";
        return result;
    }
    
    string renderSettings() @safe {
        string result = "Settings Panel on " ~ _platform.getName() ~ ":\n";
        result ~= _platform.renderInput("Device Name") ~ "\n";
        result ~= _platform.renderCheckbox("Auto-connect", false) ~ "\n";
        return result;
    }
}

@safe unittest {
    // Test basic bridge pattern
    auto implA = new ConcreteImplementorA();
    auto abstraction = new BridgeAbstraction(implA);
    
    string result = abstraction.operation();
    assert(result.length > 0);
}

@safe unittest {
    // Test switching implementors
    auto implA = new ConcreteImplementorA();
    auto implB = new ConcreteImplementorB();
    auto abstraction = new BridgeAbstraction(implA);
    
    string result1 = abstraction.operation();
    
    abstraction.implementor = implB;
    string result2 = abstraction.operation();
    
    assert(result1 != result2);
}

@safe unittest {
    // Test extended abstraction
    auto impl = new ConcreteImplementorA();
    auto extended = new ExtendedAbstraction(impl);
    
    string basicResult = extended.operation();
    string extendedResult = extended.extendedOperation();
    
    assert(basicResult.length > 0);
    assert(extendedResult.length > basicResult.length);
}

@safe unittest {
    // Test refined abstraction
    auto impl = new ConcreteImplementorB();
    auto refined = new RefinedAbstraction("TestDevice", impl);
    
    assert(refined.name == "TestDevice");
    
    string result = refined.operation();
    assert(result.length > 0);
    
    string specialResult = refined.specialOperation();
    assert(specialResult.length > result.length);
}

@safe unittest {
    // Test generic string processor
    auto upperImpl = new StringProcessorImpl("Upper", (string s) => s.toUpper());
    auto abstraction = new GenericAbstraction!string(upperImpl);
    
    string result = abstraction.execute("hello");
    assert(result == "HELLO");
}

@safe unittest {
    // Test generic int processor
    auto doubleImpl = new IntProcessorImpl("Double", (int x) => x * 2);
    auto abstraction = new GenericAbstraction!int(doubleImpl);
    
    int result = abstraction.execute(5);
    assert(result == 10);
}

@safe unittest {
    // Test caching abstraction
    int callCount = 0;
    auto impl = new IntProcessorImpl("Counter", (int x) {
        callCount++;
        return x * 2;
    });
    auto caching = new CachingAbstraction!int(impl);
    
    assert(!caching.hasCached);
    
    int result1 = caching.execute(5);
    assert(result1 == 10);
    assert(caching.hasCached);
    assert(callCount == 1);
    
    // Second call should use cache
    int result2 = caching.execute(5);
    assert(result2 == 10);
    assert(callCount == 1); // Still 1, not called again
    
    caching.clearCache();
    assert(!caching.hasCached);
}

@safe unittest {
    // Test switching implementors on generic abstraction
    auto upper = new StringProcessorImpl("Upper", (string s) => s.toUpper());
    auto lower = new StringProcessorImpl("Lower", (string s) => s.toLower());
    
    auto abstraction = new GenericAbstraction!string(upper);
    assert(abstraction.execute("Test") == "TEST");
    
    abstraction.implementor = lower;
    assert(abstraction.execute("Test") == "test");
}

// Import for string operations
import std.string : toUpper, toLower;
