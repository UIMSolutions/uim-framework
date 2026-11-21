/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.persistence.storages.documents.file;

import std.file : exists, mkdirRecurse, readText, rename, write;
import std.path : buildPath, dirName;
import uim.service;
import uim.service.persistence.storages.documents.memory;

mixin(ShowModule!());

@safe:

/// Document store persisted as one JSON snapshot file. Every write rewrites
/// the snapshot atomically (temp file + rename), and every read reloads it if
/// the file changed, so a server, the CLI and the GUI can share one data
/// directory. Intended for development, demos and single-node setups.
class FileDocumentStore : MemoryDocumentStore {
  protected string path;
  protected string loadedText;

  /// path: snapshot file, e.g. "data/documents.json" (directories are created).
  this(string path) {
    this.path = path;
    reload();
  }

  string filePath() const {
    return path;
  }

  /// Re-read the snapshot if it changed on disk.
  void reload() @trusted {
    if (!exists(path))
      return;
    auto text = readText(path);
    if (text == loadedText)
      return;
    restore(text.strip.length > 0 ? parseJsonString(text) : Json.emptyObject);
    loadedText = text;
  }

  protected void flush() @trusted {
    auto dir = dirName(path);
    if (dir.length > 0 && !exists(dir))
      mkdirRecurse(dir);
    auto text = snapshot().toPrettyString;
    auto tmp = path ~ ".tmp";
    write(tmp, text);
    rename(tmp, path);
    loadedText = text;
  }

  override Json[] all(string collection, string tenantId) {
    reload();
    return super.all(collection, tenantId);
  }

  override Json get(string collection, string tenantId, string key) {
    reload();
    return super.get(collection, tenantId, key);
  }

  override size_t count(string collection, string tenantId) {
    reload();
    return super.count(collection, tenantId);
  }

  override void put(string collection, string tenantId, string key, Json document) {
    reload();
    super.put(collection, tenantId, key, document);
    flush();
  }

  override bool remove(string collection, string tenantId, string key) {
    reload();
    auto removed = super.remove(collection, tenantId, key);
    if (removed)
      flush();
    return removed;
  }
}

///
unittest {
  mixin(ShowTest!("FileDocumentStore"));

  import std.file : tempDir, remove, exists;
  import std.uuid : randomUUID;

  auto file = buildPath(tempDir, "uim-docs-" ~ randomUUID.toString, "docs.json");
  scope (exit)
    () @trusted {
    if (exists(file))
      remove(file);
  }();

  auto a = new FileDocumentStore(file);
  auto doc = Json.emptyObject;
  doc["v"] = 1;
  a.put("C", "t", "k", doc);

  auto b = new FileDocumentStore(file); // second process view
  assert(b.get("C", "t", "k")["v"].get!long == 1);

  doc["v"] = 2;
  b.put("C", "t", "k", doc);
  assert(a.get("C", "t", "k")["v"].get!long == 2); // a reloads
}
