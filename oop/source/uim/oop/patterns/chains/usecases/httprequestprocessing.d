module uim.oop.patterns.chains.usecases.httprequestprocessing;

import uim.oop;
@safe:
// Real-world example: HTTP Request Processing

/**
 * Authentication handler.
 */
class AuthenticationHandler : ConditionalHandler {
    private string _validToken = "valid-token-123";
    
    override bool shouldHandle(string request) {
        return request.indexOf("auth:") >= 0;
    }
    
    protected override string doHandle(string request) {
        auto authIdx = request.indexOf("auth:");
        if (authIdx >= 0) {
            auto tokenStart = authIdx + 5;
            auto spaceIdx = request.indexOf(" ", tokenStart);
            string token;
            if (spaceIdx > tokenStart) {
                token = request[tokenStart..spaceIdx];
            } else {
                token = request[tokenStart..$];
            }
            if (token == _validToken) {
                return "Authenticated";
            }
        }
        return "Authentication failed";
    }
}

/**
 * Authorization handler.
 */
class AuthorizationHandler : ConditionalHandler {
    override bool shouldHandle(string request) {
        return request.indexOf("role:") >= 0;
    }
    
    protected override string doHandle(string request) {
        auto roleStart = request.indexOf("role:") + 5;
        if (roleStart + 5 <= request.length) {
            auto role = request[roleStart..roleStart+5];
            if (role == "admin") {
                return "Authorized";
            }
        }
        return "Authorization failed";
    }
}

/**
 * Request validation handler.
 */
class ValidationHandler : ConditionalHandler {
    override bool shouldHandle(string request) {
        return request.indexOf("validate:") >= 0;
    }
    
    protected override string doHandle(string request) {
        if (request.length > 20) {
            return "Validated";
        }
        return "Validation failed";
    }
}

/**
 * Request processing handler.
 */
class ProcessingHandler : BaseHandler {
    override string handle(string request) {
        // This handler always processes if reached
        return "Processed: " ~ request;
    }
}

unittest {
    // Test HTTP request chain
    auto auth = new AuthenticationHandler();
    auto authz = new AuthorizationHandler();
    auto validation = new ValidationHandler();
    auto processing = new ProcessingHandler();
    
    auth.setNext(authz);
    authz.setNext(validation);
    validation.setNext(processing);
    
    auto result = auth.handle("auth:valid-token-123");
    assert(result == "Authenticated");
}