/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.services.domain.enumerations;

import uim.services;

mixin(ShowModule!());

@safe:
/// SSO protocol.
enum SsoProtocol {
  saml,
  oidc,
}

SsoProtocol toSsoProtocol(string value) {
  mixin(EnumSwitch("SsoProtocol", "saml"));
}
SsoProtocol[] toSsoProtocol(string[] values) {
  return values.map!toSsoProtocol.array;
}

string toString(SsoProtocol protocol) {
  return protocol.to!string;
}
string[] toString(SsoProtocol[] protocols) {
  return protocols.map!toString.array;
}
/// 
unittest {
  assert(SsoProtocol.saml.to!string == "saml");
  assert(SsoProtocol.oidc.to!string == "oidc");

  assert("saml".to!SsoProtocol == SsoProtocol.saml);
  assert("oidc".to!SsoProtocol == SsoProtocol.oidc);

  assert("saml".toSsoProtocol == SsoProtocol.saml);
  assert("oidc".toSsoProtocol == SsoProtocol.oidc);
  assert("noexists".toSsoProtocol == SsoProtocol.saml); // Default case
  assert("".toSsoProtocol == SsoProtocol.saml); // Default case

  assert(toString(SsoProtocol.saml) == "saml");
  assert(toString(SsoProtocol.oidc) == "oidc");

  assert(["saml", "oidc"].toSsoProtocol == [SsoProtocol.saml, SsoProtocol.oidc]);
  assert([SsoProtocol.saml, SsoProtocol.oidc].toString == ["saml", "oidc"]);
}

/// Authentication method supported by the platform.
enum AuthMethod {
  form,
  spnego,
  social,
  certificate,
  saml,
  oidc,
  apiKey,
}

AuthMethod toAuthMethod(string value) {
  mixin(EnumSwitch("AuthMethod", "form"));
}
AuthMethod[] toAuthMethod(string[] values) {
  return values.map!(toAuthMethod).array;
}
string toString(AuthMethod method) {
  return method.to!string;
}
string[] toString(AuthMethod[] methods) {
  return methods.map!toString.array;
}
unittest {
  assert(AuthMethod.form.to!string == "form");
  assert(AuthMethod.spnego.to!string == "spnego");
  assert(AuthMethod.social.to!string == "social");
  assert(AuthMethod.certificate.to!string == "certificate");
  assert(AuthMethod.saml.to!string == "saml");
  assert(AuthMethod.oidc.to!string == "oidc");
  assert(AuthMethod.apiKey.to!string == "apiKey");

  assert("form".to!AuthMethod == AuthMethod.form);
  assert("spnego".to!AuthMethod == AuthMethod.spnego);
  assert("social".to!AuthMethod == AuthMethod.social);
  assert("certificate".to!AuthMethod == AuthMethod.certificate);
  assert("saml".to!AuthMethod == AuthMethod.saml);
  assert("oidc".to!AuthMethod == AuthMethod.oidc);
  assert("apiKey".to!AuthMethod == AuthMethod.apiKey);

  assert("form".toAuthMethod == AuthMethod.form);
  assert("spnego".toAuthMethod == AuthMethod.spnego);
  assert("social".toAuthMethod == AuthMethod.social);
  assert("certificate".toAuthMethod == AuthMethod.certificate);
  assert("saml".toAuthMethod == AuthMethod.saml);
  assert("oidc".toAuthMethod == AuthMethod.oidc);
  assert("apiKey".toAuthMethod == AuthMethod.apiKey);
  assert("noexists".toAuthMethod == AuthMethod.form); // Default case
  assert("".toAuthMethod == AuthMethod.form); // Default case

  assert(toString(AuthMethod.form) == "form");
  assert(toString(AuthMethod.spnego) == "spnego");
  assert(toString(AuthMethod.social) == "social");
  assert(toString(AuthMethod.certificate) == "certificate");
  assert(toString(AuthMethod.saml) == "saml");
  assert(toString(AuthMethod.oidc) == "oidc");
  assert(toString(AuthMethod.apiKey) == "apiKey");  

  assert(["form", "spnego", "social", "certificate", "saml", "oidc", "apiKey"].toAuthMethod == [AuthMethod.form, AuthMethod.spnego, AuthMethod.social, AuthMethod.certificate, AuthMethod.saml, AuthMethod.oidc, AuthMethod.apiKey]);
  assert([AuthMethod.form, AuthMethod.spnego, AuthMethod.social, AuthMethod.certificate, AuthMethod.saml, AuthMethod.oidc, AuthMethod.apiKey].toString == ["form", "spnego", "social", "certificate", "saml", "oidc", "apiKey"]);
}

enum PersistenceType {
  memory,
  sql,
  nosql,
  file,
}

PersistenceType toPersistenceType(string value) {
  mixin(EnumSwitch("PersistenceType", "memory"));
}
PersistenceType[] toPersistenceType(string[] values) {
  return values.map!(toPersistenceType).array;
}
string toString(PersistenceType type) {
  return type.to!string;
}
string[] toString(PersistenceType[] types) {
  return types.map!toString.array;
}
///
unittest {
  assert(PersistenceType.sql.to!string == "sql");
  assert(PersistenceType.nosql.to!string == "nosql");
  assert(PersistenceType.memory.to!string == "memory");
  assert(PersistenceType.file.to!string == "file");

  assert("sql".to!PersistenceType == PersistenceType.sql);
  assert("nosql".to!PersistenceType == PersistenceType.nosql);
  assert("memory".to!PersistenceType == PersistenceType.memory);
  assert("file".to!PersistenceType == PersistenceType.file);

  assert("sql".toPersistenceType == PersistenceType.sql);
  assert("nosql".toPersistenceType == PersistenceType.nosql);
  assert("memory".toPersistenceType == PersistenceType.memory);
  assert("file".toPersistenceType == PersistenceType.file);
  assert("noexists".toPersistenceType == PersistenceType.memory); // Default case
  assert("".toPersistenceType == PersistenceType.memory); // Default case

  assert(toString(PersistenceType.sql) == "sql");
  assert(toString(PersistenceType.nosql) == "nosql");
  assert(toString(PersistenceType.memory) == "memory");
  assert(toString(PersistenceType.file) == "file");

  assert(["sql", "nosql", "memory", "file"].toPersistenceType == [PersistenceType.sql, PersistenceType.nosql, PersistenceType.memory, PersistenceType.file]);
  assert([PersistenceType.sql, PersistenceType.nosql, PersistenceType.memory, PersistenceType.file].toString == ["sql", "nosql", "memory", "file"]);
}

// Alert severity
enum AlertSeverity {
  info,
  warning,
  error,
  critical,
  fatal
}

AlertSeverity toAlertSeverity(string value) {
  mixin(EnumSwitch("AlertSeverity", "info"));
}
AlertSeverity[] toAlertSeverities(string[] values) {
  return values.map!(toAlertSeverity).array;
}
string toString(AlertSeverity severity) {
  return severity.to!string;
}
string[] toString(AlertSeverity[] severities) {
  return severities.map!toString.array;
}
///
unittest {
  mixin(ShowTest!("AlertSeverity Enum"));

  assert(AlertSeverity.info.to!string == "info");
  assert(AlertSeverity.warning.to!string == "warning");
  assert(AlertSeverity.error.to!string == "error");
  assert(AlertSeverity.critical.to!string == "critical");
  assert(AlertSeverity.fatal.to!string == "fatal");

  assert("info".toAlertSeverity == AlertSeverity.info);
  assert("warning".toAlertSeverity == AlertSeverity.warning);
  assert("error".toAlertSeverity == AlertSeverity.error);
  assert("critical".toAlertSeverity == AlertSeverity.critical);
  assert("fatal".toAlertSeverity == AlertSeverity.fatal);

  assert("noexists".toAlertSeverity == AlertSeverity.info); // Default case
  assert("".toAlertSeverity == AlertSeverity.info); // Default case

  assert(["info", "warning", "error", "critical", "fatal"].toAlertSeverities == [AlertSeverity.info, AlertSeverity.warning, AlertSeverity.error, AlertSeverity.critical, AlertSeverity.fatal]);
  assert([AlertSeverity.info, AlertSeverity.warning, AlertSeverity.error, AlertSeverity.critical, AlertSeverity.fatal].toString == ["info", "warning", "error", "critical", "fatal"]);
}

// Log level
enum LoggingLevel : string {
  info = "info",
  debug_ = "debug",
  warning = "warning",
  error = "error",
  fatal = "fatal",
  trace = "trace"
}
LoggingLevel toLoggingLevel(string value) {
  switch (value.toLower()) {
    case "debug": return LoggingLevel.debug_;
    case "info": return LoggingLevel.info;
    case "warning": return LoggingLevel.warning;
    case "error": return LoggingLevel.error;
    case "fatal": return LoggingLevel.fatal;
    case "trace": return LoggingLevel.trace;
    default: return LoggingLevel.info; // default
  }
}

LoggingLevel[] toLoggingLevels(string[] values)
  => values.map!toLoggingLevel.array;

string toString(LoggingLevel level)
  => cast(string)level;

string[] toString(LoggingLevel[] levels)
  => levels.map!toString.array;
///
unittest {
  mixin(ShowTest!("LoggingLevel Enum"));

  assert(LoggingLevel.info.toString == "info");
  assert(LoggingLevel.debug_.toString == "debug");
  assert(LoggingLevel.warning.toString == "warning");
  assert(LoggingLevel.error.toString == "error");
  assert(LoggingLevel.fatal.toString == "fatal");
  assert(LoggingLevel.trace.toString == "trace");

  assert("info".toLoggingLevel == LoggingLevel.info);
  assert("debug".toLoggingLevel == LoggingLevel.debug_);
  assert("warning".toLoggingLevel == LoggingLevel.warning);
  assert("error".toLoggingLevel == LoggingLevel.error);
  assert("fatal".toLoggingLevel == LoggingLevel.fatal);
  assert("trace".toLoggingLevel == LoggingLevel.trace);

  assert("noexists".toLoggingLevel == LoggingLevel.info); // Default case
  assert("".toLoggingLevel == LoggingLevel.info); // Default case

  assert(["info", "debug", "warning", "error", "fatal", "trace"].toLoggingLevels == [LoggingLevel.info, LoggingLevel.debug_, LoggingLevel.warning, LoggingLevel.error, LoggingLevel.fatal, LoggingLevel.trace]);
  assert([LoggingLevel.info, LoggingLevel.debug_, LoggingLevel.warning, LoggingLevel.error, LoggingLevel.fatal, LoggingLevel.trace].toString == ["info", "debug", "warning", "error", "fatal", "trace"]);
}

/// HTTP method used during destination health checks or probing.
enum HttpMethod {
  get_ = "GET",
  post_ = "POST",
  put_ = "PUT",
  delete_ = "DELETE",
  patch_ = "PATCH",
  head_ = "HEAD",
  options_ = "OPTIONS",
}
HttpMethod toHttpMethod(string value) {
  switch (value.toLower()) {
    case "get": return HttpMethod.get_;
    case "post": return HttpMethod.post_;
    case "put": return HttpMethod.put_;
    case "delete": return HttpMethod.delete_;
    case "patch": return HttpMethod.patch_;
    case "head": return HttpMethod.head_;
    case "options": return HttpMethod.options_;
    default: return HttpMethod.get_; // default
  }
}
HttpMethod[] toHttpMethods(string[] values)
  => values.map!toHttpMethod.array;
string toString(HttpMethod method)
  => cast(string)method;
string[] toString(HttpMethod[] methods)
  => methods.map!toString.array;
///
unittest {
  mixin(ShowTest!("HttpMethod Enum"));    

  assert(HttpMethod.get_.toString == "GET");
  assert(HttpMethod.post_.toString == "POST");  
  assert(HttpMethod.put_.toString == "PUT");
  assert(HttpMethod.delete_.toString == "DELETE");
  assert(HttpMethod.patch_.toString == "PATCH");
  assert(HttpMethod.head_.toString == "HEAD");
  assert(HttpMethod.options_.toString == "OPTIONS");

  assert("get".toHttpMethod == HttpMethod.get_);
  assert("post".toHttpMethod == HttpMethod.post_);
  assert("put".toHttpMethod == HttpMethod.put_);
  assert("delete".toHttpMethod == HttpMethod.delete_);
  assert("patch".toHttpMethod == HttpMethod.patch_);
  assert("head".toHttpMethod == HttpMethod.head_);
  assert("options".toHttpMethod == HttpMethod.options_);

  assert(["get", "post", "put", "delete", "patch", "head", "options"].toHttpMethods == [HttpMethod.get_, HttpMethod.post_, HttpMethod.put_, HttpMethod.delete_, HttpMethod.patch_, HttpMethod.head_, HttpMethod.options_]);
  assert([HttpMethod.get_, HttpMethod.post_, HttpMethod.put_, HttpMethod.delete_, HttpMethod.patch_, HttpMethod.head_, HttpMethod.options_].toString == ["GET", "POST", "PUT", "DELETE", "PATCH", "HEAD", "OPTIONS"]);
}