/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.webdav.interfaces.client;

@safe:

enum WebDAVSecurity : ubyte {
  none = 0,
  tls = 1
}

struct WebDAVConfig {
  string baseUrl;
  WebDAVSecurity security = WebDAVSecurity.tls;
  string username;
  string password;
  uint timeoutMs = 5_000;
}

struct WebDAVResource {
  string href;
  bool collection;
  ulong contentLength;
  string contentType;
  string etag;
  string lastModified;
}

struct WebDAVResult {
  bool success;
  ushort statusCode;
  string message;
}

alias WebDAVResultHandler = void delegate(WebDAVResult result) @safe;
alias WebDAVResourcesHandler = void delegate(WebDAVResource[] resources) @safe;

alias WebDAVListDelegate = WebDAVResource[] delegate(WebDAVConfig config, string path, uint depth) @safe;
alias WebDAVPutDelegate = WebDAVResult delegate(WebDAVConfig config, string path, string content, string contentType) @safe;
alias WebDAVGetDelegate = string delegate(WebDAVConfig config, string path) @safe;
alias WebDAVDeleteDelegate = WebDAVResult delegate(WebDAVConfig config, string path) @safe;
alias WebDAVMkcolDelegate = WebDAVResult delegate(WebDAVConfig config, string path) @safe;

interface IWebDAVService {
  bool configure(WebDAVConfig config);
  WebDAVConfig config() const;

  bool setListProvider(WebDAVListDelegate provider);
  bool setPutProvider(WebDAVPutDelegate provider);
  bool setGetProvider(WebDAVGetDelegate provider);
  bool setDeleteProvider(WebDAVDeleteDelegate provider);
  bool setMkcolProvider(WebDAVMkcolDelegate provider);

  WebDAVResource[] list(string path = "/", uint depth = 1);
  string get(string path);
  WebDAVResult put(string path, string content, string contentType = "application/octet-stream");
  WebDAVResult mkcol(string path);
  WebDAVResult remove(string path);

  bool listAsync(string path, uint depth, WebDAVResourcesHandler handler);
  bool putAsync(string path, string content, string contentType, WebDAVResultHandler handler);

  WebDAVResource[] parsePropfindResponse(string xmlContent);
}
