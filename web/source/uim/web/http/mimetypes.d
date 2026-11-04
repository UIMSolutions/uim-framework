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
    "js": "application/javascript",
    "mjs": "application/javascript",
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

/// Fallback MIME type for unknown extensions
enum defaultMimeType = "application/octet-stream";

/// Returns the MIME type for a file extension, e.g. mimeType("png") -> "image/png"
string mimeType(string extension) {
  string ext = extension.toLower.strip;
  if (ext.startsWith(".")) {
    ext = ext[1 .. $];
  }
  auto found = ext in mimeTable;
  return found is null ? defaultMimeType : *found;
}

/// Returns the MIME type for a file name, e.g. mimeTypeForFile("index.html") -> "text/html"
string mimeTypeForFile(string fileName) {
  string ext = fileName.extension;
  return ext.length > 0 ? mimeType(ext) : defaultMimeType;
}

/// Checks whether an extension has a known MIME type
bool hasMimeType(string extension) {
  string ext = extension.toLower.strip;
  if (ext.startsWith(".")) {
    ext = ext[1 .. $];
  }
  return (ext in mimeTable) !is null;
}

/// Returns the typical file extension for a MIME type, e.g. extensionFor("image/png") -> "png"
string extensionFor(string mime) {
  foreach (ext, type; mimeTable) {
    if (type == mime.toLower.strip) {
      return ext;
    }
  }
  return null;
}

/// Checks whether a MIME type belongs to the text category
bool isTextMime(string mime) {
  return mime.startsWith("text/");
}

/// Checks whether a MIME type belongs to the image category
bool isImageMime(string mime) {
  return mime.startsWith("image/");
}

/// Checks whether a MIME type belongs to the audio category
bool isAudioMime(string mime) {
  return mime.startsWith("audio/");
}

/// Checks whether a MIME type belongs to the video category
bool isVideoMime(string mime) {
  return mime.startsWith("video/");
}

/// Checks whether a MIME type belongs to the font category
bool isFontMime(string mime) {
  return mime.startsWith("font/");
}

/// Checks whether a MIME type is JSON (application/json or +json suffix)
bool isJsonMime(string mime) {
  return mime == "application/json" || mime.endsWith("+json");
}

/// Checks whether a MIME type is XML (text/xml, application/xml or +xml suffix)
bool isXmlMime(string mime) {
  return mime == "text/xml" || mime == "application/xml" || mime.endsWith("+xml");
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
  assert(extensionFor("text/html") == "html" || extensionFor("text/html") == "htm");
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
}
