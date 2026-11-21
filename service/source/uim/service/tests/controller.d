module uim.service.tests.controller;

import uim.service;

mixin(ShowModule!());

@safe:
/**
 * ControllerTestBase provides utility methods to facilitate unit testing of 
 * ManageController-based classes by mocking request objects.
 */
abstract class ControllerTestBase {
    /** 
     * Creates a mock HTTPServerRequest for testing.
     * 
     * Params:
     *   method = The HTTP method (e.g., "GET", "POST").
     *   url = The request URI.
     *   tenantId = The tenant identifier for context.
     *   data = The JSON payload for mutations.
     */
    protected HTTPServerRequest createMockRequest(string method = "GET", 
        string url = "/api/v1/application-vulnerability/test", 
        TenantId tenantId = "test-tenant", 
        Json data = Json.undefined
    ) {
        // Using vibe.d's testing utility to create a request without a server.
        auto req = createTestHTTPServerRequest(vibe.inet.url.URL(url));
        req.method = httpMethodFromString(method);
        req.headers["X-Tenant-Id"] = tenantId.value;
        
        if (data.type != Json.Type.undefined) {
            req.json = data;
            req.contentType = "application/json";
        }
        
        return req;
    }

    /** 
     * Verifies that the response matches a successful operation.
     */
    protected void assertSuccess(Json response, int expectedCode = 200, string expectedMessage = null) {
        assert(response["status"].get!int == expectedCode, "Expected status code " ~ expectedCode.to!string);
        if (expectedMessage) {
            assert(response["message"].get!string == expectedMessage, "Message mismatch");
        }
        assert(response["data"].type != Json.Type.undefined, "Success response should contain data");
    }

    /** 
     * Verifies that the response matches an expected error.
     */
    protected void assertError(Json response, int expectedCode, string expectedMessage = null) {
        assert(response["status"].get!int == expectedCode, "Expected error status code " ~ expectedCode.to!string);
        if (expectedMessage) {
            assert(response["message"].get!string == expectedMessage, "Error message mismatch");
        }
    }
}
