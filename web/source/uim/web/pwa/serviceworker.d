/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.pwa.serviceworker;

import uim.web;

mixin(ShowModule!());

@safe:

/// Runtime caching strategies for service worker fetch handling
enum CacheStrategy {
  cacheFirst,
  networkFirst,
  networkOnly,
  cacheOnly,
  staleWhileRevalidate
}

/// A runtime caching route: requests matching the pattern are handled with the strategy.
struct CacheRoute {
  string pattern; // RegExp source, e.g. `\\.(?:png|jpg)$`
  CacheStrategy strategy;
  string cacheName; // empty = default cache of the script
}

/// Creates a runtime caching route, e.g. cacheRoute(`\\.(?:png|jpg)$`, CacheStrategy.cacheFirst)
CacheRoute cacheRoute(string pattern, CacheStrategy strategy, string cacheName = null) {
  return CacheRoute(pattern, strategy, cacheName);
}

/// A builder generating a service worker script (sw.js).
class ServiceWorkerScript {
  this(string cacheName = "pwa-cache-v1") {
    _cacheName = cacheName;
  }

  /// The name of the default cache
  string cacheName() const {
    return _cacheName;
  }

  /// Sets the cache name (fluent interface)
  auto cache(string name) {
    _cacheName = name;
    return this;
  }

  /// Adds a URL to precache during installation (fluent interface)
  auto precache(string url) {
    _precacheUrls ~= url;
    return this;
  }

  /// Adds URLs to precache during installation (fluent interface)
  auto precacheAll(string[] urls...) {
    foreach (url; urls) {
      precache(url);
    }
    return this;
  }

  /// Sets the offline fallback page served when navigation fails (fluent interface)
  auto offlinePage(string url) {
    _offlinePage = url;
    return precache(url);
  }

  /// Adds a runtime caching route (fluent interface)
  auto route(CacheRoute value) {
    _routes ~= value;
    return this;
  }

  /// Adds a runtime caching route (fluent interface)
  auto route(string pattern, CacheStrategy strategy, string cacheName = null) {
    return route(CacheRoute(pattern, strategy, cacheName));
  }

  /// Enables immediate activation via skipWaiting (fluent interface)
  auto skipWaiting(bool value = true) {
    _skipWaiting = value;
    return this;
  }

  /// Enables clients.claim() on activation (fluent interface)
  auto clientsClaim(bool value = true) {
    _clientsClaim = value;
    return this;
  }

  /// Enables cleanup of old caches on activation (fluent interface)
  auto cleanupOldCaches(bool value = true) {
    _cleanupOldCaches = value;
    return this;
  }

  /// Adds a push notification handler with static title and body (fluent interface)
  auto pushNotification(string title, string body = null) {
    _pushTitle = title;
    _pushBody = body;
    return this;
  }

  /// All precache URLs
  string[] precacheUrls() const {
    return _precacheUrls.dup;
  }

  /// All runtime caching routes
  CacheRoute[] routes() const {
    return _routes.dup;
  }

  /// Renders the complete service worker script
  override string toString() const {
    auto result = appender!string;
    result.put("const CACHE_NAME = %s;\n".format(jsString(_cacheName)));
    result.put("const PRECACHE_URLS = %s;\n".format(jsArray(_precacheUrls.dup)));
    result.put("\n");
    result.put(renderInstall);
    result.put("\n");
    result.put(renderActivate);
    result.put("\n");
    result.put(renderFetch);
    if (_pushTitle.length > 0) {
      result.put("\n");
      result.put(renderPush);
    }
    return result.data;
  }

  private string renderInstall() const {
    auto result = appender!string;
    result.put("self.addEventListener('install', (event) => {\n");
    result.put("  event.waitUntil(\n");
    result.put("    caches.open(CACHE_NAME).then((cache) => cache.addAll(PRECACHE_URLS))\n");
    result.put("  );\n");
    if (_skipWaiting) {
      result.put("  self.skipWaiting();\n");
    }
    result.put("});\n");
    return result.data;
  }

  private string renderActivate() const {
    auto result = appender!string;
    result.put("self.addEventListener('activate', (event) => {\n");
    string[] actions;
    if (_cleanupOldCaches) {
      actions ~= "caches.keys().then((names) => Promise.all(names.filter((name) => name != CACHE_NAME).map((name) => caches.delete(name))))";
    }
    if (_clientsClaim) {
      actions ~= "self.clients.claim()";
    }
    if (actions.length == 0) {
      result.put("  // no activation tasks\n");
    } else {
      result.put("  event.waitUntil(Promise.all([\n");
      foreach (i, action; actions) {
        result.put("    %s%s\n".format(action, i + 1 < actions.length ? "," : ""));
      }
      result.put("  ]));\n");
    }
    result.put("});\n");
    return result.data;
  }

  private string renderFetch() const {
    auto result = appender!string;
    result.put("self.addEventListener('fetch', (event) => {\n");
    result.put("  if (event.request.method != 'GET') return;\n");

    if (_offlinePage.length > 0) {
      result.put("  if (event.request.mode == 'navigate') {\n");
      result.put("    event.respondWith(fetch(event.request).catch(() => caches.match(%s)));\n"
        .format(jsString(_offlinePage)));
      result.put("    return;\n");
      result.put("  }\n");
    }

    foreach (route; _routes) {
      string cache = route.cacheName.length > 0 ? route.cacheName : "CACHE_NAME";
      string cacheExpr = route.cacheName.length > 0 ? jsString(route.cacheName) : "CACHE_NAME";
      result.put("  if (/%s/.test(event.request.url)) {\n".format(route.pattern));
      result.put("    event.respondWith(%s);\n".format(strategyHandler(route.strategy, cacheExpr)));
      result.put("    return;\n");
      result.put("  }\n");
    }

    // default: network falling back to cache
    result.put("  event.respondWith(fetch(event.request).catch(() => caches.match(event.request)));\n");
    result.put("});\n");
    return result.data;
  }

  private string renderPush() const {
    auto result = appender!string;
    result.put("self.addEventListener('push', (event) => {\n");
    result.put("  const data = event.data ? event.data.json() : {};\n");
    result.put("  event.waitUntil(self.registration.showNotification(data.title || %s, {\n"
      .format(jsString(_pushTitle)));
    result.put("    body: data.body || %s,\n".format(jsString(_pushBody)));
    result.put("    icon: data.icon\n");
    result.put("  }));\n");
    result.put("});\n");
    return result.data;
  }

  private static string strategyHandler(CacheStrategy strategy, string cacheExpr) {
    final switch (strategy) {
      case CacheStrategy.cacheFirst:
        return "caches.open(%s).then((cache) => cache.match(event.request).then((cached) => cached || fetch(event.request).then((response) => { cache.put(event.request, response.clone()); return response; })))"
          .format(cacheExpr);
      case CacheStrategy.networkFirst:
        return "fetch(event.request).then((response) => { const copy = response.clone(); caches.open(%s).then((cache) => cache.put(event.request, copy)); return response; }).catch(() => caches.match(event.request))"
          .format(cacheExpr);
      case CacheStrategy.networkOnly:
        return "fetch(event.request)";
      case CacheStrategy.cacheOnly:
        return "caches.match(event.request)";
      case CacheStrategy.staleWhileRevalidate:
        return "caches.match(event.request).then((cached) => { const fetched = fetch(event.request).then((response) => { const copy = response.clone(); caches.open(%s).then((cache) => cache.put(event.request, copy)); return response; }); return cached || fetched; })"
          .format(cacheExpr);
    }
  }

  private string _cacheName;
  private string[] _precacheUrls;
  private string _offlinePage;
  private CacheRoute[] _routes;
  private bool _skipWaiting;
  private bool _clientsClaim;
  private bool _cleanupOldCaches;
  private string _pushTitle;
  private string _pushBody;
}

/// Creates a service worker script builder
ServiceWorkerScript serviceWorkerScript(string cacheName = "pwa-cache-v1") {
  return new ServiceWorkerScript(cacheName);
}

///
unittest {
  // minimal script
  auto minimal = serviceWorkerScript();
  string minimalScript = minimal.toString;
  assert(minimalScript.canFind("const CACHE_NAME = 'pwa-cache-v1';"));
  assert(minimalScript.canFind("self.addEventListener('install'"));
  assert(minimalScript.canFind("self.addEventListener('activate'"));
  assert(minimalScript.canFind("self.addEventListener('fetch'"));
  assert(!minimalScript.canFind("skipWaiting"));
  assert(!minimalScript.canFind("self.addEventListener('push'"));

  // full script
  auto sw = serviceWorkerScript("my-app-v2")
    .precacheAll("/", "/index.html", "/style.css", "/app.js")
    .offlinePage("/offline.html")
    .route(`\.(?:png|jpg|webp)$`, CacheStrategy.cacheFirst, "images")
    .route(`/api/`, CacheStrategy.networkFirst)
    .route(`/cdn/`, CacheStrategy.staleWhileRevalidate)
    .skipWaiting
    .clientsClaim
    .cleanupOldCaches
    .pushNotification("News", "Something happened");

  assert(sw.cacheName == "my-app-v2");
  assert(sw.precacheUrls.length == 5); // offline page is precached too
  assert(sw.routes.length == 3);

  string script = sw.toString;
  assert(script.canFind("const CACHE_NAME = 'my-app-v2';"));
  assert(script.canFind("'/index.html'"));
  assert(script.canFind("'/offline.html'"));
  assert(script.canFind("self.skipWaiting();"));
  assert(script.canFind("self.clients.claim()"));
  assert(script.canFind("caches.keys()")); // cleanup
  assert(script.canFind("event.request.mode == 'navigate'"));
  assert(script.canFind("caches.match('/offline.html')"));
  assert(script.canFind("/\\.(?:png|jpg|webp)$/.test(event.request.url)"));
  assert(script.canFind("caches.open('images')"));
  assert(script.canFind("//api//.test(event.request.url)"));
  assert(script.canFind("self.addEventListener('push'"));
  assert(script.canFind("'News'"));

  // strategy handlers
  assert(script.canFind("cache.match(event.request).then((cached) => cached || fetch(event.request)")); // cacheFirst
  assert(script.canFind("cache.put(event.request, response.clone())")); // cacheFirst stores responses
  assert(script.canFind("fetch(event.request).then((response) =>")); // networkFirst
  assert(script.canFind(".catch(() => caches.match(event.request))")); // networkFirst fallback
  assert(script.canFind("cache.put(event.request, copy)")); // staleWhileRevalidate

  // route struct
  auto route = cacheRoute(`\.css$`, CacheStrategy.cacheOnly, "styles");
  assert(route.pattern == `\.css$`);
  assert(route.strategy == CacheStrategy.cacheOnly);
  assert(route.cacheName == "styles");

  // non-GET requests are passed through
  assert(script.canFind("if (event.request.method != 'GET') return;"));
}
