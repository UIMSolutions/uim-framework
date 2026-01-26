/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.docker.resources;

import std.json : JSONValue, JSONType;

// Container resource wrapper
struct Container {
  JSONValue data;

  string id() const @trusted {
    if (auto i = "Id" in data.object) {
      return i.str;
    }
    return "";
  }

  string name() const @trusted {
    if (auto names = "Names" in data.object) {
      if (names.type == JSONValue.Type.array && names.array.length > 0) {
        auto nameStr = names.array[0].str;
        if (nameStr.length > 0 && nameStr[0] == '/') {
          return nameStr[1 .. $];
        }
        return nameStr;
      }
    }
    return "";
  }

  string status() const @trusted {
    if (auto s = "State" in data.object) {
      return s.str;
    }
    return "unknown";
  }

  string image() const @trusted {
    if (auto img = "Image" in data.object) {
      return img.str;
    }
    return "";
  }

  JSONValue[] ports() const @trusted {
    if (auto p = "Ports" in data.object) {
      if (p.type == JSONValue.Type.array) {
        return p.array;
      }
    }
    return [];
  }

  string[] labels() const @trusted {
    if (auto l = "Labels" in data.object) {
      if (l.type == JSONValue.Type.object) {
        return l.object.keys;
      }
    }
    return [];
  }
}

// Image resource wrapper
struct Image {
  JSONValue data;

  string id() const @trusted {
    if (auto i = "Id" in data.object) {
      return i.str;
    }
    return "";
  }

  string[] repoTags() const @trusted {
    if (auto tags = "RepoTags" in data.object) {
      if (tags.type == JSONValue.Type.array) {
        string[] result;
        foreach (tag; tags.array) {
          result ~= tag.str;
        }
        return result;
      }
    }
    return [];
  }

  long size() const @trusted {
    if (auto s = "Size" in data.object) {
      if (s.type == JSONValue.Type.integer) {
        return s.integer;
      }
    }
    return 0;
  }

  long created() const @trusted {
    if (auto c = "Created" in data.object) {
      if (c.type == JSONValue.Type.integer) {
        return c.integer;
      }
    }
    return 0;
  }
}

// Volume resource wrapper
struct Volume {
  JSONValue data;

  string name() const @trusted {
    if (auto n = "Name" in data.object) {
      return n.str;
    }
    return "";
  }

  string driver() const @trusted {
    if (auto d = "Driver" in data.object) {
      return d.str;
    }
    return "";
  }

  JSONValue mountpoint() const @trusted {
    if (auto m = "Mountpoint" in data.object) {
      return *m;
    }
    return JSONValue("");
  }

  JSONValue labels() const @trusted {
    if (auto l = "Labels" in data.object) {
      return *l;
    }
    return JSONValue.object;
  }
}

// Network resource wrapper
struct Network {
  JSONValue data;

  string name() const @trusted {
    if (auto n = "Name" in data.object) {
      return n.str;
    }
    return "";
  }

  string id() const @trusted {
    if (auto i = "Id" in data.object) {
      return i.str;
    }
    return "";
  }

  string driver() const @trusted {
    if (auto d = "Driver" in data.object) {
      return d.str;
    }
    return "";
  }

  JSONValue scopeValue() const @trusted {
    if (auto s = "Scope" in data.object) {
      return *s;
    }
    return JSONValue("local");
  }

  JSONValue containers() const @trusted {
    if (auto c = "Containers" in data.object) {
      return *c;
    }
    return JSONValue.object;
  }
}
