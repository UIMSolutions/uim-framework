/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.classes.config;

import core.sync.mutex : Mutex;
import uim.service;

mixin(ShowModule!());

@safe:

/**
  * Base configuration class for SAP services.
  * Contains common configuration properties and initialization logic.
  * Specific services can extend this class to add their own configuration properties and validation.
  *
  * Example usage:
  * class MyServiceConfig : SAPConfig {
  *   string customProperty;
  *   override bool initialize(Json[string] initData = null) {
  *     if (!super.initialize(initData)) {
  *       return false;
  *     }
  *     customProperty = initData.getString("customProperty", "defaultValue");    
  *     return true;
  *   }
  * }
  */
class UIMConfig : IUIMConfig {
  this() {
    initialize();
  }

  this(Json[string] initData) {
    initialize(initData);
  }

  bool initialize(Json[string] initData = null) {
    if (initData.hasKey("serviceName") && initData.isString("serviceName")) {
      serviceName(initData.getString("serviceName"));
    }

    if (initData.hasKey("serviceVersion") && initData.isString("serviceVersion")) {
      serviceVersion(initData.getString("serviceVersion"));
    }

    if (initData.hasKey("host") && initData.isString("host")) {
      host(initData.getString("host"));
    }

    port(cast(ushort) initData.getInteger("port", 0));
    basePath(initData.getString("basePath", ""));

    requireAuthToken(initData.getBoolean("requireAuthToken", false));
    if (requireAuthToken) {
      authToken(initData.getString("authToken", ""));
    }

    if (initData.hasKey("customHeaders") && initData["customHeaders"].isObject) {
      Json[string] headers = initData["customHeaders"].toMap;
      string[string] custHeaders;
      foreach (key, value; headers) {
        custHeaders[key] = headers.getString(key);
      }
      customHeaders(custHeaders);
    }
    return true;
  }

  protected string _serviceName;
  string serviceName() const
  {
    return _serviceName;
  }

  void serviceName(string name) {
    _serviceName = name;
  }

  protected string _serviceVersion;
  string serviceVersion() const
  {
    return _serviceVersion;
  }

  void serviceVersion(string version_) {
    _serviceVersion = version_;
  }

  protected string _host;
  string host() const
  {
    return _host;
  }

  void host(string host_) {
    _host = host_;
  }

  protected ushort _port;
  ushort port() const
  {
    return _port;
  }

  void port(ushort port_) {
    _port = port_;
  }

  protected string _basePath;
  string basePath() const
  {
    return _basePath;
  }

  void basePath(string path) {
    _basePath = path;
  }

  // #region requireAuthToken 
  protected bool _requireAuthToken;
  bool requireAuthToken() const
  {
    return _requireAuthToken;
  }

  void requireAuthToken(bool required) {
    _requireAuthToken = required;
  }
  // #endregion requireAuthToken 

  // #region authToken
  /** 
   * Authentication token required for accessing the service when token authentication is enabled.
   * Can be set programmatically or via configuration initialization.
   * Should be kept secure and not exposed in logs or error messages.
   * Validation of the token should be implemented in the service logic, not in the configuration class
   *
   * Example usage:
  * config.requireAuthToken(true);
  * config.authToken("my-secure-token");
   */
  protected string _authToken;
  string authToken() const
  {
    return _authToken;
  }

  void authToken(string token) {
    _authToken = token;
  }
  // #endregion authToken

  // #region customHeaders
  /** 
  * Custom headers to be included in all requests made by the service.
  * Can be set programmatically or via configuration initialization.
  * Useful for adding service-specific headers or for passing additional metadata.
  * Should be a key-value pair where the key is the header name and the value is the header value.
  * 
  * Example: customHeaders["X-Custom-Header"] = "CustomValue";
  * These headers can then be included in the HTTP responses or requests as needed in the service implementation.
  * The configuration class does not enforce any specific headers, allowing flexibility for different services.
  */
  protected string[string] _customHeaders;
  string[string] customHeaders() {
    return _customHeaders.dup;
  }

  void customHeaders(string[string] value) {
    _customHeaders = value;
  }

  string customHeader(string key) const
  {
    return _customHeaders[key];
  }

  void customHeader(string key, string value) {
    _customHeaders[key] = value;
  }
  // #endregion customHeaders

  /**
  * Validates the configuration properties.
  * Should be overridden by derived classes to add specific validation logic.
  * Throws an exception if validation fails.
  */
  void validate() {
    if (serviceName.isEmpty) {
      throw new Exception("Service name cannot be empty");
    }

    if (serviceVersion.isEmpty) {
      throw new Exception("Service version cannot be empty");
    }

    if (host.isEmpty) {
      throw new Exception("Host cannot be empty");
    }

    if (port == 0) {
      throw new Exception("Port must be greater than zero");
    }

    if (basePath.isEmpty) {
      throw new Exception("Base path cannot be empty");
    }

    if (basePath.isEmpty || !basePath.startsWith("/")) {
      throw new Exception("Base path must start with '/'");
    }

    if (requireAuthToken && authToken.isEmpty) {
      throw new Exception("Auth token is required when token authentication is enabled");
    }

    // Additional validation can be added here as needed
  }
}
