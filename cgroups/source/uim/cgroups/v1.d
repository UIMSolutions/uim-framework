/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.cgroups.v1;

import std.array : split;
import std.conv : to;
import std.exception : enforce;
import std.file : exists, readText;
import std.path : buildPath;
import std.string : strip, splitLines;

import uim.cgroups.common;

@safe:

/// Cgroups v1 management (legacy per-controller hierarchies)
class CgroupV1 {
  private string controller;
  private string path;
  private string mountPoint;

  /// Creates a cgroup v1 handle
  this(string controller, string path, string mountPoint = "/sys/fs/cgroup") @safe {
    this.controller = controller;
    this.path = path;
    this.mountPoint = mountPoint;
  }

  /// Gets the full path to the cgroup
  string fullPath() const @safe {
    return buildPath(mountPoint, controller, path);
  }

  /// Creates the cgroup
  void create() @trusted {
    createCgroup(fullPath());
  }

  /// Checks if cgroup exists
  bool exists_() const @trusted {
    return cgroupExists(fullPath());
  }

  /// Removes the cgroup
  void remove() @trusted {
    removeCgroup(fullPath());
  }

  /// Sets a controller parameter
  void setController(string param, string value) @trusted {
    auto filePath = buildPath(fullPath(), param);
    writeCgroupValue(filePath, value);
  }

  /// Gets a controller parameter
  string getController(string param) @trusted {
    auto filePath = buildPath(fullPath(), param);
    return readCgroupValue(filePath);
  }

  /// Adds a process to this cgroup
  void addProcess(int pid) @trusted {
    auto tasksFile = buildPath(fullPath(), "tasks");
    writeCgroupValue(tasksFile, to!string(pid));
  }

  /// Gets list of processes in this cgroup
  int[] getProcesses() @trusted {
    auto tasksFile = buildPath(fullPath(), "tasks");
    if (!exists(tasksFile)) {
      return [];
    }
    
    auto content = readText(tasksFile);
    int[] pids;
    foreach (line; content.splitLines()) {
      if (line.strip().length > 0) {
        pids ~= to!int(line.strip());
      }
    }
    return pids;
  }

  /// Sets CPU shares (v1 cpu controller)
  void setCpuShares(ulong shares) @trusted {
    setController("cpu.shares", to!string(shares));
  }

  /// Gets CPU shares
  ulong getCpuShares() @trusted {
    return to!ulong(getController("cpu.shares"));
  }

  /// Sets memory limit (v1 memory controller)
  void setMemoryLimit(ulong bytes) @trusted {
    setController("memory.limit_in_bytes", to!string(bytes));
  }

  /// Gets memory limit
  ulong getMemoryLimit() @trusted {
    return to!ulong(getController("memory.limit_in_bytes"));
  }

  /// Gets current memory usage
  ulong getMemoryUsage() @trusted {
    return to!ulong(getController("memory.usage_in_bytes"));
  }

  /// Sets swap limit
  void setSwapLimit(ulong bytes) @trusted {
    setController("memory.memsw.limit_in_bytes", to!string(bytes));
  }
}

/// Lists available v1 controllers
string[] listV1Controllers(string mountPoint = "/sys/fs/cgroup") @trusted {
  import std.file : dirEntries, DirEntry, SpanMode;
  import std.algorithm : map, filter;
  import std.array : array;
  
  if (!exists(mountPoint)) {
    return [];
  }
  
  string[] controllers;
  foreach (entry; dirEntries(mountPoint, SpanMode.shallow)) {
    if (entry.isDir) {
      auto name = entry.name[(mountPoint.length + 1) .. $];
      if (name != "systemd" && name != "unified") {
        controllers ~= name;
      }
    }
  }
  return controllers;
}
