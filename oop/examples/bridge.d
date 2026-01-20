module oop.examples.bridge;

import std.stdio;
import uim.oop.patterns.bridges;
import std.string : toUpper, toLower, capitalize;

void main() {
    writeln("=== Bridge Pattern Examples ===\n");
    
    // Example 1: Basic Bridge Pattern
    writeln("1. Basic Bridge Pattern:");
    auto implA = new ConcreteImplementorA();
    auto implB = new ConcreteImplementorB();
    
    auto abstraction = new BridgeAbstraction(implA);
    writeln("   With Implementor A:");
    writeln("   ", abstraction.operation());
    
    abstraction.implementor = implB;
    writeln("\n   With Implementor B:");
    writeln("   ", abstraction.operation());
    writeln();
    
    // Example 2: Extended Abstraction
    writeln("2. Extended Abstraction:");
    auto extended = new ExtendedAbstraction(implA);
    writeln("   Basic operation:");
    writeln("   ", extended.operation());
    writeln("\n   Extended operation:");
    writeln("   ", extended.extendedOperation());
    writeln();
    
    // Example 3: Refined Abstraction
    writeln("3. Refined Abstraction:");
    auto refined = new RefinedAbstraction("SmartDevice", implB);
    writeln("   Device: ", refined.name);
    writeln("   ", refined.operation());
    writeln("\n   ", refined.specialOperation());
    writeln();
    
    // Example 4: Generic String Processing
    writeln("4. Generic String Processing:");
    auto upperProcessor = new StringProcessorImpl("Uppercase", (string s) => s.toUpper());
    auto lowerProcessor = new StringProcessorImpl("Lowercase", (string s) => s.toLower());
    auto capProcessor = new StringProcessorImpl("Capitalize", (string s) => s.capitalize());
    
    auto stringAbs = new GenericAbstraction!string(upperProcessor);
    writeln("   Original: 'hello world'");
    writeln("   With ", stringAbs.implementor.name, ": '", stringAbs.execute("hello world"), "'");
    
    stringAbs.implementor = lowerProcessor;
    writeln("   With ", stringAbs.implementor.name, ": '", stringAbs.execute("HELLO WORLD"), "'");
    
    stringAbs.implementor = capProcessor;
    writeln("   With ", stringAbs.implementor.name, ": '", stringAbs.execute("hello world"), "'");
    writeln();
    
    // Example 5: Generic Integer Processing
    writeln("5. Generic Integer Processing:");
    auto doubleProc = new IntProcessorImpl("Double", (int x) => x * 2);
    auto squareProc = new IntProcessorImpl("Square", (int x) => x * x);
    auto incrementProc = new IntProcessorImpl("Increment", (int x) => x + 1);
    
    auto intAbs = new GenericAbstraction!int(doubleProc);
    writeln("   Input: 5");
    writeln("   ", intAbs.implementor.name, ": ", intAbs.execute(5));
    
    intAbs.implementor = squareProc;
    writeln("   ", intAbs.implementor.name, ": ", intAbs.execute(5));
    
    intAbs.implementor = incrementProc;
    writeln("   ", intAbs.implementor.name, ": ", intAbs.execute(5));
    writeln();
    
    // Example 6: Caching Abstraction
    writeln("6. Caching Abstraction:");
    int computeCount = 0;
    auto expensiveProc = new IntProcessorImpl("Expensive", (int x) {
        computeCount++;
        writeln("     [Computing ", x, " * ", x, "...]");
        return x * x;
    });
    
    auto cachingAbs = new CachingAbstraction!int(expensiveProc);
    
    writeln("   First call (computed):");
    int result1 = cachingAbs.execute(7);
    writeln("   Result: ", result1, " (computed ", computeCount, " time)");
    
    writeln("\n   Second call (cached):");
    int result2 = cachingAbs.execute(7);
    writeln("   Result: ", result2, " (still computed ", computeCount, " time)");
    
    writeln("\n   After clearing cache:");
    cachingAbs.clearCache();
    int result3 = cachingAbs.execute(7);
    writeln("   Result: ", result3, " (computed ", computeCount, " times total)");
    writeln();
    
    // Example 7: Cross-Platform UI Rendering
    writeln("7. Cross-Platform UI Rendering:");
    auto windowsPlatform = new WindowsPlatform();
    auto linuxPlatform = new LinuxPlatform();
    
    writeln("   --- Windows Platform ---");
    auto windowsRemote = new RemoteControl("Smart TV", windowsPlatform);
    writeln(windowsRemote.render());
    
    writeln("   --- Linux Platform ---");
    auto linuxRemote = new RemoteControl("Smart TV", linuxPlatform);
    writeln(linuxRemote.render());
    
    // Example 8: Advanced Remote with Platform Switching
    writeln("8. Advanced Remote with Platform Switching:");
    auto advancedRemote = new AdvancedRemote("4K TV", windowsPlatform);
    
    writeln("   On Windows:");
    writeln(advancedRemote.render());
    
    writeln("   Settings:");
    writeln(advancedRemote.renderSettings());
    
    writeln("\n   Switching to Linux...");
    advancedRemote.platform = linuxPlatform;
    writeln(advancedRemote.render());
    
    // Example 9: Multiple Abstractions, One Implementor
    writeln("9. Multiple Abstractions Sharing Implementor:");
    auto sharedImpl = new ConcreteImplementorA();
    
    auto basic = new BridgeAbstraction(sharedImpl);
    auto extd = new ExtendedAbstraction(sharedImpl);
    auto ref1 = new RefinedAbstraction("Device1", sharedImpl);
    
    writeln("   Basic Abstraction:");
    writeln("   ", basic.operation());
    
    writeln("\n   Extended Abstraction:");
    writeln("   ", extd.extendedOperation());
    
    writeln("\n   Refined Abstraction:");
    writeln("   ", ref1.specialOperation());
}
