/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.ui5.i18ns.uploader;

import uim.ui5;

import vibe.core.file : getFileInfo, readFile;

mixin(ShowModule!());

@safe:

/// Receives language files (*.json, *.properties, *.po, *.mo) and keeps one merged bundle per locale.
///
/// Bundles are held in memory only. The endpoint does no authentication of its own, see
/// I18nRouter.registerUploadRoute.
class I18nUploadHandler {
  this() {
    this.initialize();
  }

  this(string name, Json config = Json(null)) {
    this.initialize(config.set("name", name));
  }

  bool initialize(Json config = Json(null)) {
    return true;
  }

  // #region Properties
  // #region maxFileSize
  protected ulong _maxFileSize = 2 * 1024 * 1024;
  /// Largest accepted file in bytes. HTTPServerSettings.maxRequestSize limits the whole request as well.
  ulong maxFileSize() const {
    return _maxFileSize;
  }

  auto maxFileSize(ulong value) {
    _maxFileSize = value;
    return this;
  }
  // #endregion maxFileSize
  // #endregion Properties

  // #region Bundles
  protected I18nStore[string] _stores;

  /// The bundle of a locale (empty = default bundle), or null if nothing was uploaded for it
  I18nStore store(string locale = null) {
    auto found = locale in _stores;
    return found is null ? null : *found;
  }

  /// All locales with a bundle, sorted
  string[] locales() {
    return _stores.keys.sort.array;
  }

  /// Parses a language file and merges it into the bundle of its locale.
  /// Returns: the content of the file alone, not the merged bundle
  /// Throws: I18nParseException, in which case no bundle has changed
  I18nStore upload(string fileName, const(ubyte)[] content, string locale = null) {
    auto parsed = loadI18nFile(fileName, content, locale);
    addStore(parsed);
    return parsed;
  }

  protected void addStore(I18nStore parsed) {
    if (parsed.locale !in _stores) {
      _stores[parsed.locale] = new I18nStore(parsed.locale);
    }
    _stores[parsed.locale].merge(parsed);
  }
  // #endregion Bundles

  // #region handle
  /// Handles a multipart/form-data POST with one or more files and an optional "locale" field.
  ///
  /// A request is applied as a whole: if one file is rejected, none is stored.
  /// Answers with 200 and {"uploaded": [{"file", "format", "locale", "entries"}]}, or with
  /// {"error", "file"} and 400 (bad request or content), 413 (too large) or 415 (unknown file type).
  void handle(scope HTTPServerRequest req, scope HTTPServerResponse res) {
    string locale;
    const(FilePart)[] files;
    try {
      foreach (file; req.files.byValue) {
        files ~= file;
      }
      locale = req.form.get("locale", "");
    } catch (Exception e) {
      respondError(res, HTTPStatus.badRequest, "Invalid form data");
      return;
    }

    if (files.length == 0) {
      respondError(res, HTTPStatus.badRequest, "No file uploaded");
      return;
    }

    I18nStore[] parsed;
    auto uploaded = Json.emptyArray;
    foreach (file; files) {
      immutable fileName = file.filename.name;
      immutable fileFormat = detectI18nFormat(fileName);
      if (fileFormat == I18nFormat.unknown) {
        respondError(res, HTTPStatus.unsupportedMediaType, "Unsupported file type", fileName);
        return;
      }
      if (getFileInfo(file.tempPath).size > _maxFileSize) {
        respondError(res, HTTPStatus.requestEntityTooLarge, "File is too large", fileName);
        return;
      }

      I18nStore bundle;
      try {
        bundle = loadI18nFile(fileName, readFile(file.tempPath), locale);
      } catch (I18nParseException e) {
        respondError(res, HTTPStatus.badRequest, e.msg, fileName);
        return;
      }

      parsed ~= bundle;
      auto entry = Json.emptyObject;
      entry["file"] = fileName;
      entry["format"] = fileFormat.to!string;
      entry["locale"] = bundle.locale;
      entry["entries"] = bundle.length;
      uploaded ~= entry;
    }

    foreach (bundle; parsed) {
      addStore(bundle);
    }

    auto result = Json.emptyObject;
    result["uploaded"] = uploaded;
    res.writeJsonBody(result);
  }

  private void respondError(scope HTTPServerResponse res, HTTPStatus status, string message, string fileName = null) {
    auto result = Json.emptyObject;
    result["error"] = message;
    if (fileName.length > 0) {
      result["file"] = fileName;
    }
    res.writeJsonBody(result, status);
  }
  // #endregion handle
}

///
unittest {
  import std.exception : assertThrown;
  import std.string : representation;

  auto handler = new I18nUploadHandler;
  assert(handler.locales.length == 0);
  assert(handler.store("de") is null);

  auto first = handler.upload("i18n_de.properties", "a=1\nb=2\n".representation);
  assert(first.locale == "de" && first.length == 2);

  // Later files merge into the bundle of their locale, and replace equal keys
  auto second = handler.upload("de.json", `{"b":"3","c":"4"}`.representation);
  assert(second.length == 2);
  assert(handler.store("de").length == 3);
  assert(handler.store("de").get("b") == "3");

  handler.upload("texts.po", "msgid \"a\"\nmsgstr \"b\"\n".representation, "fr-CA");
  handler.upload("i18n.properties", "x=y\n".representation);
  assert(handler.locales == ["", "de", "fr_CA"]);
  assert(handler.store.get("x") == "y");

  // A rejected file leaves the bundles unchanged
  assertThrown!I18nParseException(handler.upload("de.json", `{"a":`.representation));
  assert(handler.store("de").get("a") == "1");
}
