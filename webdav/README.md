# Library uim-webdav

Updated on 30. May 2026

uim-webdav is a lightweight D library to work with WebDAV workflows using vibe.d runtime patterns. It provides resource listing, content retrieval and upload, collection creation, deletion orchestration, and asynchronous operations.

## Features

- Typed WebDAV contracts (`IWebDAVService`)
- WebDAV client configuration model with security mode support
- PROPFIND XML parsing helper for common DAV resource properties
- Synchronous APIs for list/get/put/mkcol/delete flows
- Async callbacks via vibe.d `runTask`
- Optional provider delegates for integrating real WebDAV HTTP transport later

## Installation

Add this dependency to your `dub.sdl`:

```d
dependency "uim-framework:webdav" version="*"
```

## Quick Start

```d
import std.stdio : writeln;
import uim.webdav;

void main() {
  auto service = WebDAVService();

  WebDAVConfig cfg;
  cfg.baseUrl = "https://dav.example.org";
  cfg.username = "dav-user";
  cfg.password = "secret";

  assert(service.configure(cfg));

  auto list = service.list("/docs/", 1);
  foreach (entry; list) {
    writeln(entry.href, " collection=", entry.collection);
  }

  auto created = service.put("/docs/readme.txt", "hello webdav", "text/plain");
  writeln(created.statusCode, " ", created.message);

  service.listAsync("/docs/", 1, (WebDAVResource[] resources) @safe {
    writeln("async resources=", resources.length);
  });
}
```

## Modules

- `uim.webdav`: package entrypoint and re-exports
- `uim.webdav.interfaces`: WebDAV contracts, enums, and DTO structs
- `uim.webdav.models`: result helper constructors
- `uim.webdav.helpers`: PROPFIND response parsing helpers
- `uim.webdav.service`: operation orchestration, parser facade, and async methods

## Notes

- Default behavior uses in-memory providers for immediate integration without external WebDAV infrastructure.
- For production usage, inject real HTTP providers via `setListProvider`, `setGetProvider`, `setPutProvider`, `setMkcolProvider`, and `setDeleteProvider`.
