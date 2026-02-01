/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module compilers.examples.ctfe;

import std.stdio;
import std.algorithm;
import std.range;
import std.conv;

void main() {
    writeln("=== Compile-Time Function Execution (CTFE) Example ===\n");

    // Example 1: Fibonacci at compile-time
    writeln("1. Fibonacci numbers calculated at compile-time:");
    
    int fibonacci(int n) {
        if (n <= 1) return n;
        return fibonacci(n - 1) + fibonacci(n - 2);
    }
    
    enum fib10 = fibonacci(10);
    enum fib15 = fibonacci(15);
    enum fib20 = fibonacci(20);
    
    writeln("  Fibonacci(10) = ", fib10, " (computed at compile-time)");
    writeln("  Fibonacci(15) = ", fib15, " (computed at compile-time)");
    writeln("  Fibonacci(20) = ", fib20, " (computed at compile-time)");
    writeln();

    // Example 2: String manipulation at compile-time
    writeln("2. String processing at compile-time:");
    
    string toUpperCompileTime(string s) {
        char[] result;
        foreach (c; s) {
            if (c >= 'a' && c <= 'z')
                result ~= cast(char)(c - 32);
            else
                result ~= c;
        }
        return cast(string)result;
    }
    
    enum message = "hello world";
    enum upperMessage = toUpperCompileTime(message);
    
    writeln("  Original: ", message);
    writeln("  Uppercase (compile-time): ", upperMessage);
    writeln();

    // Example 3: Generate lookup tables at compile-time
    writeln("3. Generating lookup tables at compile-time:");
    
    int[] generateSquares(int n) {
        int[] result;
        for (int i = 0; i < n; i++) {
            result ~= i * i;
        }
        return result;
    }
    
    enum squares = generateSquares(10);
    
    writeln("  Squares of 0-9 (pre-computed at compile-time):");
    foreach (i, sq; squares) {
        writeln("    ", i, "² = ", sq);
    }
    writeln();

    // Example 4: Parse configuration at compile-time
    writeln("4. Parsing simple config at compile-time:");
    
    struct Config {
        string name;
        int value;
    }
    
    Config parseConfig(string data) {
        Config config;
        auto lines = data.split("\n");
        foreach (line; lines) {
            if (line.length == 0) continue;
            auto parts = line.split("=");
            if (parts.length == 2) {
                auto key = parts[0];
                auto val = parts[1];
                if (key == "name") config.name = val;
                if (key == "value") config.value = val.to!int;
            }
        }
        return config;
    }
    
    enum configData = "name=MyApp\nvalue=42";
    enum config = parseConfig(configData);
    
    writeln("  Configuration (parsed at compile-time):");
    writeln("    Name: ", config.name);
    writeln("    Value: ", config.value);
    writeln();

    // Example 5: Prime numbers sieve at compile-time
    writeln("5. Prime numbers calculated at compile-time:");
    
    bool[] sieveOfEratosthenes(int n) {
        bool[] isPrime = new bool[n + 1];
        isPrime[] = true;
        isPrime[0] = isPrime[1] = false;
        
        for (int i = 2; i * i <= n; i++) {
            if (isPrime[i]) {
                for (int j = i * i; j <= n; j += i) {
                    isPrime[j] = false;
                }
            }
        }
        return isPrime;
    }
    
    int[] getPrimes(int n) {
        auto isPrime = sieveOfEratosthenes(n);
        int[] primes;
        for (int i = 2; i <= n; i++) {
            if (isPrime[i]) primes ~= i;
        }
        return primes;
    }
    
    enum primes = getPrimes(50);
    
    writeln("  Primes up to 50 (computed at compile-time):");
    write("    ");
    foreach (i, p; primes) {
        write(p);
        if (i < primes.length - 1) write(", ");
    }
    writeln();
    writeln();

    // Example 6: Compile-time validation
    writeln("6. Compile-time validation:");
    
    string validateEmail(string email) {
        if (email.indexOf("@") == -1)
            return "Invalid email: missing @";
        if (email.indexOf(".") == -1)
            return "Invalid email: missing domain extension";
        return "Valid";
    }
    
    enum email1 = "user@example.com";
    enum validation1 = validateEmail(email1);
    
    enum email2 = "invalid-email";
    enum validation2 = validateEmail(email2);
    
    writeln("  Email validation (compile-time):");
    writeln("    ", email1, " -> ", validation1);
    writeln("    ", email2, " -> ", validation2);
    writeln();

    // Example 7: Generate code based on compile-time calculations
    writeln("7. Generate array sizes based on compile-time math:");
    
    int computeBufferSize(int itemSize, int maxItems) {
        return itemSize * maxItems + 64; // Add 64 bytes for header
    }
    
    enum bufferSize = computeBufferSize(16, 100);
    
    static ubyte[bufferSize] buffer;
    
    writeln("  Buffer size: ", bufferSize, " bytes (computed at compile-time)");
    writeln("  Actual buffer allocated: ", buffer.length, " bytes");
    writeln();

    // Example 8: Compile-time string formatting
    writeln("8. Compile-time string building:");
    
    string buildVersionString(int major, int minor, int patch) {
        return major.to!string ~ "." ~ minor.to!string ~ "." ~ patch.to!string;
    }
    
    enum versionString = buildVersionString(1, 2, 3);
    
    writeln("  Version: ", versionString, " (built at compile-time)");
    writeln();

    writeln("=== Example Complete ===");
}
