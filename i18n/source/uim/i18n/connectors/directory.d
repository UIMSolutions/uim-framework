/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.i18n.connectors.directory;

import uim.i18n;

import std.algorithm.sorting : sort;
import std.array : array;
import std.path : buildPath;
import std.string : format;

import vibe.core.file : FileInfo, getFileInfo, listDirectory, readFile;

mixin(ShowModule!());

@safe:

/// Reads the language files of a directory, for example the export of another system on a shared volume.
///
/// The locale of a file comes from its name, so "texts_de.po" and "de.properties" both belong to "de".
/// Files of the same locale are merged in the order of their names, and subdirectories are ignored.
class I18nDirectoryConnector : I18nConnector {
  this(string path) {
    _path = path;
  }

  // #region Properties
  protected string _path;
  /// The directory
  string path() const {
    return _path;
  }

  string name() {
    return _path;
  }

  protected ulong _maxFileSize = 16 * 1024 * 1024;
  /// Largest accepted file in bytes
  ulong maxFileSize() const {
    return _maxFileSize;
  }

  auto maxFileSize(ulong value) {
    _maxFileSize = value;
    return this;
  }
  // #endregion Properties

  /// The locales that have at least one file, sorted
  /// Throws: I18nConnectorException if the directory cannot be read
  string[] locales() {
    bool[string] found;
    foreach (fileName; languageFiles) {
      found[localeFromFileName(fileName)] = true;
    }
    return found.keys.sort.array;
  }

  /// Reads all files of a locale
  /// Throws: I18nConnectorException if a file cannot be read, I18nParseException for bad content
  I18nCatalog fetch(string locale) {
    auto normalized = normalizeLocale(locale);
    if (normalized.length == 0) {
      throw new I18nConnectorException("%s: Invalid locale '%s'".format(_path, locale));
    }

    auto catalog = new I18nCatalog(normalized);
    foreach (fileName; languageFiles) {
      if (localeFromFileName(fileName) != normalized) {
        continue;
      }

      immutable filePath = buildPath(_path, fileName);
      const(ubyte)[] content;
      try {
        if (getFileInfo(filePath).size > _maxFileSize) {
          throw new I18nConnectorException("%s: File %s is too large".format(_path, fileName));
        }
        content = readFile(filePath);
      } catch (I18nConnectorException e) {
        throw e;
      } catch (Exception e) {
        throw new I18nConnectorException("%s: Cannot read %s: %s".format(_path, fileName, e.msg));
      }
      catalog.merge(loadCatalog(fileName, content, normalized));
    }
    return catalog;
  }

  /// The names of all files with a known format and a locale in their name, sorted
  private string[] languageFiles() {
    string[] names;
    try {
      listDirectory(_path, (FileInfo info) {
        if (!info.isDirectory && detectI18nFormat(info.name) != I18nFormat.unknown
          && localeFromFileName(info.name).length > 0) {
          names ~= info.name;
        }
        return true;
      });
    } catch (Exception e) {
      throw new I18nConnectorException("%s: Cannot read the directory: %s".format(_path, e.msg));
    }
    return names.sort.release;
  }
}

version (unittest) {
  import std.exception : assertThrown;
  import std.file : mkdirRecurse, rmdirRecurse, tempDir, write;
  import std.uuid : randomUUID;

  private string createDirectory(string[2][] files) {
    immutable path = buildPath(tempDir, "uim-i18n-" ~ randomUUID().toString);
    mkdirRecurse(path);
    foreach (file; files) {
      write(buildPath(path, file[0]), file[1]);
    }
    return path;
  }
}

///
unittest {
  auto path = createDirectory([
    ["a_de.properties", "a=1\nb=1\n"],
    ["b_de.properties", "b=2\n"],
    ["fr.po", "msgid \"a\"\nmsgstr \"c\"\n"],
    ["readme.txt", "not a language file"],
    ["i18n.properties", "no=locale\n"],
  ]);
  scope (exit) rmdirRecurse(path);
  mkdirRecurse(buildPath(path, "es.json"));

  auto connector = new I18nDirectoryConnector(path);
  assert(connector.locales == ["de", "fr"]);

  auto german = connector.fetch("de");
  assert(german.locale == "de" && german.length == 2);
  assert(german.get("b") == "2"); // Merged in name order

  assert(connector.fetch("es").length == 0);
  assertThrown!I18nConnectorException(connector.fetch("../x"));

  auto manager = new I18nManager;
  assert(manager.sync(connector).length == 2);
  assert(manager.translate("a", "fr") == "c");

  connector.maxFileSize(1);
  assertThrown!I18nConnectorException(connector.fetch("de"));
}

/// Failures
unittest {
  auto path = createDirectory([["de.po", "nonsense"]]);
  scope (exit) rmdirRecurse(path);

  assertThrown!I18nParseException(new I18nDirectoryConnector(path).fetch("de"));
  assertThrown!I18nConnectorException(new I18nDirectoryConnector(path ~ "/missing").locales());
}
