/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module examples.objectpool;

import uim.oop;
import std.stdio;
import std.datetime.stopwatch;
import core.thread;

// Example 1: Basic object pooling
class DatabaseConnection {
  string connectionString;
  bool isOpen;

  this() {
    connectionString = "localhost:5432";
    isOpen = false;
    writeln("Creating new database connection (expensive operation)");
  }

  void open() {
    isOpen = true;
    writeln("Connection opened");
  }

  void close() {
    isOpen = false;
    writeln("Connection closed");
  }

  void executeQuery(string query) {
    writeln("Executing: ", query);
  }
}

// Example 2: Poolable object with reset
class HttpRequest : IPoolable {
  string url;
  string[string] headers;
  string body;

  this() {
    reset();
  }

  void reset() {
    url = "";
    headers.clear();
    body = "";
  }

  bool isValidForPool() {
    return true;
  }

  void setRequest(string newUrl, string newBody) {
    url = newUrl;
    body = newBody;
  }
}

// Example 3: Custom poolable object
class StringBuilder : IPoolable {
  char[] buffer;
  size_t length;

  this() {
    buffer = new char[1024];
    length = 0;
  }

  void append(string text) {
    foreach (ch; text) {
      if (length < buffer.length) {
        buffer[length++] = ch;
      }
    }
  }

  string toString() {
    return buffer[0 .. length].idup;
  }

  void reset() {
    length = 0;
  }

  bool isValidForPool() {
    return buffer.length > 0;
  }
}

void main() {
  writeln("=== Object Pool Examples ===\n");

  // Example 1: Basic pool usage
  writeln("1. Basic Object Pool:");
  auto dbPool = createObjectPool(() => new DatabaseConnection(), 2, 5);
  
  auto conn1 = dbPool.acquire();
  conn1.open();
  conn1.executeQuery("SELECT * FROM users");
  conn1.close();
  dbPool.release(conn1);
  
  auto conn2 = dbPool.acquire(); // Reuses conn1
  writeln("Available connections: ", dbPool.available());
  dbPool.release(conn2);
  writeln();

  // Example 2: RAII Scoped pooling
  writeln("2. Scoped (RAII) Pooling:");
  auto requestPool = createScopedPool(() => new HttpRequest(), 5, 20);
  
  {
    auto req = requestPool.acquireScoped();
    req.setRequest("https://api.example.com/data", "{}");
    writeln("Request URL: ", req.url);
    writeln("Pool available: ", requestPool.available());
  } // req automatically returned to pool here
  
  writeln("After scope - available: ", requestPool.available());
  writeln();

  // Example 3: Pool with statistics
  writeln("3. Pool Statistics:");
  auto stringPool = createObjectPool(() => new StringBuilder(), 3, 10);
  
  for (int i = 0; i < 5; i++) {
    auto sb = stringPool.acquire();
    sb.append("Hello ");
    sb.append("World!");
    writeln(sb.toString());
    stringPool.release(sb);
  }
  
  auto stats = cast(IPoolStatistics)stringPool;
  if (stats) {
    writeln("Total acquires: ", stats.acquireCount());
    writeln("Total releases: ", stats.releaseCount());
    writeln("Objects created: ", stats.createCount());
    writeln("Peak acquired: ", stats.peakAcquired());
  }
  writeln();

  // Example 4: Pool builder pattern
  writeln("4. Pool Builder Pattern:");
  auto builderPool = poolBuilder(() => new DatabaseConnection())
    .initialCapacity(5)
    .maxCapacity(20)
    .threadSafe(false)
    .build();
  
  auto conn = builderPool.acquire();
  writeln("Acquired from builder pool");
  builderPool.release(conn);
  writeln();

  // Example 5: Global pool registry
  writeln("5. Pool Registry:");
  auto globalDbPool = createObjectPool(() => new DatabaseConnection(), 3, 10);
  PoolRegistry.register("database", globalDbPool);
  
  auto retrievedPool = PoolRegistry.get!DatabaseConnection("database");
  if (retrievedPool) {
    auto conn3 = retrievedPool.acquire();
    writeln("Acquired from registered pool");
    retrievedPool.release(conn3);
  }
  
  writeln("Pool registered: ", PoolRegistry.has("database"));
  PoolRegistry.unregister("database");
  writeln("After unregister: ", PoolRegistry.has("database"));
  writeln();

  // Example 6: Array pool
  writeln("6. Array Pool:");
  auto intArrayPool = createArrayPool!int(100, 5, 20);
  
  auto arr1 = intArrayPool.acquire();
  arr1[0] = 42;
  arr1[1] = 100;
  writeln("Array[0]: ", arr1[0], ", Array[1]: ", arr1[1]);
  
  intArrayPool.release(arr1);
  
  auto arr2 = intArrayPool.acquire();
  writeln("After release, Array[0]: ", arr2[0]); // Should be 0 (cleared)
  intArrayPool.release(arr2);
  writeln();

  // Example 7: Thread-safe pool
  writeln("7. Thread-Safe Pool:");
  auto threadSafePool = createThreadSafePool(() => new StringBuilder(), 10, 50);
  
  auto obj = threadSafePool.acquire();
  obj.append("Thread-safe!");
  writeln(obj.toString());
  threadSafePool.release(obj);
  writeln();

  // Example 8: Performance comparison
  writeln("8. Performance Comparison:");
  
  // Without pooling
  auto sw1 = StopWatch(AutoStart.yes);
  for (int i = 0; i < 1000; i++) {
    auto temp = new StringBuilder();
    temp.append("Test");
  }
  sw1.stop();
  
  // With pooling
  auto perfPool = createObjectPool(() => new StringBuilder(), 10, 50);
  auto sw2 = StopWatch(AutoStart.yes);
  for (int i = 0; i < 1000; i++) {
    auto temp = perfPool.acquire();
    temp.append("Test");
    perfPool.release(temp);
  }
  sw2.stop();
  
  writeln("Without pool: ", sw1.peek().total!"usecs", " μs");
  writeln("With pool: ", sw2.peek().total!"usecs", " μs");
  writeln("Speedup: ", cast(double)sw1.peek().total!"usecs" / sw2.peek().total!"usecs", "x");
  writeln();

  // Example 9: Multiple scoped objects
  writeln("9. Multiple Scoped Objects:");
  auto multiPool = createScopedPool(() => new HttpRequest(), 5, 15);
  
  {
    auto req1 = multiPool.acquireScoped();
    auto req2 = multiPool.acquireScoped();
    auto req3 = multiPool.acquireScoped();
    
    req1.setRequest("/api/users", "");
    req2.setRequest("/api/posts", "");
    req3.setRequest("/api/comments", "");
    
    writeln("Active requests: 3");
    writeln("Available in pool: ", multiPool.available());
  } // All three released here
  
  writeln("After scope - available: ", multiPool.available());
  writeln();

  // Example 10: Pool capacity management
  writeln("10. Pool Capacity Management:");
  auto capacityPool = createObjectPool(() => new StringBuilder(), 2, 5);
  
  writeln("Initial capacity: ", capacityPool.capacity());
  writeln("Available: ", capacityPool.available());
  
  auto objs = new StringBuilder[7];
  foreach (i; 0 .. 7) {
    objs[i] = capacityPool.acquire();
  }
  
  foreach (obj; objs) {
    capacityPool.release(obj);
  }
  
  writeln("After releasing 7 objects:");
  writeln("Available (capped at capacity): ", capacityPool.available());
  writeln("Total created: ", capacityPool.totalCount());

  writeln("\n=== Examples completed successfully! ===");
}
