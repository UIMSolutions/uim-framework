/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.http.status;

import uim.web;

mixin(ShowModule!());

@safe:

/// HTTP response status codes (RFC 9110)
enum HttpStatus {
  // 1xx informational
  Continue = 100,
  SwitchingProtocols = 101,
  Processing = 102,
  EarlyHints = 103,

  // 2xx success
  Ok = 200,
  Created = 201,
  Accepted = 202,
  NonAuthoritativeInformation = 203,
  NoContent = 204,
  ResetContent = 205,
  PartialContent = 206,
  MultiStatus = 207,
  AlreadyReported = 208,
  ImUsed = 226,

  // 3xx redirection
  MultipleChoices = 300,
  MovedPermanently = 301,
  Found = 302,
  SeeOther = 303,
  NotModified = 304,
  UseProxy = 305,
  TemporaryRedirect = 307,
  PermanentRedirect = 308,

  // 4xx client errors
  BadRequest = 400,
  Unauthorized = 401,
  PaymentRequired = 402,
  Forbidden = 403,
  NotFound = 404,
  MethodNotAllowed = 405,
  NotAcceptable = 406,
  ProxyAuthenticationRequired = 407,
  RequestTimeout = 408,
  Conflict = 409,
  Gone = 410,
  LengthRequired = 411,
  PreconditionFailed = 412,
  ContentTooLarge = 413,
  UriTooLong = 414,
  UnsupportedMediaType = 415,
  RangeNotSatisfiable = 416,
  ExpectationFailed = 417,
  ImATeapot = 418,
  MisdirectedRequest = 421,
  UnprocessableContent = 422,
  Locked = 423,
  FailedDependency = 424,
  TooEarly = 425,
  UpgradeRequired = 426,
  PreconditionRequired = 428,
  TooManyRequests = 429,
  RequestHeaderFieldsTooLarge = 431,
  UnavailableForLegalReasons = 451,

  // 5xx server errors
  InternalServerError = 500,
  NotImplemented = 501,
  BadGateway = 502,
  ServiceUnavailable = 503,
  GatewayTimeout = 504,
  HttpVersionNotSupported = 505,
  VariantAlsoNegotiates = 506,
  InsufficientStorage = 507,
  LoopDetected = 508,
  NotExtended = 510,
  NetworkAuthenticationRequired = 511
}

/// Reason phrase for a status code, e.g. reasonPhrase(HttpStatus.NotFound) -> "Not Found"
string reasonPhrase(HttpStatus status) {
  switch (status) {
    case HttpStatus.Continue: return "Continue";
    case HttpStatus.SwitchingProtocols: return "Switching Protocols";
    case HttpStatus.Processing: return "Processing";
    case HttpStatus.EarlyHints: return "Early Hints";
    case HttpStatus.Ok: return "OK";
    case HttpStatus.Created: return "Created";
    case HttpStatus.Accepted: return "Accepted";
    case HttpStatus.NonAuthoritativeInformation: return "Non-Authoritative Information";
    case HttpStatus.NoContent: return "No Content";
    case HttpStatus.ResetContent: return "Reset Content";
    case HttpStatus.PartialContent: return "Partial Content";
    case HttpStatus.MultiStatus: return "Multi-Status";
    case HttpStatus.AlreadyReported: return "Already Reported";
    case HttpStatus.ImUsed: return "IM Used";
    case HttpStatus.MultipleChoices: return "Multiple Choices";
    case HttpStatus.MovedPermanently: return "Moved Permanently";
    case HttpStatus.Found: return "Found";
    case HttpStatus.SeeOther: return "See Other";
    case HttpStatus.NotModified: return "Not Modified";
    case HttpStatus.UseProxy: return "Use Proxy";
    case HttpStatus.TemporaryRedirect: return "Temporary Redirect";
    case HttpStatus.PermanentRedirect: return "Permanent Redirect";
    case HttpStatus.BadRequest: return "Bad Request";
    case HttpStatus.Unauthorized: return "Unauthorized";
    case HttpStatus.PaymentRequired: return "Payment Required";
    case HttpStatus.Forbidden: return "Forbidden";
    case HttpStatus.NotFound: return "Not Found";
    case HttpStatus.MethodNotAllowed: return "Method Not Allowed";
    case HttpStatus.NotAcceptable: return "Not Acceptable";
    case HttpStatus.ProxyAuthenticationRequired: return "Proxy Authentication Required";
    case HttpStatus.RequestTimeout: return "Request Timeout";
    case HttpStatus.Conflict: return "Conflict";
    case HttpStatus.Gone: return "Gone";
    case HttpStatus.LengthRequired: return "Length Required";
    case HttpStatus.PreconditionFailed: return "Precondition Failed";
    case HttpStatus.ContentTooLarge: return "Content Too Large";
    case HttpStatus.UriTooLong: return "URI Too Long";
    case HttpStatus.UnsupportedMediaType: return "Unsupported Media Type";
    case HttpStatus.RangeNotSatisfiable: return "Range Not Satisfiable";
    case HttpStatus.ExpectationFailed: return "Expectation Failed";
    case HttpStatus.ImATeapot: return "I'm a teapot";
    case HttpStatus.MisdirectedRequest: return "Misdirected Request";
    case HttpStatus.UnprocessableContent: return "Unprocessable Content";
    case HttpStatus.Locked: return "Locked";
    case HttpStatus.FailedDependency: return "Failed Dependency";
    case HttpStatus.TooEarly: return "Too Early";
    case HttpStatus.UpgradeRequired: return "Upgrade Required";
    case HttpStatus.PreconditionRequired: return "Precondition Required";
    case HttpStatus.TooManyRequests: return "Too Many Requests";
    case HttpStatus.RequestHeaderFieldsTooLarge: return "Request Header Fields Too Large";
    case HttpStatus.UnavailableForLegalReasons: return "Unavailable For Legal Reasons";
    case HttpStatus.InternalServerError: return "Internal Server Error";
    case HttpStatus.NotImplemented: return "Not Implemented";
    case HttpStatus.BadGateway: return "Bad Gateway";
    case HttpStatus.ServiceUnavailable: return "Service Unavailable";
    case HttpStatus.GatewayTimeout: return "Gateway Timeout";
    case HttpStatus.HttpVersionNotSupported: return "HTTP Version Not Supported";
    case HttpStatus.VariantAlsoNegotiates: return "Variant Also Negotiates";
    case HttpStatus.InsufficientStorage: return "Insufficient Storage";
    case HttpStatus.LoopDetected: return "Loop Detected";
    case HttpStatus.NotExtended: return "Not Extended";
    case HttpStatus.NetworkAuthenticationRequired: return "Network Authentication Required";
    default: return "Unknown";
  }
}

/// Reason phrase for a numeric status code, e.g. reasonPhrase(404) -> "Not Found"
string reasonPhrase(int code) {
  return isHttpStatus(code)
    ? reasonPhrase(cast(HttpStatus)code)
    : "Unknown";
}

/// Checks whether a numeric code is a defined HTTP status
bool isHttpStatus(int code) {
  return [
    100, 101, 102, 103,
    200, 201, 202, 203, 204, 205, 206, 207, 208, 226,
    300, 301, 302, 303, 304, 305, 307, 308,
    400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 416,
    417, 418, 421, 422, 423, 424, 425, 426, 428, 429, 431, 451,
    500, 501, 502, 503, 504, 505, 506, 507, 508, 510, 511
  ].canFind(code);
}

/// 1xx informational status
bool isInformational(HttpStatus status) {
  return cast(int)status >= 100 && cast(int)status < 200;
}

/// 2xx success status
bool isSuccess(HttpStatus status) {
  return cast(int)status >= 200 && cast(int)status < 300;
}

/// 3xx redirection status
bool isRedirection(HttpStatus status) {
  return cast(int)status >= 300 && cast(int)status < 400;
}

/// 4xx client error status
bool isClientError(HttpStatus status) {
  return cast(int)status >= 400 && cast(int)status < 500;
}

/// 5xx server error status
bool isServerError(HttpStatus status) {
  return cast(int)status >= 500 && cast(int)status < 600;
}

/// Any error status (4xx or 5xx)
bool isError(HttpStatus status) {
  return isClientError(status) || isServerError(status);
}

/// Full status line, e.g. statusLine(HttpStatus.NotFound) -> "404 Not Found"
string statusLine(HttpStatus status) {
  return "%s %s".format(cast(int)status, reasonPhrase(status));
}

///
unittest {
  // numeric values
  assert(cast(int)HttpStatus.Ok == 200);
  assert(cast(int)HttpStatus.NotFound == 404);
  assert(cast(int)HttpStatus.InternalServerError == 500);

  // reason phrases
  assert(reasonPhrase(HttpStatus.Ok) == "OK");
  assert(reasonPhrase(HttpStatus.NotFound) == "Not Found");
  assert(reasonPhrase(HttpStatus.ImATeapot) == "I'm a teapot");
  assert(reasonPhrase(200) == "OK");
  assert(reasonPhrase(404) == "Not Found");
  assert(reasonPhrase(999) == "Unknown");

  // validity
  assert(isHttpStatus(200));
  assert(isHttpStatus(418));
  assert(!isHttpStatus(999));
  assert(!isHttpStatus(99));

  // categories
  assert(isInformational(HttpStatus.Continue));
  assert(!isInformational(HttpStatus.Ok));
  assert(isSuccess(HttpStatus.Ok));
  assert(isSuccess(HttpStatus.Created));
  assert(!isSuccess(HttpStatus.NotFound));
  assert(isRedirection(HttpStatus.MovedPermanently));
  assert(isRedirection(HttpStatus.TemporaryRedirect));
  assert(!isRedirection(HttpStatus.Ok));
  assert(isClientError(HttpStatus.NotFound));
  assert(isClientError(HttpStatus.TooManyRequests));
  assert(!isClientError(HttpStatus.InternalServerError));
  assert(isServerError(HttpStatus.InternalServerError));
  assert(isServerError(HttpStatus.BadGateway));
  assert(!isServerError(HttpStatus.NotFound));
  assert(isError(HttpStatus.NotFound));
  assert(isError(HttpStatus.ServiceUnavailable));
  assert(!isError(HttpStatus.Ok));

  // status line
  assert(statusLine(HttpStatus.Ok) == "200 OK");
  assert(statusLine(HttpStatus.NotFound) == "404 Not Found");
}
