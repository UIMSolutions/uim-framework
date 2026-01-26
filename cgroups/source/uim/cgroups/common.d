/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.cgroups.common;

import std.exception : enforce;
import std.file : exists, isDir, readText;
import std.string : strip;

@safe:

/// Cgroup version enumeration
enum CgroupVersion {
  V1,       // Legacy cgroups with per-controller hierarchies
  V2,       // Unified cgroups hierarchy
  Hybrid,   // Mixed v1 and v2
  Unknown
}

/// Detects which cgroup version is in use
CgroupVersion detectCgroupVersion() @trusted {
  // Check if cgroup v2 is mounted
  if (exists("/sys/fs/cgroup/cgroup.controllers")) {
    // Check if any v1 controllers exist
    if (exists("/sys/fs/cgroup/cpu") || exists("/sys/fs/cgroup/memory")) {
      return CgroupVersion.Hybrid;
    }
    return CgroupVersion.V2;
  }
  
  // Check for v1 mount points
  if (exists("/sys/fs/cgroup/cpu") || exists("/sys/fs/cgroup/memory")) {
    return CgroupVersion.V1;
  }
  
  return CgroupVersion.Unknown;
}

/// Base cgroup exception
class CgroupException : Exception {
  this(string msg, string file = __FILE__, size_t line = __LINE__) @safe pure nothrow {
    super(msg, file, line);
  }
}

/// CPU statistics structure
struct CpuStat {
  ulong usageUsec;    // Total CPU time in microseconds
  ulong userUsec;     // User mode time in microseconds
  ulong systemUsec;   // System mode time in microseconds
  ulong nrPeriods;    // Number of enforcement periods
  ulong nrThrottled;  // Number of throttled periods
  ulong throttledUsec; // Total throttled time in microseconds
}

/// Memory statistics structure
struct MemoryStat {
  ulong current;      // Current memory usage
  ulong peak;         // Peak memory usage
  ulong high;         // High memory limit
  ulong max;          // Maximum memory limit
  ulong swapCurrent;  // Current swap usage
  ulong swapPeak;     // Peak swap usage
}

/// I/O statistics structure
struct IoStat {
  ulong rbytes;       // Read bytes
  ulong wbytes;       // Write bytes
  ulong rios;         // Read I/O operations
  ulong wios;         // Write I/O operations
}

/// Reads a single-line value from a cgroup file
string readCgroupValue(string path) @trusted {
  enforce(exists(path), "Cgroup file does not exist: " ~ path);
  return readText(path).strip();
}

/// Writes a value to a cgroup file
void writeCgroupValue(string path, string value) @trusted {
  import std.stdio : File;
  enforce(exists(path), "Cgroup file does not exist: " ~ path);
  auto f = File(path, "w");
  f.write(value);
  f.close();
}

/// Checks if a cgroup path exists
bool cgroupExists(string path) @trusted {
  return exists(path) && isDir(path);
}

/// Creates a cgroup directory
void createCgroup(string path) @trusted {
  import std.file : mkdirRecurse;
  if (!cgroupExists(path)) {
    mkdirRecurse(path);
  }
}

/// Removes a cgroup directory
void removeCgroup(string path) @trusted {
  import std.file : rmdir;
  if (cgroupExists(path)) {
    rmdir(path);
  }
}
