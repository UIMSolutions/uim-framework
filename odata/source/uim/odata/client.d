/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.odata.client;

import uim.odata.exceptions;
import uim.odata.query;
import uim.odata.entity;
import std.json;
import std.conv;
import std.net.curl;
import std.string;

@safe:

/**
 * ODataClient - HTTP client for OData services
 * 
 * Provides methods for querying and manipulating OData entities
 * through RESTful HTTP requests.
 */
class ODataClient {
    private string _serviceRoot;
    private string[string] _headers;
    private int _timeout = 30;

    /**
     * Constructor
     * 
     * Params:
     *   serviceRoot = The base URL of the OData service (e.g., "https://api.example.com/odata/")
     */
    this(string serviceRoot) {
        if (!serviceRoot.endsWith("/")) {
            serviceRoot ~= "/";
        }
        _serviceRoot = serviceRoot;
        
        // Default headers
        _headers["Accept"] = "application/json";
        _headers["Content-Type"] = "application/json";
        _headers["OData-Version"] = "4.0";
    }

    /**
     * Sets a custom header
     */
    void setHeader(string name, string value) {
        _headers[name] = value;
    }

    /**
     * Sets the request timeout in seconds
     */
    void setTimeout(int seconds) {
        _timeout = seconds;
    }

    /**
     * Creates a query builder for an entity set
     * 
     * Params:
     *   entitySet = The entity set name
     * 
     * Returns: A query builder for constructing queries
     */
    ODataQueryBuilder query(string entitySet) {
        return new ODataQueryBuilder(entitySet);
    }

    /**
     * Executes a query and returns the response
     * 
     * Params:
     *   query = The query builder
     * 
     * Returns: JSON response as string
     */
    string execute(ODataQueryBuilder query) {
        string url = _serviceRoot ~ query.build();
        return performGet(url);
    }

    /**
     * Gets a single entity by key
     * 
     * Params:
     *   entitySet = The entity set name
     *   key = The entity key
     * 
     * Returns: The entity as ODataEntity
     */
    ODataEntity get(string entitySet, string key) {
        string url = _serviceRoot ~ entitySet ~ "(" ~ key ~ ")";
        string response = performGet(url);
        
        auto json = parseJSON(response);
        return ODataEntity.fromJSONValue(entitySet, json);
    }

    /**
     * Creates a new entity
     * 
     * Params:
     *   entitySet = The entity set name
     *   entity = The entity to create
     * 
     * Returns: The created entity with server-generated values
     */
    ODataEntity create(string entitySet, ODataEntity entity) {
        string url = _serviceRoot ~ entitySet;
        string data = entity.toJSON();
        string response = performPost(url, data);
        
        auto json = parseJSON(response);
        return ODataEntity.fromJSONValue(entitySet, json);
    }

    /**
     * Creates a new entity from JSON data
     */
    string create(string entitySet, string jsonData) {
        string url = _serviceRoot ~ entitySet;
        return performPost(url, jsonData);
    }

    /**
     * Updates an existing entity
     * 
     * Params:
     *   entitySet = The entity set name
     *   key = The entity key
     *   entity = The entity with updated values
     * 
     * Returns: The updated entity
     */
    ODataEntity update(string entitySet, string key, ODataEntity entity) {
        string url = _serviceRoot ~ entitySet ~ "(" ~ key ~ ")";
        string data = entity.toJSON();
        string response = performPatch(url, data);
        
        if (response.length == 0) {
            return entity; // No content response
        }
        
        auto json = parseJSON(response);
        return ODataEntity.fromJSONValue(entitySet, json);
    }

    /**
     * Updates an entity from JSON data
     */
    string update(string entitySet, string key, string jsonData) {
        string url = _serviceRoot ~ entitySet ~ "(" ~ key ~ ")";
        return performPatch(url, jsonData);
    }

    /**
     * Deletes an entity
     * 
     * Params:
     *   entitySet = The entity set name
     *   key = The entity key
     */
    void delete_(string entitySet, string key) {
        string url = _serviceRoot ~ entitySet ~ "(" ~ key ~ ")";
        performDelete(url);
    }

    /**
     * Gets the service metadata document
     * 
     * Returns: The metadata XML as string
     */
    string getMetadata() {
        string url = _serviceRoot ~ "$metadata";
        return performGet(url);
    }

    /**
     * Gets the service document
     * 
     * Returns: The service document JSON
     */
    string getServiceDocument() {
        return performGet(_serviceRoot);
    }

    // HTTP operations (to be implemented with actual HTTP client)
    
    private string performGet(string url) @trusted {
        try {
            auto http = HTTP(url);
            foreach (key, value; _headers) {
                http.addRequestHeader(key, value);
            }
            http.dataTimeout = _timeout.seconds;
            
            char[] content;
            http.onReceive = (ubyte[] data) {
                content ~= cast(char[])data;
                return data.length;
            };
            
            http.perform();
            
            auto statusCode = http.statusLine.code;
            if (statusCode >= 400) {
                throw new ODataHTTPException("HTTP request failed", statusCode);
            }
            
            return content.idup;
        } catch (CurlException e) {
            throw new ODataHTTPException("HTTP error: " ~ e.msg);
        }
    }

    private string performPost(string url, string data) @trusted {
        try {
            auto http = HTTP(url);
            foreach (key, value; _headers) {
                http.addRequestHeader(key, value);
            }
            http.dataTimeout = _timeout.seconds;
            
            char[] content;
            http.onReceive = (ubyte[] responseData) {
                content ~= cast(char[])responseData;
                return responseData.length;
            };
            
            http.postData = data;
            http.method = HTTP.Method.post;
            http.perform();
            
            auto statusCode = http.statusLine.code;
            if (statusCode >= 400) {
                throw new ODataHTTPException("HTTP POST failed", statusCode);
            }
            
            return content.idup;
        } catch (CurlException e) {
            throw new ODataHTTPException("HTTP POST error: " ~ e.msg);
        }
    }

    private string performPatch(string url, string data) @trusted {
        try {
            auto http = HTTP(url);
            foreach (key, value; _headers) {
                http.addRequestHeader(key, value);
            }
            http.dataTimeout = _timeout.seconds;
            
            char[] content;
            http.onReceive = (ubyte[] responseData) {
                content ~= cast(char[])responseData;
                return responseData.length;
            };
            
            http.postData = data;
            http.method = HTTP.Method.patch;
            http.perform();
            
            auto statusCode = http.statusLine.code;
            if (statusCode >= 400) {
                throw new ODataHTTPException("HTTP PATCH failed", statusCode);
            }
            
            return content.idup;
        } catch (CurlException e) {
            throw new ODataHTTPException("HTTP PATCH error: " ~ e.msg);
        }
    }

    private void performDelete(string url) @trusted {
        try {
            auto http = HTTP(url);
            foreach (key, value; _headers) {
                http.addRequestHeader(key, value);
            }
            http.dataTimeout = _timeout.seconds;
            http.method = HTTP.Method.del;
            http.perform();
            
            auto statusCode = http.statusLine.code;
            if (statusCode >= 400) {
                throw new ODataHTTPException("HTTP DELETE failed", statusCode);
            }
        } catch (CurlException e) {
            throw new ODataHTTPException("HTTP DELETE error: " ~ e.msg);
        }
    }
}

// Unit tests
unittest {
    // Basic client creation
    auto client = new ODataClient("https://api.example.com/odata/");
    assert(client !is null);
}

unittest {
    // Query builder
    auto client = new ODataClient("https://api.example.com/odata/");
    auto query = client.query("Products");
    query.filter("Price gt 20").top(10);
    
    auto url = query.build();
    assert(url.startsWith("Products?"));
}
