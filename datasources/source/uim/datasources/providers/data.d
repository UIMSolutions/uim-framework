module uim.datasources.providers.data;

import uim.datasources;

mixin(ShowModule!());

@safe:
/**
 * Data provider implementation
 */
class DataProvider : UIMObject, IValueProvider {
  protected IValueSource[string] _sources;

  this() {
    super();
  }

  IValueProvider registerSource(string sourceName, IValueSource source) {
    _sources[sourceName] = source;
    return this;
  }

  IValueSource getSource(string sourceName) {
    if (auto ptr = sourceName in _sources) {
      return *ptr;
    }
    return null;
  }

  bool hasSource(string sourceName) {
    return (sourceName in _sources) !is null;
  }

  IValueSource[] getAllSources() {
    IValueSource[] sources;
    foreach (source; _sources.byValue()) {
      sources ~= source;
    }
    return sources;
  }

  void query(string sourceName, string query, void delegate(bool success, Json[] results) @safe callback) @trusted {
    if (auto source = getSource(sourceName)) {
      source.read(query, callback);
    } else {
      callback(false, []);
    }
  }

  void fetch(string sourceName, void delegate(bool success, Json[] results) @safe callback) @trusted {
    if (auto source = getSource(sourceName)) {
      source.readAll(callback);
    } else {
      callback(false, []);
    }
  }

  void persist(string sourceName, Json data, void delegate(bool success, Json result) @safe callback) @trusted {
    if (auto source = getSource(sourceName)) {
      source.write(data, callback);
    } else {
      callback(false, Json(null));
    }
  }

  bool areSourcesAvailable() @safe {
    foreach (source; _sources.byValue()) {
      if (!source.isAvailable()) {
        return false;
      }
    }
    return true;
  }
}