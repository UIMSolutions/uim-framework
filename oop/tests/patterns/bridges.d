module oop.tests.patterns.bridges;

import uim.oop.patterns.bridges;
import std.string : toUpper, toLower;

@safe unittest {
    // Test basic abstraction with implementor A
    auto implA = new ConcreteImplementorA();
    auto abstraction = new BridgeAbstraction(implA);
    
    string result = abstraction.operation();
    assert(result.length > 0);
    assert(result.indexOf("ConcreteImplementorA") >= 0);
}

@safe unittest {
    // Test basic abstraction with implementor B
    auto implB = new ConcreteImplementorB();
    auto abstraction = new BridgeAbstraction(implB);
    
    string result = abstraction.operation();
    assert(result.length > 0);
    assert(result.indexOf("ConcreteImplementorB") >= 0);
}

@safe unittest {
    // Test switching implementors at runtime
    auto implA = new ConcreteImplementorA();
    auto implB = new ConcreteImplementorB();
    auto abstraction = new BridgeAbstraction(implA);
    
    string resultA = abstraction.operation();
    assert(resultA.indexOf("ConcreteImplementorA") >= 0);
    
    abstraction.implementor = implB;
    string resultB = abstraction.operation();
    assert(resultB.indexOf("ConcreteImplementorB") >= 0);
    assert(resultA != resultB);
}

@safe unittest {
    // Test extended abstraction
    auto impl = new ConcreteImplementorA();
    auto extended = new ExtendedAbstraction(impl);
    
    string basicResult = extended.operation();
    assert(basicResult.indexOf("ExtendedAbstraction") >= 0);
    
    string extendedResult = extended.extendedOperation();
    assert(extendedResult.indexOf("Extended operation with extra features") >= 0);
    assert(extendedResult.length > basicResult.length);
}

@safe unittest {
    // Test refined abstraction
    auto impl = new ConcreteImplementorB();
    auto refined = new RefinedAbstraction("MyDevice", impl);
    
    assert(refined.name == "MyDevice");
    
    string result = refined.operation();
    assert(result.indexOf("MyDevice") >= 0);
    
    string specialResult = refined.specialOperation();
    assert(specialResult.indexOf("Special operation") >= 0);
    assert(specialResult.indexOf("Refined processing") >= 0);
}

@safe unittest {
    // Test generic string processor with uppercase
    auto upperImpl = new StringProcessorImpl("Upper", (string s) => s.toUpper());
    auto abstraction = new GenericAbstraction!string(upperImpl);
    
    string result = abstraction.execute("hello world");
    assert(result == "HELLO WORLD");
    assert(abstraction.implementor.name == "Upper");
}

@safe unittest {
    // Test generic string processor with lowercase
    auto lowerImpl = new StringProcessorImpl("Lower", (string s) => s.toLower());
    auto abstraction = new GenericAbstraction!string(lowerImpl);
    
    string result = abstraction.execute("HELLO WORLD");
    assert(result == "hello world");
}

@safe unittest {
    // Test generic int processor with doubling
    auto doubleImpl = new IntProcessorImpl("Double", (int x) => x * 2);
    auto abstraction = new GenericAbstraction!int(doubleImpl);
    
    int result = abstraction.execute(10);
    assert(result == 20);
}

@safe unittest {
    // Test generic int processor with squaring
    auto squareImpl = new IntProcessorImpl("Square", (int x) => x * x);
    auto abstraction = new GenericAbstraction!int(squareImpl);
    
    int result = abstraction.execute(5);
    assert(result == 25);
}

@safe unittest {
    // Test switching generic implementors
    auto upper = new StringProcessorImpl("Upper", (string s) => s.toUpper());
    auto lower = new StringProcessorImpl("Lower", (string s) => s.toLower());
    
    auto abstraction = new GenericAbstraction!string(upper);
    assert(abstraction.execute("Test") == "TEST");
    
    abstraction.implementor = lower;
    assert(abstraction.execute("Test") == "test");
}

@safe unittest {
    // Test caching abstraction
    int processCount = 0;
    auto impl = new IntProcessorImpl("Counter", (int x) {
        processCount++;
        return x * 3;
    });
    
    auto caching = new CachingAbstraction!int(impl);
    
    assert(!caching.hasCached);
    assert(processCount == 0);
    
    int result1 = caching.execute(7);
    assert(result1 == 21);
    assert(caching.hasCached);
    assert(processCount == 1);
    
    // Second call uses cache
    int result2 = caching.execute(7);
    assert(result2 == 21);
    assert(processCount == 1); // Not incremented
    
    caching.clearCache();
    assert(!caching.hasCached);
    
    int result3 = caching.execute(7);
    assert(result3 == 21);
    assert(processCount == 2); // Now incremented
}

@safe unittest {
    // Test Windows platform
    auto windows = new WindowsPlatform();
    assert(windows.getName() == "Windows");
    
    string button = windows.renderButton("OK");
    assert(button.indexOf("Windows Button") >= 0);
    assert(button.indexOf("OK") >= 0);
}

@safe unittest {
    // Test Linux platform
    auto linux = new LinuxPlatform();
    assert(linux.getName() == "Linux");
    
    string button = linux.renderButton("OK");
    assert(button.indexOf("OK") >= 0);
}

@safe unittest {
    // Test remote control on Windows
    auto windows = new WindowsPlatform();
    auto remote = new RemoteControl("TV", windows);
    
    string rendered = remote.render();
    assert(rendered.indexOf("Remote Control for TV") >= 0);
    assert(rendered.indexOf("Windows") >= 0);
    assert(rendered.indexOf("Power") >= 0);
}

@safe unittest {
    // Test remote control on Linux
    auto linux = new LinuxPlatform();
    auto remote = new RemoteControl("TV", linux);
    
    string rendered = remote.render();
    assert(rendered.indexOf("Remote Control for TV") >= 0);
    assert(rendered.indexOf("Linux") >= 0);
}

@safe unittest {
    // Test switching platforms at runtime
    auto windows = new WindowsPlatform();
    auto linux = new LinuxPlatform();
    auto remote = new RemoteControl("TV", windows);
    
    string windowsRender = remote.render();
    assert(windowsRender.indexOf("Windows") >= 0);
    
    remote.platform = linux;
    string linuxRender = remote.render();
    assert(linuxRender.indexOf("Linux") >= 0);
    assert(windowsRender != linuxRender);
}

@safe unittest {
    // Test advanced remote control
    auto windows = new WindowsPlatform();
    auto advanced = new AdvancedRemote("Smart TV", windows);
    
    string rendered = advanced.render();
    assert(rendered.indexOf("Mute") >= 0);
    assert(rendered.indexOf("Smart Mode") >= 0);
    
    string settings = advanced.renderSettings();
    assert(settings.indexOf("Settings Panel") >= 0);
    assert(settings.indexOf("Device Name") >= 0);
}

@safe unittest {
    // Test multiple abstractions with same implementor
    auto impl = new ConcreteImplementorA();
    auto abs1 = new BridgeAbstraction(impl);
    auto abs2 = new ExtendedAbstraction(impl);
    
    string result1 = abs1.operation();
    string result2 = abs2.operation();
    
    assert(result1 != result2); // Different abstractions produce different results
    assert(result1.indexOf("ConcreteImplementorA") >= 0);
    assert(result2.indexOf("ConcreteImplementorA") >= 0);
}

// Import for indexOf
import std.string : indexOf;
