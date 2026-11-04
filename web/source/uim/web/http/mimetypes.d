/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.http.mimetypes;

import uim.web;

mixin(ShowModule!());

@safe:

private string[string] _mimeByExtension;
private string[string] _extensionByMime;

private string[string] mimeTable() {
  if (_mimeByExtension is null) {
    _mimeByExtension = [
    // text
    "html": "text/html",
    "htm": "text/html",
    "css": "text/css",
    "csv": "text/csv",
    "txt": "text/plain",
    "md": "text/markdown",
    "xml": "text/xml",
    "ics": "text/calendar",

    // application
    "json": "application/json",
    "js": "text/javascript",
    "mjs": "text/javascript",
    "map": "application/json",
    "jsonld": "application/ld+json",
    "webmanifest": "application/manifest+json",
    "pdf": "application/pdf",
    "zip": "application/zip",
    "gz": "application/gzip",
    "tar": "application/x-tar",
    "rar": "application/vnd.rar",
    "7z": "application/x-7z-compressed",
    "wasm": "application/wasm",
    "yaml": "application/yaml",
    "yml": "application/yaml",
    "rtf": "application/rtf",
    "doc": "application/msword",
    "docx": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
    "xls": "application/vnd.ms-excel",
    "xlsx": "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
    "ppt": "application/vnd.ms-powerpoint",
    "pptx": "application/vnd.openxmlformats-officedocument.presentationml.presentation",
    "epub": "application/epub+zip",

    // images
    "png": "image/png",
    "jpg": "image/jpeg",
    "jpeg": "image/jpeg",
    "gif": "image/gif",
    "svg": "image/svg+xml",
    "webp": "image/webp",
    "avif": "image/avif",
    "ico": "image/x-icon",
    "bmp": "image/bmp",
    "tif": "image/tiff",
    "tiff": "image/tiff",

    // audio
    "mp3": "audio/mpeg",
    "wav": "audio/wav",
    "ogg": "audio/ogg",
    "flac": "audio/flac",
    "aac": "audio/aac",
    "m4a": "audio/mp4",
    "opus": "audio/opus",

    // video
    "mp4": "video/mp4",
    "webm": "video/webm",
    "avi": "video/x-msvideo",
    "mov": "video/quicktime",
    "mkv": "video/x-matroska",

    // fonts
    "woff": "font/woff",
    "woff2": "font/woff2",
    "ttf": "font/ttf",
    "otf": "font/otf",
    "eot": "application/vnd.ms-fontobject"
    ];
  }
  return _mimeByExtension;
}

// Reverse lookup: the alphabetically first extension of a type, unless a more common one is named
private string[string] extensionTable() {
  if (_extensionByMime is null) {
    foreach (ext; mimeTable.keys.sort.retro) {
      _extensionByMime[mimeTable[ext]] = ext;
    }
    _extensionByMime["application/json"] = "json";
    _extensionByMime["application/yaml"] = "yaml";
    _extensionByMime["image/jpeg"] = "jpg";
    _extensionByMime["image/tiff"] = "tiff";
    _extensionByMime["text/html"] = "html";
  }
  return _extensionByMime;
}

/// Fallback MIME type for unknown extensions
enum defaultMimeType = "application/octet-stream";

private string normalizeExtension(string extension) {
  string ext = extension.toLower.strip;
  return ext.startsWith(".") ? ext[1 .. $] : ext;
}

/// Returns the MIME type for a file extension, e.g. mimeType("png") -> "image/png"
string mimeType(string extension) {
  auto found = normalizeExtension(extension) in mimeTable;
  return found is null ? defaultMimeType : *found;
}

/// Returns the MIME type for a file name, e.g. mimeTypeForFile("index.html") -> "text/html"
string mimeTypeForFile(string fileName) {
  string ext = fileName.extension;
  return ext.length > 0 ? mimeType(ext) : defaultMimeType;
}

/// Returns a Content-Type value for a file name, with a charset for textual types
string contentTypeForFile(string fileName, string charset = "utf-8") {
  string mime = mimeTypeForFile(fileName);
  bool isTextual = isTextMime(mime) || isJsonMime(mime) || isXmlMime(mime);
  return isTextual ? "%s; charset=%s".format(mime, charset) : mime;
}

/// Checks whether an extension has a known MIME type
bool hasMimeType(string extension) {
  return (normalizeExtension(extension) in mimeTable) !is null;
}

/// Returns the typical file extension for a MIME type, e.g. extensionFor("image/png") -> "png"
string extensionFor(string mime) {
  auto found = baseMimeType(mime) in extensionTable;
  return found is null ? null : *found;
}

/// The lowercase type without parameters, e.g. "Text/HTML; charset=utf-8" -> "text/html"
string baseMimeType(string mime) {
  auto parameters = mime.indexOf(';');
  return (parameters >= 0 ? mime[0 .. parameters] : mime).strip.toLower;
}

/// Checks whether a MIME type belongs to the text category
bool isTextMime(string mime) {
  return baseMimeType(mime).startsWith("text/");
}

/// Checks whether a MIME type belongs to the image category
bool isImageMime(string mime) {
  return baseMimeType(mime).startsWith("image/");
}

/// Checks whether a MIME type belongs to the audio category
bool isAudioMime(string mime) {
  return baseMimeType(mime).startsWith("audio/");
}

/// Checks whether a MIME type belongs to the video category
bool isVideoMime(string mime) {
  return baseMimeType(mime).startsWith("video/");
}

/// Checks whether a MIME type belongs to the font category
bool isFontMime(string mime) {
  return baseMimeType(mime).startsWith("font/");
}

/// Checks whether a MIME type is JSON (application/json or +json suffix)
bool isJsonMime(string mime) {
  string base = baseMimeType(mime);
  return base == "application/json" || base.endsWith("+json");
}

/// Checks whether a MIME type is XML (text/xml, application/xml or +xml suffix)
bool isXmlMime(string mime) {
  string base = baseMimeType(mime);
  return base == "text/xml" || base == "application/xml" || base.endsWith("+xml");
}

///
unittest {
  // extension lookup
  assert(mimeType("html") == "text/html");
  assert(mimeType(".html") == "text/html");
  assert(mimeType("PNG") == "image/png");
  assert(mimeType("json") == "application/json");
  assert(mimeType("woff2") == "font/woff2");
  assert(mimeType("unknown") == defaultMimeType);
  assert(defaultMimeType == "application/octet-stream");

  // file name lookup
  assert(mimeTypeForFile("index.html") == "text/html");
  assert(mimeTypeForFile("archive.tar.gz") == "application/gzip");
  assert(mimeTypeForFile("noextension") == defaultMimeType);

  // existence check
  assert(hasMimeType("css"));
  assert(hasMimeType(".mp4"));
  assert(!hasMimeType("nope"));

  // reverse lookup
  assert(extensionFor("image/png") == "png");
  assert(extensionFor("application/json") == "json");
  assert(extensionFor("text/html") == "html");
  assert(extensionFor("image/jpeg") == "jpg");
  assert(extensionFor("text/javascript") == "js");
  assert(extensionFor(" TEXT/HTML; charset=utf-8") == "html");
  assert(extensionFor("application/x-unknown") is null);

  // categories
  assert(isTextMime("text/html"));
  assert(!isTextMime("image/png"));
  assert(isImageMime("image/svg+xml"));
  assert(!isImageMime("text/css"));
  assert(isAudioMime("audio/mpeg"));
  assert(isVideoMime("video/mp4"));
  assert(isFontMime("font/woff2"));
  assert(isJsonMime("application/json"));
  assert(isJsonMime("application/hal+json"));
  assert(!isJsonMime("text/html"));
  assert(isXmlMime("text/xml"));
  assert(isXmlMime("image/svg+xml"));
  assert(!isXmlMime("application/json"));

  // parameters and case do not change the category
  assert(baseMimeType("Text/HTML; charset=utf-8") == "text/html");
  assert(isJsonMime("application/json; charset=utf-8"));
  assert(isJsonMime("Application/Problem+JSON"));
  assert(isXmlMime("application/xml;charset=utf-8"));
  assert(isTextMime("TEXT/plain"));
  assert(isImageMime("IMAGE/png"));

  // current types
  assert(mimeType("js") == "text/javascript");
  assert(mimeType("webmanifest") == "application/manifest+json");

  // content type headers
  assert(contentTypeForFile("a.html") == "text/html; charset=utf-8");
  assert(contentTypeForFile("a.json", "utf-16") == "application/json; charset=utf-16");
  assert(contentTypeForFile("a.svg") == "image/svg+xml; charset=utf-8");
  assert(contentTypeForFile("a.png") == "image/png");
}
