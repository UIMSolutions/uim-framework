/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.webdav.service;

import vibe.d : runTask;

import uim.webdav;

mixin(ShowModule!());

@safe:

class UIMWebDAVService : UIMObject, IWebDAVService {
  private WebDAVConfig _config;
  private bool _configured;

  private WebDAVListDelegate _listProvider;
  private WebDAVPutDelegate _putProvider;
  private WebDAVGetDelegate _getProvider;
  private WebDAVDeleteDelegate _deleteProvider;
  private WebDAVMkcolDelegate _mkcolProvider;

  bool configure(WebDAVConfig config) {
    if (config.baseUrl.length == 0) {
      _configured = false;
      return false;
    }

    _config = config;
    _configured = true;
    return true;
  }

  WebDAVConfig config() const {
    return _config;
  }

  bool setListProvider(WebDAVListDelegate provider) {
    _listProvider = provider;
    return true;
  }

  bool setPutProvider(WebDAVPutDelegate provider) {
    _putProvider = provider;
    return true;
  }

  bool setGetProvider(WebDAVGetDelegate provider) {
    _getProvider = provider;
    return true;
  }

  bool setDeleteProvider(WebDAVDeleteDelegate provider) {
    _deleteProvider = provider;
    return true;
  }

  bool setMkcolProvider(WebDAVMkcolDelegate provider) {
    _mkcolProvider = provider;
    return true;
  }

  WebDAVResource[] list(string path = "/", uint depth = 1) {
    WebDAVResource[] result;
    if (!_configured) {
      return result;
    }

    if (_listProvider !is null) {
      try {
        return _listProvider(_config, path, depth);
      } catch (Exception) {
        return result;
      }
    }

    result ~= WebDAVResource(path, true, 0, "", "", "");
    result ~= WebDAVResource(path ~ "readme.txt", false, 120, "text/plain", "\"etag-1\"", "Mon, 29 May 2026 10:00:00 GMT");
    return result;
  }

  string get(string path) {
    if (!_configured || path.length == 0) {
      return "";
    }

    if (_getProvider !is null) {
      try {
        return _getProvider(_config, path);
      } catch (Exception) {
        return "";
      }
    }

    return "webdav in-memory content";
  }

  WebDAVResult put(string path, string content, string contentType = "application/octet-stream") {
    if (!_configured) {
      return WebDAVResultErr(412, "WebDAV service is not configured.");
    }

    if (path.length == 0) {
      return WebDAVResultErr(400, "path is required");
    }

    if (_putProvider !is null) {
      try {
        return _putProvider(_config, path, content, contentType);
      } catch (Exception ex) {
        return WebDAVResultErr(500, ex.msg);
      }
    }

    return WebDAVResultOk(201, "resource created or replaced");
  }

  WebDAVResult mkcol(string path) {
    if (!_configured) {
      return WebDAVResultErr(412, "WebDAV service is not configured.");
    }

    if (path.length == 0) {
      return WebDAVResultErr(400, "path is required");
    }

    if (_mkcolProvider !is null) {
      try {
        return _mkcolProvider(_config, path);
      } catch (Exception ex) {
        return WebDAVResultErr(500, ex.msg);
      }
    }

    return WebDAVResultOk(201, "collection created");
  }

  WebDAVResult remove(string path) {
    if (!_configured) {
      return WebDAVResultErr(412, "WebDAV service is not configured.");
    }

    if (path.length == 0) {
      return WebDAVResultErr(400, "path is required");
    }

    if (_deleteProvider !is null) {
      try {
        return _deleteProvider(_config, path);
      } catch (Exception ex) {
        return WebDAVResultErr(500, ex.msg);
      }
    }

    return WebDAVResultOk(204, "resource deleted");
  }

  bool listAsync(string path, uint depth, WebDAVResourcesHandler handler) {
    if (handler is null) {
      return false;
    }

    auto localPath = path;
    auto localDepth = depth;
    auto localHandler = handler;

    (() @trusted {
      runTask(() nothrow {
        try {
          localHandler(list(localPath, localDepth));
        } catch (Exception) {
        }
      });
    })();

    return true;
  }

  bool putAsync(string path, string content, string contentType, WebDAVResultHandler handler) {
    if (handler is null) {
      return false;
    }

    auto localPath = path;
    auto localContent = content;
    auto localType = contentType;
    auto localHandler = handler;

    (() @trusted {
      runTask(() nothrow {
        try {
          localHandler(put(localPath, localContent, localType));
        } catch (Exception) {
        }
      });
    })();

    return true;
  }

  WebDAVResource[] parsePropfindResponse(string xmlContent) {
    return webdavParsePropfindResponse(xmlContent);
  }
}

IWebDAVService WebDAVService() {
  return new UIMWebDAVService();
}

unittest {
  auto service = WebDAVService();

  WebDAVConfig config;
  config.baseUrl = "https://dav.example.org";
  assert(service.configure(config));

  auto listing = service.list("/docs/", 1);
  assert(listing.length >= 1);

  auto created = service.put("/docs/readme.txt", "hello", "text/plain");
  assert(created.success);

  auto fetched = service.get("/docs/readme.txt");
  assert(fetched.length > 0);

  auto removed = service.remove("/docs/readme.txt");
  assert(removed.success);
}
