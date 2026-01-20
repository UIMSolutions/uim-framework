# UIM-JSONRPC - JSON-RPC 2.0 Library

**Version**: 1.0.0  
**Author**: Ozan Nurettin Süel (aka UIManufaktur)  
**License**: Apache 2.0  
**Language**: D

## Overview

UIM-JSONRPC is a complete JSON-RPC 2.0 protocol implementation for the D programming language. It provides both client and server functionality with full support for the JSON-RPC 2.0 specification.

## Features

- **Full JSON-RPC 2.0 Support**: Complete implementation of the specification
- **Request/Response**: Standard request-response pattern
- **Notifications**: Fire-and-forget calls without responses
- **Batch Requests**: Execute multiple calls in a single request
- **Error Handling**: Standard error codes and custom errors
- **Client & Server**: Both client and server implementations
- **Type Safe**: Strongly typed D implementation
- **Easy to Use**: Fluent API and factory functions

## Installation

Add to your `dub.sdl`:

```sdl
dependency "uim-jsonrpc" path="../jsonrpc"
```

## JSON-RPC 2.0 Specification

JSON-RPC is a stateless, light-weight remote procedure call (RPC) protocol. It uses JSON as data format.

### Request Format
```json
{
  "jsonrpc": "2.0",
  "method": "methodName",
  "params": [1, 2, 3],
  "id": 1
}
```

### Response Format
```json
{
  "jsonrpc": "2.0",
  "result": 42,
  "id": 1
}
```

### Error Format
```json
{
  "jsonrpc": "2.0",
  "error": {
    "code": -32601,
    "message": "Method not found"
  },
  "id": 1
}
```

## Usage Examples

### Server Implementation

```d
import uim.jsons;

// Create server
auto server = new DJSONRPCServer();

// Register methods
server.register("add", (Json params) {
    auto arr = params.get!(Json[]);
    long a = arr[0].get!long;
    long b = arr[1].get!long;
    return Json(a + b);
});

server.register("subtract", (Json params) {
    auto arr = params.get!(Json[]);
    return Json(arr[0].get!long - arr[1].get!long);
});

server.register("multiply", (Json params) {
    auto obj = params.get!(Json[string]);
    long a = obj["a"].get!long;
    long b = obj["b"].get!long;
    return Json(a * b);
});

// Handle request
string requestJson = `{"jsonrpc": "2.0", "method": "add", "params": [5, 3], "id": 1}`;
string responseJson = server.handleRequest(requestJson);
// Returns: {"jsonrpc":"2.0","result":8,"id":1}
```

### Client Implementation

```d
import uim.jsons;

// Create client
auto client = new DJSONRPCClient();

// Build a request
string requestJson = client.buildCall("add", Json([Json(5), Json(3)]));
// Sends: {"jsonrpc":"2.0","method":"add","params":[5,3],"id":1}

// Parse response
string responseJson = `{"jsonrpc": "2.0", "result": 8, "id": 1}`;
auto response = client.parseResponse(responseJson);

if (response.isSuccess()) {
    writeln("Result: ", response.result.get!long);
} else {
    writeln("Error: ", response.error.message);
}
```

### Notifications (No Response)

```d
// Server side
server.register("log", (Json params) {
    writeln("Log: ", params.get!string);
    return Json(null);  // Return value is ignored for notifications
});

// Client side
string notificationJson = client.buildNotification("log", Json("Something happened"));
// Sends: {"jsonrpc":"2.0","method":"log","params":"Something happened"}
// No "id" field, so no response expected
```

### Batch Requests

```d
// Client side - create batch
auto batch = client.createBatch();
batch.add(client.createRequest("add", Json([Json(1), Json(2)])));
batch.add(client.createRequest("subtract", Json([Json(10), Json(3)])));
batch.add(client.createNotification("log", Json("Batch executed")));

string batchJson = batch.toJson().toString();
// Send batchJson to server

// Server side - handle batch
string batchResponseJson = server.handleRequest(batchJson);

// Client side - parse batch response
auto batchResponse = client.parseBatchResponse(batchResponseJson);
foreach (response; batchResponse.responses()) {
    if (response.isSuccess()) {
        writeln("Result: ", response.result);
    }
}
```

### Error Handling

```d
import uim.jsons;

// Using predefined errors
auto error1 = methodNotFound("calculatePi");
auto error2 = invalidParams("Expected array with 2 elements");
auto error3 = internalError("Database connection failed");

// Custom server errors (-32000 to -32099)
auto error4 = serverError(-32001, "Rate limit exceeded");

// Error response
auto errorResponse = errorResponse(error1, Json(1));
```

### Complete Example: Calculator Service

```d
import uim.jsons;
import std.stdio;

void main() {
    // Create and configure server
    auto server = new DJSONRPCServer();
    
    // Register calculator methods
    server.register("add", (Json params) {
        auto arr = params.get!(Json[]);
        return Json(arr[0].get!double + arr[1].get!double);
    });
    
    server.register("subtract", (Json params) {
        auto arr = params.get!(Json[]);
        return Json(arr[0].get!double - arr[1].get!double);
    });
    
    server.register("multiply", (Json params) {
        auto arr = params.get!(Json[]);
        return Json(arr[0].get!double * arr[1].get!double);
    });
    
    server.register("divide", (Json params) {
        auto arr = params.get!(Json[]);
        double divisor = arr[1].get!double;
        
        if (divisor == 0) {
            throw new Exception("Division by zero");
        }
        
        return Json(arr[0].get!double / divisor);
    });
    
    // Create client
    auto client = new DJSONRPCClient();
    
    // Test operations
    void testOperation(string method, double a, double b) {
        string request = client.buildCall(method, Json([Json(a), Json(b)]));
        writeln("Request: ", request);
        
        string response = server.handleRequest(request);
        writeln("Response: ", response);
        
        auto resp = client.parseResponse(response);
        if (resp.isSuccess()) {
            writeln("Result: ", resp.result.get!double);
        } else {
            writeln("Error: ", resp.error.message);
        }
        writeln();
    }
    
    testOperation("add", 15, 7);       // 22
    testOperation("subtract", 15, 7);  // 8
    testOperation("multiply", 15, 7);  // 105
    testOperation("divide", 15, 3);    // 5
    testOperation("divide", 15, 0);    // Error
}
```

### Named Parameters (Object Params)

```d
// Server side
server.register("createUser", (Json params) {
    auto obj = params.get!(Json[string]);
    string name = obj["name"].get!string;
    int age = obj["age"].get!int;
    string email = obj["email"].get!string;
    
    // Create user logic...
    
    return Json.emptyObject;
});

// Client side with object params
auto params = Json.emptyObject;
params["name"] = "John Doe";
params["age"] = 30;
params["email"] = "john@example.com";

string request = client.buildCall("createUser", params);
```

### Custom Method Handler Class

```d
class MyService {
    Json handleGetUser(Json params) {
        long userId = params.get!(Json[])[ 0].get!long;
        
        auto user = Json.emptyObject;
        user["id"] = userId;
        user["name"] = "User " ~ userId.to!string;
        
        return user;
    }
    
    Json handleUpdateUser(Json params) {
        auto obj = params.get!(Json[string]);
        // Update logic...
        return Json(true);
    }
}

// Register service methods
auto service = new MyService();
server.register("getUser", &service.handleGetUser);
server.register("updateUser", &service.handleUpdateUser);
```

### Validation and Error Codes

```d
// Standard error codes
enum JSONRPCErrorCode : int {
    ParseError = -32700,      // Invalid JSON
    InvalidRequest = -32600,  // Invalid Request object
    MethodNotFound = -32601,  // Method does not exist
    InvalidParams = -32602,   // Invalid method parameters
    InternalError = -32603,   // Internal JSON-RPC error
    ServerError = -32000      // -32000 to -32099 reserved
}

// Validate request
auto request = DJSONRPCRequest.fromJson(json);
if (!request.validate()) {
    return errorResponse(invalidRequest(), request.id);
}
```

### Async Server Pattern

```d
import std.parallelism : task;

class AsyncJSONRPCServer : DJSONRPCServer {
    string handleRequestAsync(string requestJson) {
        auto t = task!handleRequest(requestJson);
        t.executeInNewThread();
        // In real implementation, return a future or use callbacks
        return t.yieldForce();
    }
}
```

## API Reference

### Classes

#### `DJSONRPCRequest`
- `method()` / `method(string)` - Get/set method name
- `params()` / `params(Json)` - Get/set parameters
- `id()` / `id(Json)` - Get/set request ID
- `isNotification()` - Check if notification
- `toJson()` - Convert to JSON
- `fromJson(Json)` - Create from JSON
- `validate()` - Validate request structure

#### `DJSONRPCResponse`
- `result()` / `result(Json)` - Get/set result
- `error()` / `error(DJSONRPCError)` - Get/set error
- `id()` / `id(Json)` - Get/set response ID
- `isSuccess()` - Check if successful
- `isError()` - Check if error
- `toJson()` - Convert to JSON
- `fromJson(Json)` - Create from JSON

#### `DJSONRPCError`
- `code()` / `code(int)` - Get/set error code
- `message()` / `message(string)` - Get/set error message
- `data()` / `data(Json)` - Get/set additional error data
- `toJson()` - Convert to JSON

#### `DJSONRPCServer`
- `register(string, JSONRPCHandler)` - Register method handler
- `handleRequest(string)` - Process request JSON string
- `methods()` - Get list of registered methods

#### `DJSONRPCClient`
- `createRequest(string, Json)` - Create new request
- `createNotification(string, Json)` - Create notification
- `createBatch()` - Create batch request
- `buildCall(string, Json)` - Build request JSON string
- `parseResponse(string)` - Parse response JSON string

## Error Codes

| Code | Message | Description |
|------|---------|-------------|
| -32700 | Parse error | Invalid JSON received |
| -32600 | Invalid Request | Invalid Request object |
| -32601 | Method not found | Method does not exist |
| -32602 | Invalid params | Invalid method parameters |
| -32603 | Internal error | Internal JSON-RPC error |
| -32000 to -32099 | Server error | Implementation-defined server errors |

## Testing

```bash
cd jsonrpc
dub test
```

## Future Enhancements

- WebSocket transport
- HTTP transport integration
- Async/await support
- Middleware support
- Authentication/authorization hooks
- Request/response logging
- Performance metrics

## Contributing

Contributions welcome! Please ensure:
- Code follows D best practices
- Unit tests included
- Documentation updated

## License

Copyright © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)

Licensed under the Apache License, Version 2.0.

## Dependencies

- uim-oop - Object-oriented patterns
- uim-core - Core utilities
- uim-json - JSON processing

## Resources

- [JSON-RPC 2.0 Specification](https://www.jsonrpc.org/specification)
- [JSON-RPC Wikipedia](https://en.wikipedia.org/wiki/JSON-RPC)
