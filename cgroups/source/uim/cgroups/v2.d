/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.cgroups.v2;

import std.algorithm : startsWith, map, filter, splitter;
import std.array : array, split;
import std.conv : to, parse;
import std.exception : enforce;
import std.file : exists, readText;
import std.path : buildPath;
import std.string : strip, splitLines, indexOf;

import uim.cgroups.common;

@safe:

/// Cgroups v2 management (unified hierarchy)
class CgroupV2 {
  private string path;
  private string mountPoint;

  /// Creates a cgroup v2 handle
  this(string path, string mountPoint = "/sys/fs/cgroup") @safe {
    this.path = path;
    this.mountPoint = mountPoint;
  }

  /// Gets the full path to the cgroup
  string fullPath() const @safe {
    if (path.startsWith(mountPoint)) {
      return path;
    }
    return buildPath(mountPoint, path);
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

  /// Reads a cgroup file
  string readFile(string filename) @trusted {
    auto filePath = buildPath(fullPath(), filename);
    return readCgroupValue(filePath);
  }

  /// Writes to a cgroup file
  void writeFile(string filename, string value) @trusted {
    auto filePath = buildPath(fullPath(), filename);
    writeCgroupValue(filePath, value);
  }

  /// Adds a process to this cgroup
  void addProcess(int pid) @trusted {
    writeFile("cgroup.procs", to!string(pid));
  }

  /// Gets list of processes in this cgroup
  int[] getProcesses() @trusted {
    auto procsFile = buildPath(fullPath(), "cgroup.procs");
    if (!exists(procsFile)) {
      return [];
    }
    
    auto content = readText(procsFile);
    int[] pids;
    foreach (line; content.splitLines()) {
      if (line.strip().length > 0) {
        pids ~= to!int(line.strip());
      }
    }
    return pids;
  }

  /// Sets CPU weight (100-10000, default 100)
  void setCpuWeight(ulong weight) @trusted {
    enforce(weight >= 1 && weight <= 10000, "CPU weight must be between 1 and 10000");
    writeFile("cpu.weight", to!string(weight));
  }

  /// Gets CPU weight
  ulong getCpuWeight() @trusted {
    return to!ulong(readFile("cpu.weight"));
  }

  /// Sets CPU max (quota and period in microseconds)
  void setCpuMax(ulong quotaUsec, ulong periodUsec = 100_000) @trusted {
    writeFile("cpu.max", to!string(quotaUsec) ~ " " ~ to!string(periodUsec));
  }

  /// Gets CPU statistics
  CpuStat getCpuStat() @trusted {
    auto content = readFile("cpu.stat");
    CpuStat stat;
    
    foreach (line; content.splitLines()) {
      auto parts = line.split();
      if (parts.length < 2) continue;
      
      auto key = parts[0];
      auto value = to!ulong(parts[1]);
      
      if (key == "usage_usec") stat.usageUsec = value;
      else if (key == "user_usec") stat.userUsec = value;
      else if (key == "system_usec") stat.systemUsec = value;
      else if (key == "nr_periods") stat.nrPeriods = value;
      else if (key == "nr_throttled") stat.nrThrottled = value;
      else if (key == "throttled_usec") stat.throttledUsec = value;
    }
    return stat;
  }

  /// Sets memory max limit
  void setMemoryMax(ulong bytes) @trusted {
    writeFile("memory.max", to!string(bytes));
  }

  /// Gets memory max limit
  ulong getMemoryMax() @trusted {
    auto value = readFile("memory.max");
    if (value == "max") {
      return ulong.max;
    }
    return to!ulong(value);
  }

  /// Sets memory high limit (soft limit)
  void setMemoryHigh(ulong bytes) @trusted {
    writeFile("memory.high", to!string(bytes));
  }

  /// Gets current memory usage
  ulong getMemoryCurrent() @trusted {
    return to!ulong(readFile("memory.current"));
  }

  /// Gets memory statistics
  MemoryStat getMemoryStat() @trusted {
    MemoryStat stat;
    stat.current = getMemoryCurrent();
    
    auto peakFile = buildPath(fullPath(), "memory.peak");
    if (exists(peakFile)) {
      stat.peak = to!ulong(readFile("memory.peak"));
    }
    
    auto maxFile = buildPath(fullPath(), "memory.max");
    if (exists(maxFile)) {
      auto maxVal = readFile("memory.max");
      stat.max = (maxVal == "max") ? ulong.max : to!ulong(maxVal);
    }
    
    auto highFile = buildPath(fullPath(), "memory.high");
    if (exists(highFile)) {
      auto highVal = readFile("memory.high");
      stat.high = (highVal == "max") ? ulong.max : to!ulong(highVal);
    }
    
    auto swapCurFile = buildPath(fullPath(), "memory.swap.current");
    if (exists(swapCurFile)) {
      stat.swapCurrent = to!ulong(readFile("memory.swap.current"));
    }
    
    return stat;
  }

  /// Sets I/O weight (1-10000, default 100)
  void setIoWeight(ulong weight) @trusted {
    enforce(weight >= 1 && weight <= 10000, "I/O weight must be between 1 and 10000");
    writeFile("io.weight", to!string(weight));
  }

  /// Sets PID limit
  void setPidsMax(ulong max) @trusted {
    writeFile("pids.max", to!string(max));
  }

  /// Gets current number of PIDs
  ulong getPidsCurrent() @trusted {
    return to!ulong(readFile("pids.current"));
  }

  /// Gets available controllers
  string[] getControllers() @trusted {
    auto content = readFile("cgroup.controllers");
    return content.split();
  }

  /// Enables controllers for children
  void enableControllers(string[] controllers) @trusted {
    foreach (controller; controllers) {
      auto current = readFile("cgroup.subtree_control");
      if (current.indexOf(controller) == -1) {
        writeFile("cgroup.subtree_control", "+" ~ controller);
      }
    }
  }

  /// Disables controllers for children
  void disableControllers(string[] controllers) @trusted {
    foreach (controller; controllers) {
      writeFile("cgroup.subtree_control", "-" ~ controller);
    }
  }
}

/// Gets the root cgroup v2 instance
CgroupV2 rootCgroup(string mountPoint = "/sys/fs/cgroup") @safe {
  return new CgroupV2(mountPoint, mountPoint);
}
