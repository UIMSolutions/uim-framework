/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.datasources.cache.cache;

import uim.datasources;

mixin(ShowModule!());

@safe:

/**
 * Cache entry
 */
class CacheEntry {
  string key;
  Json value;
  SysTime createdAt;
  size_t ttl; // Time to live in seconds
  long hitCount;

  this(string k, Json v, size_t timeToLive = 3600) {
    key = k;
    value = v;
    ttl = timeToLive;
    createdAt = Clock.currTime();
    hitCount = 0;
  }

  bool isExpired() {
    if (ttl == 0) return false; // No expiration
    auto elapsed = (Clock.currTime() - createdAt).total!"seconds";
    return elapsed > ttl;
  }

  void touch() {
    hitCount++;
  }
}

/**
 * In-memory cache for data source results
 */
class DataCache : UIMObject {
  protected CacheEntry[string] _cache;
  protected size_t _maxSize = 1000;
  protected bool _enabled = true;

  this(size_t maxCacheSize = 1000) {
    super();
    _maxSize = maxCacheSize;
  }

  void enable() @safe {
    _enabled = true;
  }

  void disable() @safe {
    _enabled = false;
  }

  void set(string key, Json value, size_t ttl = 3600) @safe {
    if (!_enabled) return;

    if (_cache.length >= _maxSize) {
      // Simple eviction: remove oldest entry
      evictOldest();
    }

    _cache[key] = new CacheEntry(key, value, ttl);
  }

  Json get(string key) @safe {
    if (!_enabled) return Json(null);

    if (auto ptr = key in _cache) {
      if (ptr.isExpired()) {
        _cache.remove(key);
        return Json(null);
      }
      ptr.touch();
      return ptr.value;
    }
    return Json(null);
  }

  bool has(string key) @safe {
    if (!_enabled) return false;

    if (auto ptr = key in _cache) {
      if (ptr.isExpired()) {
        _cache.remove(key);
        return false;
      }
      return true;
    }
    return false;
  }

  void remove(string key) @safe {
    _cache.remove(key);
  }

  void clear() @safe {
    _cache = null;
  }

  size_t size() @safe {
    return _cache.length;
  }

  void setMaxSize(size_t maxSize) @safe {
    _maxSize = maxSize;
  }

  protected void evictOldest() @safe {
    string oldestKey = "";
    SysTime oldestTime = Clock.currTime();

    foreach (key, entry; _cache) {
      if (entry.createdAt < oldestTime) {
        oldestKey = key;
        oldestTime = entry.createdAt;
      }
    }

    if (oldestKey.length > 0) {
      _cache.remove(oldestKey);
    }
  }

  void cleanExpired() @safe {
    string[] keysToRemove;

    foreach (key, entry; _cache) {
      if (entry.isExpired()) {
        keysToRemove ~= key;
      }
    }

    foreach (key; keysToRemove) {
      _cache.remove(key);
    }
  }

  // Stats
  long getTotalHits() @safe {
    long total = 0;
    foreach (entry; _cache.byValue()) {
      total += entry.hitCount;
    }
    return total;
  }

  double getHitRate() @safe {
    if (_cache.length == 0) return 0.0;
    long hits = getTotalHits();
    long total = hits + _cache.length;
    return (cast(double)hits / cast(double)total) * 100.0;
  }
}

/**
 * Cached data source wrapper
 */
class CachedDataSource : UIMObject, IValueSource {
  protected IValueSource _source;
  protected DataCache _cache;
  protected bool _cacheEnabled = true;

  this(IValueSource source, size_t cacheSize = 1000) {
    super();
    _source = source;
    _cache = new DataCache(cacheSize);
  }

  void enableCache() @safe {
    _cacheEnabled = true;
    _cache.enable();
  }

  void disableCache() @safe {
    _cacheEnabled = false;
    _cache.disable();
  }

  void clearCache() @safe {
    _cache.clear();
  }

  string name() { return _source.name(); }
  DataSourceType type() { return _source.type(); }
  bool isAvailable() @safe { return _source.isAvailable(); }
  string[string] schema() { return _source.schema(); }

  void connect(void delegate(bool success) @safe callback) @trusted {
    _source.connect(callback);
  }

  void disconnect() @safe {
    _source.disconnect();
  }

  void readAll(void delegate(bool success, Json[] results) @safe callback) @trusted {
    string cacheKey = "readAll";

    if (_cacheEnabled && _cache.has(cacheKey)) {
      auto cached = _cache.get(cacheKey);
      callback(true, cached.get!(Json[]));
      return;
    }

    _source.readAll((bool success, Json[] results) @safe {
      if (success && _cacheEnabled) {
        _cache.set(cacheKey, Json(results));
      }
      callback(success, results);
    });
  }

  void read(string query, void delegate(bool success, Json[] results) @safe callback) @trusted {
    if (_cacheEnabled && _cache.has(query)) {
      auto cached = _cache.get(query);
      callback(true, cached.get!(Json[]));
      return;
    }

    _source.read(query, (bool success, Json[] results) @safe {
      if (success && _cacheEnabled) {
        _cache.set(query, Json(results));
      }
      callback(success, results);
    });
  }

  void write(Json data, void delegate(bool success, Json result) @safe callback) @trusted {
    _source.write(data, (bool success, Json result) @safe {
      if (success) {
        _cache.clear(); // Invalidate cache on write
      }
      callback(success, result);
    });
  }

  void count(void delegate(bool success, long count) @safe callback) @trusted {
    _source.count(callback);
  }
}
