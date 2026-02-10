module uim.datasources.cache.datasource;

import uim.datasources;

mixin(ShowModule!());

@safe:
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

  void enableCache() {
    _cacheEnabled = true;
    _cache.enable();
  }

  void disableCache() {
    _cacheEnabled = false;
    _cache.disable();
  }

  void clearCache() {
    _cache.clear();
  }

  string name() { return _source.name(); }
  DataSourceType type() { return _source.type(); }
  bool isAvailable() { return _source.isAvailable(); }
  string[string] schema() { return _source.schema(); }

  void connect(void delegate(bool success) @safe callback) @trusted {
    _source.connect(callback);
  }

  void disconnect() {
    _source.disconnect();
  }

  void readAll(void delegate(bool success, Json[] results) @safe callback) @trusted {
    string cacheKey = "readAll";

    if (_cacheEnabled && _cache.has(cacheKey)) {
      auto cached = _cache.get(cacheKey);
      callback(true, cached.get!(Json[]));
      return;
    }

    _source.readAll((bool success, Json[] results) {
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

    _source.read(query, (bool success, Json[] results) {
      if (success && _cacheEnabled) {
        _cache.set(query, Json(results));
      }
      callback(success, results);
    });
  }

  void write(Json data, void delegate(bool success, Json result) @safe callback) @trusted {
    _source.write(data, (bool success, Json result) {
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