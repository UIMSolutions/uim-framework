/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module logging.examples.mixin_example;

import uim.logging;
import std.stdio;

/**
 * Example class using the logger mixin
 */
class UserService {
    mixin TLogger;
    
    void createUser(string username, string email) {
        logInfo("Creating new user", ["username": username, "email": email]);
        
        // Simulate user creation
        logDebug("Validating user data");
        logDebug("Checking if username is available");
        logDebug("Hashing password");
        logDebug("Saving to database");
        
        logInfo("User created successfully", ["username": username]);
    }
    
    void deleteUser(string userId) {
        logWarning("Deleting user", ["userId": userId]);
        
        // Simulate user deletion
        logDebug("Finding user in database");
        logDebug("Removing user data");
        
        logInfo("User deleted", ["userId": userId]);
    }
    
    void authenticateUser(string username, string password) {
        logInfo("Authenticating user", ["username": username]);
        
        // Simulate authentication failure
        logError("Authentication failed", [
            "username": username,
            "reason": "Invalid password"
        ]);
    }
}

void main() {
    writeln("=== Logger Mixin Example ===\n");
    
    // Create service instance
    auto service = new UserService();
    
    // The mixin automatically creates a console logger
    // You can also set a custom logger:
    service.logger = FileLogger("logs/user-service.log", "UserService");
    service.logger.level = LogLevel.debug_;
    
    // Use the service - logging happens automatically
    service.createUser("john.doe", "john@example.com");
    writeln();
    
    service.deleteUser("12345");
    writeln();
    
    service.authenticateUser("jane.doe", "wrongpassword");
    
    writeln("\nCheck logs/user-service.log for detailed logs");
    
    service.logger.close();
}
