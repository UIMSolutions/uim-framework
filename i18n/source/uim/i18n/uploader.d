/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.i18n.uploader;

import uim.i18n;

import std.conv : to;
import std.string : format;

import vibe.core.file : getFileInfo, readFile;

mixin(ShowModule!());

@safe:

/// Why an upload was rejected
enum I18nUploadProblem {
  /// The content or the locale is invalid
  invalid,
  /// The file is larger than allowed
  tooLarge,
  /// The file is no supported language file
  unsupported
}

/// Thrown when an upload is rejected. No language has changed in this case.
class I18nUploadException : I18nException {
  this(I18nUploadProblem problem, string fileName, string message,
    string file = __FILE__, size_t line = __LINE__) {
    super(message, file, line);
    this.problem = problem;
    this.fileName = fileName;
  }

  I18nUploadProblem problem;
  /// The file that was rejected
  string fileName;
}

/// A language file to upload
struct I18nUploadFile {
  /// The name, whose extension tells the format
  string name;
  const(ubyte)[] content;
}

/// What an uploaded file contained
struct I18nUploadResult {
  string file;
  I18nFormat format;
  /// The language that received the messages
  string locale;
  /// Number of messages in the file
  size_t messages;
}

/// Adds uploaded language files (*.properties, *.po, *.mo, *.json) to the languages of a manager.
///
/// The locale of a file comes from the request, its header or its name, see loadCatalog. A file
/// that names no locale goes to the default locale of the manager.
class I18nUploader {
  this(I18nManager manager) {
    _manager = manager;
    this.initialize();
  }

  this(I18nManager manager, string name, Json config = Json(null)) {
    _manager = manager;
    this.initialize(config.set("name", name));
  }

  /// Reads "maxFileSize" from the configuration
  bool initialize(Json config = Json(null)) {
    _maxFileSize = config.getInteger("maxFileSize", 2 * 1024 * 1024);
    return true;
  }

  protected I18nManager _manager;

  // #region Properties
  // #region maxFileSize
  protected ulong _maxFileSize;
  /// Largest accepted file in bytes. HTTPServerSettings.maxRequestSize limits the whole request as well.
  ulong maxFileSize() const {
    return _maxFileSize;
  }

  auto maxFileSize(ulong value) {
    _maxFileSize = value;
    return this;
  }
  // #endregion maxFileSize

  // #region mergeMode
  protected I18nMergeMode _mergeMode = I18nMergeMode.overwrite;
  /// How uploaded messages are combined with the existing messages of a language
  I18nMergeMode mergeMode() const {
    return _mergeMode;
  }

  auto mergeMode(I18nMergeMode value) {
    _mergeMode = value;
    return this;
  }
  // #endregion mergeMode
  // #endregion Properties

  // #region upload
  /// Uploads one language file.
  /// Throws: I18nUploadException, in which case no language has changed
  I18nUploadResult upload(string fileName, const(ubyte)[] content, string locale = null) {
    return upload([I18nUploadFile(fileName, content)], locale)[0];
  }

  /// Uploads several language files as a whole: if one is rejected, none is applied.
  ///
  /// Files for the same locale count as one upload, in the given order. So in the
  /// mode replace, they replace the language together and not one after the other.
  ///
  /// Throws: I18nUploadException, in which case no language has changed
  I18nUploadResult[] upload(const I18nUploadFile[] files, string locale = null) {
    I18nCatalog[string] staged;
    string[] order;
    I18nUploadResult[] results;

    foreach (file; files) {
      check(file.name, file.content.length);

      I18nCatalog parsed;
      try {
        parsed = loadCatalog(file.name, file.content, locale);
      } catch (I18nParseException e) {
        throw new I18nUploadException(I18nUploadProblem.invalid, file.name, e.msg);
      }

      immutable target = parsed.locale.length > 0 ? parsed.locale : _manager.defaultLocale;
      if (target !in staged) {
        staged[target] = new I18nCatalog(target);
        order ~= target;
      }
      staged[target].merge(parsed);
      results ~= I18nUploadResult(file.name, detectI18nFormat(file.name), target, parsed.length);
    }

    foreach (target; order) {
      _manager.add(staged[target], _mergeMode);
    }
    return results;
  }

  /// Checks what is known before a file is read
  private void check(string fileName, ulong size) {
    if (detectI18nFormat(fileName) == I18nFormat.unknown) {
      throw new I18nUploadException(I18nUploadProblem.unsupported, fileName, "Unsupported file type");
    }
    if (size > _maxFileSize) {
      throw new I18nUploadException(I18nUploadProblem.tooLarge, fileName, "File is too large");
    }
  }
  // #endregion upload

  // #region HTTP
  /// Adds POST basePath/upload.
  ///
  /// This route changes server state and has no authentication of its own: put an
  /// authentication handler in front of it on the URLRouter.
  void registerRoute(URLRouter router, string basePath = "/i18n") {
    router.post(basePath ~ "/upload", &handle);
  }

  /// Handles a multipart/form-data POST with one or more files and an optional "locale" field.
  ///
  /// Answers with 200 and {"uploaded": [{"file", "format", "locale", "messages"}]}, or with
  /// {"error", "file"} and 400 (bad request or content), 413 (too large) or 415 (unknown file type).
  void handle(scope HTTPServerRequest req, scope HTTPServerResponse res) {
    string locale;
    const(FilePart)[] parts;
    try {
      foreach (part; req.files.byValue) {
        parts ~= part;
      }
      locale = req.form.get("locale", "");
    } catch (Exception e) {
      respondError(res, HTTPStatus.badRequest, "Invalid form data");
      return;
    }

    if (parts.length == 0) {
      respondError(res, HTTPStatus.badRequest, "No file uploaded");
      return;
    }

    I18nUploadResult[] results;
    try {
      I18nUploadFile[] files;
      foreach (part; parts) {
        immutable name = part.filename.name;
        check(name, getFileInfo(part.tempPath).size); // Before the file is read into memory
        files ~= I18nUploadFile(name, readFile(part.tempPath));
      }
      results = upload(files, locale);
    } catch (I18nUploadException e) {
      respondError(res, statusOf(e.problem), e.msg, e.fileName);
      return;
    }

    auto uploaded = Json.emptyArray;
    foreach (result; results) {
      auto entry = Json.emptyObject;
      entry["file"] = result.file;
      entry["format"] = result.format.to!string;
      entry["locale"] = result.locale;
      entry["messages"] = result.messages;
      uploaded ~= entry;
    }

    auto answer = Json.emptyObject;
    answer["uploaded"] = uploaded;
    res.writeJsonBody(answer);
  }

  private static HTTPStatus statusOf(I18nUploadProblem problem) {
    final switch (problem) {
      case I18nUploadProblem.invalid:
        return HTTPStatus.badRequest;
      case I18nUploadProblem.tooLarge:
        return HTTPStatus.requestEntityTooLarge;
      case I18nUploadProblem.unsupported:
        return HTTPStatus.unsupportedMediaType;
    }
  }

  private void respondError(scope HTTPServerResponse res, HTTPStatus status, string message, string fileName = null) {
    auto answer = Json.emptyObject;
    answer["error"] = message;
    if (fileName.length > 0) {
      answer["file"] = fileName;
    }
    res.writeJsonBody(answer, status);
  }
  // #endregion HTTP
}

version (unittest) {
  import std.exception : assertThrown, collectException;
  import std.string : representation;
}

/// Uploads
unittest {
  auto manager = new I18nManager;
  auto uploader = new I18nUploader(manager);

  auto result = uploader.upload("i18n_de.properties", "a=1\nb=2\n".representation);
  assert(result == I18nUploadResult("i18n_de.properties", I18nFormat.properties, "de", 2));
  assert(manager.translate("a", "de") == "1");

  // Later files merge into their language, and replace equal keys
  uploader.upload("de.po", "msgid \"b\"\nmsgstr \"3\"\n".representation);
  assert(manager.catalog("de").length == 2);
  assert(manager.translate("b", "de") == "3");

  // An explicit locale, and the default locale for a file without any
  assert(uploader.upload("texts.po", "msgid \"a\"\nmsgstr \"b\"\n".representation, "fr-CA").locale == "fr_CA");
  assert(uploader.upload("i18n.properties", "x=y\n".representation).locale == "en");
  assert(manager.languages == ["de", "en", "fr_CA"]);

  // Plural rules arrive with the file
  uploader.upload("ar.po", `msgid ""
msgstr "Plural-Forms: nplurals=1; plural=0;\n"

msgid "a"
msgid_plural "b"
msgstr[0] "c"
`.representation);
  assert(manager.catalog("ar").pluralRule.count == 1);
  assert(manager.translatePlural("a", "b", 5, "ar") == "c");
}

/// A rejected upload changes nothing
unittest {
  auto manager = new I18nManager;
  auto uploader = new I18nUploader(manager).maxFileSize(10);
  uploader.upload("de.properties", "a=1\n".representation);

  auto e = collectException!I18nUploadException(uploader.upload("de.txt", "x".representation));
  assert(e !is null && e.problem == I18nUploadProblem.unsupported && e.fileName == "de.txt");

  e = collectException!I18nUploadException(uploader.upload("de.properties", "a=12345678901".representation));
  assert(e !is null && e.problem == I18nUploadProblem.tooLarge);

  e = collectException!I18nUploadException(uploader.upload("de.po", "nonsense".representation));
  assert(e !is null && e.problem == I18nUploadProblem.invalid);

  e = collectException!I18nUploadException(uploader.upload("de.po", "".representation, "../x"));
  assert(e !is null && e.problem == I18nUploadProblem.invalid);

  // The last file of a request fails, so the first must not be applied
  I18nUploadFile[] files = [
    I18nUploadFile("de.properties", "a=2\n".representation),
    I18nUploadFile("fr.properties", "a=3\n".representation),
    I18nUploadFile("es.mo", "broken".representation),
  ];
  e = collectException!I18nUploadException(uploader.upload(files));
  assert(e !is null && e.fileName == "es.mo");
  assert(manager.translate("a", "de") == "1");
  assert(manager.languages == ["de", "en"]);
}

/// In the mode replace, the files of one request replace the language together
unittest {
  auto manager = new I18nManager;
  auto uploader = new I18nUploader(manager);
  uploader.upload("de.properties", "old=1\n".representation);

  uploader.mergeMode(I18nMergeMode.replace);
  I18nUploadFile[] files = [
    I18nUploadFile("a_de.properties", "a=1\nc=1\n".representation),
    I18nUploadFile("b_de.properties", "b=2\nc=2\n".representation),
  ];
  auto results = uploader.upload(files);
  assert(results.length == 2 && results[0].messages == 2 && results[1].messages == 2);

  auto catalog = manager.catalog("de");
  assert(!catalog.has("old") && catalog.get("a") == "1" && catalog.get("b") == "2" && catalog.get("c") == "2");
}

/// Configuration
unittest {
  assert(new I18nUploader(new I18nManager).maxFileSize == 2 * 1024 * 1024);
  auto config = Json.emptyObject.set("maxFileSize", 5);
  assert(new I18nUploader(new I18nManager, "upload", config).maxFileSize == 5);
}
