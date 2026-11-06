/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.i18n.connectors.http;

import uim.i18n;

import core.time : Duration, seconds;
import std.array : replace;
import std.string : format, indexOf;

import vibe.http.client : HTTPClientRequest, HTTPClientResponse, HTTPClientSettings, requestHTTP;
import vibe.stream.operations : readAll;

mixin(ShowModule!());

@safe:

/// What a transport received
struct I18nHttpResponse {
  int status;
  string contentType;
  const(ubyte)[] content;
}

/// Performs a GET request. Exchange it to use another HTTP client, or for tests.
alias I18nHttpTransport = I18nHttpResponse delegate(string url, const string[string] headers) @safe;

/// Reads translations from a system with an HTTP interface.
///
/// The system must offer one document for each locale, in one of the formats of this library:
/// ---
/// auto connector = new I18nHttpConnector("tms", "https://tms.example.com/api/{tag}/messages.po")
///   .bearerToken(token)
///   .locales(["de", "fr"]);
/// manager.sync(connector);
/// ---
///
/// Redirects are not followed, as they would hand the credentials to another host. Headers are
/// sent as given, so use https for anything but a local system. Exceptions of this class do not
/// repeat the URL, which may hold a credential.
class I18nHttpConnector : I18nConnector {
  this() {
    this.initialize();
  }

  /// Params:
  ///   name = a name for messages
  ///   urlTemplate = the URL of a locale, see urlTemplate
  this(string name, string urlTemplate) {
    this.initialize();
    _name = name;
    _urlTemplate = urlTemplate;
  }

  this(string name, Json config) {
    this.initialize(config.set("name", name));
  }

  /// Reads "name", "urlTemplate", "localesUrl" and "jsonRoot" from the configuration
  bool initialize(Json config = Json(null)) {
    _name = config.getString("name", "http");
    _urlTemplate = config.getString("urlTemplate", "");
    _localesUrl = config.getString("localesUrl", "");
    _jsonRoot = config.getString("jsonRoot", "");
    _transport = &requestWithVibe;
    return true;
  }

  // #region Properties
  // #region name
  protected string _name;
  string name() {
    return _name;
  }
  // #endregion name

  // #region urlTemplate
  protected string _urlTemplate;
  /// The URL of a locale, with the placeholders {locale} ("de_AT"), {tag} ("de-AT") and {language} ("de")
  string urlTemplate() const {
    return _urlTemplate;
  }

  auto urlTemplate(string value) {
    _urlTemplate = value;
    return this;
  }
  // #endregion urlTemplate

  // #region localesUrl
  protected string _localesUrl;
  /// The URL of a JSON document that lists the locales, as an array or as the keys of an object.
  /// Not needed if locales are set.
  string localesUrl() const {
    return _localesUrl;
  }

  auto localesUrl(string value) {
    _localesUrl = value;
    return this;
  }
  // #endregion localesUrl

  // #region locales
  protected string[] _locales;
  /// The locales of the system. Without fixed locales, this reads them from localesUrl.
  /// Throws: I18nConnectorException if the list cannot be read
  string[] locales() {
    if (_locales.length > 0) {
      return _locales.dup;
    }
    if (_localesUrl.length == 0) {
      throw new I18nConnectorException("%s: Neither locales nor a locales URL are set".format(_name));
    }

    auto response = request(_localesUrl, "the list of locales");
    try {
      return parseJsonLocales(response.content);
    } catch (I18nParseException e) {
      throw new I18nConnectorException("%s: Invalid list of locales: %s".format(_name, e.msg));
    }
  }

  /// Sets fixed locales (fluent interface)
  I18nHttpConnector locales(const string[] values) {
    _locales = values.dup;
    return this;
  }
  // #endregion locales

  // #region format
  protected I18nFormat _format = I18nFormat.unknown;
  /// The format of the documents. If unknown, it follows from the extension of the URL, then from the Content-Type.
  I18nFormat format() const {
    return _format;
  }

  auto format(I18nFormat value) {
    _format = value;
    return this;
  }
  // #endregion format

  // #region jsonRoot
  protected string _jsonRoot;
  /// Dotted path of the object that holds the messages in a JSON document, e.g. "data.messages"
  string jsonRoot() const {
    return _jsonRoot;
  }

  auto jsonRoot(string value) {
    _jsonRoot = value;
    return this;
  }
  // #endregion jsonRoot

  // #region headers
  protected string[string] _headers;
  /// Sets a header of all requests (fluent interface)
  auto header(string name, string value) {
    _headers[name] = value;
    return this;
  }

  /// Sets the Authorization header for a bearer token (fluent interface)
  auto bearerToken(string token) {
    return header("Authorization", "Bearer " ~ token);
  }
  // #endregion headers

  // #region timeout
  protected Duration _timeout = 30.seconds;
  /// Limit for connecting and for each read
  Duration timeout() const {
    return _timeout;
  }

  auto timeout(Duration value) {
    _timeout = value;
    return this;
  }
  // #endregion timeout

  // #region maxResponseSize
  protected size_t _maxResponseSize = 16 * 1024 * 1024;
  /// Largest accepted document in bytes, after decompression
  size_t maxResponseSize() const {
    return _maxResponseSize;
  }

  auto maxResponseSize(size_t value) {
    _maxResponseSize = value;
    return this;
  }
  // #endregion maxResponseSize

  // #region transport
  protected I18nHttpTransport _transport;
  auto transport(I18nHttpTransport value) {
    _transport = value;
    return this;
  }
  // #endregion transport
  // #endregion Properties

  /// Reads all messages of a locale
  /// Throws: I18nConnectorException if the system fails, I18nParseException for bad content
  I18nCatalog fetch(string locale) {
    // Normalized locales only hold letters, digits and "_", so nothing can break out of the URL
    auto normalized = normalizeLocale(locale);
    if (normalized.length == 0) {
      throw new I18nConnectorException("%s: Invalid locale '%s'".format(_name, locale));
    }
    if (_urlTemplate.length == 0) {
      throw new I18nConnectorException("%s: No URL template is set".format(_name));
    }

    immutable url = _urlTemplate
      .replace("{locale}", normalized)
      .replace("{tag}", localeTag(normalized))
      .replace("{language}", localeLanguage(normalized));

    auto response = request(url, "locale " ~ normalized);
    auto documentFormat = formatOf(url, response.contentType);
    if (documentFormat == I18nFormat.unknown) {
      throw new I18nConnectorException("%s: Unknown format '%s' for locale %s"
          .format(_name, response.contentType, normalized));
    }

    return documentFormat == I18nFormat.json
      ? parseJsonCatalog(response.content, normalized, _jsonRoot)
      : parseCatalog(documentFormat, response.content, normalized);
  }

  private I18nFormat formatOf(string url, string contentType) const {
    if (_format != I18nFormat.unknown) {
      return _format;
    }

    auto path = url;
    foreach (i, c; url) {
      if (c == '?' || c == '#') {
        path = url[0 .. i];
        break;
      }
    }
    auto byName = detectI18nFormat(path);
    return byName != I18nFormat.unknown ? byName : detectI18nContentType(contentType);
  }

  private I18nHttpResponse request(string url, string subject) {
    I18nHttpResponse response;
    try {
      response = _transport(url, _headers);
    } catch (Exception e) {
      // vibe.d repeats the URL in some messages, for example if it cannot parse it
      throw new I18nConnectorException("%s: Request for %s failed: %s"
          .format(_name, subject, e.msg.replace(url, "<url>")));
    }
    if (response.status != 200) {
      throw new I18nConnectorException("%s: Request for %s returned HTTP %d".format(_name, subject, response.status));
    }
    if (response.content.length > _maxResponseSize) {
      throw new I18nConnectorException("%s: Response for %s is too large".format(_name, subject));
    }
    return response;
  }

  private I18nHttpResponse requestWithVibe(string url, const string[string] headers) {
    auto settings = new HTTPClientSettings;
    settings.connectTimeout = _timeout;
    settings.readTimeout = _timeout;

    I18nHttpResponse result;
    requestHTTP(url, (scope HTTPClientRequest req) {
      foreach (name, value; headers) {
        req.headers[name] = value;
      }
    }, (scope HTTPClientResponse res) {
      result.status = res.statusCode;
      result.contentType = res.contentType;
      if (res.statusCode == 200) {
        // The limit also holds for compressed bodies, where Content-Length says little
        result.content = res.bodyReader.readAll(_maxResponseSize);
      } else {
        res.dropBody();
      }
    }, settings);
    return result;
  }
}

version (unittest) {
  import std.algorithm.searching : canFind;
  import std.exception : assertThrown, collectException;
  import std.string : representation;

  /// A system with fixed answers, which records its requests
  private class FakeSystem {
    I18nHttpResponse[string] answers;
    string[] urls;
    string[string] headers;

    I18nHttpResponse get(string url, const string[string] requestHeaders) {
      urls ~= url;
      foreach (name, value; requestHeaders) {
        headers[name] = value;
      }
      if (auto answer = url in answers) {
        return *answer;
      }
      return I18nHttpResponse(404);
    }

    I18nHttpConnector connector(string urlTemplate) {
      return new I18nHttpConnector("tms", urlTemplate).transport(&get);
    }
  }
}

/// Reading translations
unittest {
  auto system = new FakeSystem;
  system.answers["https://tms/api/de-AT/de_AT/de.po"] = I18nHttpResponse(200, "text/plain",
    "msgid \"a\"\nmsgstr \"b\"\n".representation);

  auto connector = system.connector("https://tms/api/{tag}/{locale}/{language}.po").bearerToken("secret");
  auto catalog = connector.fetch("de-at");
  assert(catalog.locale == "de_AT");
  assert(catalog.get("a") == "b");
  assert(system.headers["Authorization"] == "Bearer secret");
}

/// The format follows from configuration, URL and Content-Type, in this order
unittest {
  auto system = new FakeSystem;
  auto po = "msgid \"a\"\nmsgstr \"b\"\n".representation;
  auto json = `{"a": "b"}`.representation;

  system.answers["https://tms/de.po?token=1#x"] = I18nHttpResponse(200, "application/json", po);
  assert(system.connector("https://tms/{language}.po?token=1#x").fetch("de").get("a") == "b");

  system.answers["https://tms/de/file"] = I18nHttpResponse(200, "text/x-gettext-translation; charset=utf-8", po);
  assert(system.connector("https://tms/{language}/file").fetch("de").get("a") == "b");

  system.answers["https://tms/de/raw"] = I18nHttpResponse(200, "text/plain", json);
  assert(system.connector("https://tms/{language}/raw").format(I18nFormat.json).fetch("de").get("a") == "b");

  // Nothing tells the format
  assertThrown!I18nConnectorException(system.connector("https://tms/{language}/raw").fetch("de"));
}

/// Wrapped JSON
unittest {
  auto system = new FakeSystem;
  system.answers["https://tms/de.json"] = I18nHttpResponse(200, "application/json",
    `{"status": "ok", "data": {"a": "b"}}`.representation);

  assert(system.connector("https://tms/{language}.json").jsonRoot("data").fetch("de").length == 1);
  assert(system.connector("https://tms/{language}.json").fetch("de").get("data.a") == "b");
}

/// Listing locales
unittest {
  auto system = new FakeSystem;
  system.answers["https://tms/locales"] = I18nHttpResponse(200, "application/json", `["de-AT", "fr"]`.representation);

  auto connector = system.connector("https://tms/{tag}.json").localesUrl("https://tms/locales");
  assert(connector.locales == ["de_AT", "fr"]);
  assert(connector.locales(["es"]).locales == ["es"]); // Fixed locales need no request
  assert(system.urls.length == 1);

  assertThrown!I18nConnectorException(system.connector("https://tms/{tag}.json").locales());
  assertThrown!I18nConnectorException(system.connector("x").localesUrl("https://tms/missing").locales());

  system.answers["https://tms/bad"] = I18nHttpResponse(200, "application/json", `<html>`.representation);
  assertThrown!I18nConnectorException(system.connector("x").localesUrl("https://tms/bad").locales());
}

/// Failures
unittest {
  auto system = new FakeSystem;
  auto connector = system.connector("https://user:secret@tms/{language}.po");

  // Nothing can leave the URL through the locale
  foreach (bad; ["../../admin", "de/../x", "de?x=1", "de#x", "de%2F", ""]) {
    assertThrown!I18nConnectorException(connector.fetch(bad), bad);
  }
  assert(system.urls.length == 0);

  // Errors do not leak the URL, which may hold credentials
  auto e = collectException!I18nConnectorException(connector.fetch("de"));
  assert(e !is null && e.msg.canFind("HTTP 404") && !e.msg.canFind("secret"));

  // Redirects are errors
  system.answers["https://tms/de.po"] = I18nHttpResponse(302);
  assertThrown!I18nConnectorException(system.connector("https://tms/{language}.po").fetch("de"));

  // Exceptions of the transport are translated
  I18nHttpResponse broken(string url, const string[string] headers) {
    throw new Exception("connection refused");
  }

  e = collectException!I18nConnectorException(new I18nHttpConnector("x", "https://tms/{language}.po")
      .transport(&broken).fetch("de"));
  assert(e !is null && e.msg.canFind("connection refused"));

  I18nHttpResponse talkative(string url, const string[string] headers) {
    throw new Exception("Cannot parse " ~ url);
  }

  e = collectException!I18nConnectorException(new I18nHttpConnector("x", "https://tms/{language}.po?token=secret")
      .transport(&talkative).fetch("de"));
  assert(e !is null && e.msg.canFind("Cannot parse <url>") && !e.msg.canFind("secret"));

  // The size limit also holds for other transports
  system.answers["https://tms/de.po"] = I18nHttpResponse(200, "", "msgid \"a\"\nmsgstr \"b\"\n".representation);
  assertThrown!I18nConnectorException(system.connector("https://tms/{language}.po").maxResponseSize(5).fetch("de"));

  // Bad content is a parse error, and no URL template a configuration error
  system.answers["https://tms/de.mo"] = I18nHttpResponse(200, "", "nonsense".representation);
  assertThrown!I18nParseException(system.connector("https://tms/{language}.mo").fetch("de"));
  assertThrown!I18nConnectorException(new I18nHttpConnector().fetch("de"));
}

/// Configuration, and working with the manager
unittest {
  auto system = new FakeSystem;
  system.answers["https://tms/de.json"] = I18nHttpResponse(200, "", `{"data": {"a": "b"}}`.representation);
  system.answers["https://tms/locales"] = I18nHttpResponse(200, "", `["de", "fr"]`.representation);

  auto config = Json.emptyObject
    .set("urlTemplate", "https://tms/{language}.json")
    .set("localesUrl", "https://tms/locales")
    .set("jsonRoot", "data");
  auto connector = new I18nHttpConnector("tms", config).transport(&system.get);
  assert(connector.name == "tms");

  auto manager = new I18nManager;
  auto results = manager.sync(connector);
  assert(results.length == 2);
  assert(results[0] == I18nSyncResult("de", 1));
  assert(!results[1].ok && results[1].error.canFind("HTTP 404"));
  assert(manager.translate("a", "de") == "b");
  assert(!manager.hasLanguage("fr"));
}
