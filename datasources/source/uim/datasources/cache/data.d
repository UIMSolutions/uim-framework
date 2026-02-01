module uim.datasources.cache.data;

import uim.datasources;

mixin(ShowModule!());

@safe:
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