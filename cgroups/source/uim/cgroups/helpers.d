/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.cgroups.helpers;

import std.algorithm : map, filter, splitter, startsWith;
import std.array : array, split;
import std.conv : to;
import std.file : exists, readText, dirEntries, SpanMode;
import std.format : format;
import std.path : buildPath;
import std.string : strip, splitLines, indexOf;

import uim.cgroups.common;

@safe:

/// Formats bytes to human-readable string
string formatBytes(ulong bytes) @safe {
  if (bytes == ulong.max) {
    return "unlimited";
  }
  
  immutable units = ["B", "KB", "MB", "GB", "TB"];
  double value = bytes;
  size_t unitIdx = 0;
  
  while (value >= 1024.0 && unitIdx < units.length - 1) {
    value /= 1024.0;
    unitIdx++;
  }
  
  return format("%.2f %s", value, units[unitIdx]);
}

/// Parses bytes from human-readable string (e.g., "1.5G", "512M")
ulong parseBytes(string str) @safe {
  str = str.strip();
  
  if (str == "max" || str == "unlimited") {
    return ulong.max;
  }
  
  // Extract number and unit
  size_t numEnd = 0;
  while (numEnd < str.length && (str[numEnd] >= '0' && str[numEnd] <= '9' || str[numEnd] == '.')) {
    numEnd++;
  }
  
  if (numEnd == 0) {
    return 0;
  }
  
  auto numStr = str[0..numEnd];
  auto unit = str[numEnd..$].strip().toLower();
  
  double value = to!double(numStr);
  
  switch (unit) {
    case "k", "kb":
      return cast(ulong)(value * 1024);
    case "m", "mb":
      return cast(ulong)(value * 1024 * 1024);
    case "g", "gb":
      return cast(ulong)(value * 1024 * 1024 * 1024);
    case "t", "tb":
      return cast(ulong)(value * 1024 * 1024 * 1024 * 1024);
    case "b", "":
      return cast(ulong)value;
    default:
      return cast(ulong)value;
  }
}

/// Parses CPU stat from content
CpuStat parseCpuStat(string content) @safe {
  CpuStat stat;
  
  foreach (line; content.splitLines()) {
    auto parts = line.split();
    if (parts.length < 2) continue;
    
    auto key = parts[0];
    
    try {
      auto value = to!ulong(parts[1]);
      
      if (key == "usage_usec" || key == "usage") {
        stat.usageUsec = value;
      } else if (key == "user_usec" || key == "user") {
        stat.userUsec = value;
      } else if (key == "system_usec" || key == "system") {
        stat.systemUsec = value;
      } else if (key == "nr_periods") {
        stat.nrPeriods = value;
      } else if (key == "nr_throttled") {
        stat.nrThrottled = value;
      } else if (key == "throttled_usec" || key == "throttled_time") {
        stat.throttledUsec = value;
      }
    } catch (Exception e) {
      // Skip invalid lines
    }
  }
  
  return stat;
}

/// Parses memory stat from content
MemoryStat parseMemoryStat(string content) @safe {
  MemoryStat stat;
  
  foreach (line; content.splitLines()) {
    auto parts = line.split();
    if (parts.length < 2) continue;
    
    auto key = parts[0];
    
    try {
      if (parts[1] == "max") {
        continue;
      }
      
      auto value = to!ulong(parts[1]);
      
      if (key == "current" || key == "usage_in_bytes") {
        stat.current = value;
      } else if (key == "max" || key == "limit_in_bytes") {
        stat.max = value;
      } else if (key == "high") {
        stat.high = value;
      } else if (key == "peak" || key == "max_usage_in_bytes") {
        stat.peak = value;
      } else if (key == "swap.current" || key == "memsw.usage_in_bytes") {
        stat.swapCurrent = value;
      }
    } catch (Exception e) {
      // Skip invalid lines
    }
  }
  
  return stat;
}

/// Parses I/O stat from content
IoStat parseIoStat(string content) @safe {
  IoStat stat;
  
  foreach (line; content.splitLines()) {
    auto parts = line.split();
    if (parts.length < 2) continue;
    
    auto device = parts[0];
    
    foreach (part; parts[1..$]) {
      auto kv = part.split("=");
      if (kv.length != 2) continue;
      
      auto key = kv[0];
      
      try {
        auto value = to!ulong(kv[1]);
        
        if (key == "rbytes") {
          stat.readBytes = value;
        } else if (key == "wbytes") {
          stat.writeBytes = value;
        } else if (key == "rios") {
          stat.readOps = value;
        } else if (key == "wios") {
          stat.writeOps = value;
        }
      } catch (Exception e) {
        // Skip invalid values
      }
    }
  }
  
  return stat;
}

/// Gets the cgroup path for a process
string getProcessCgroup(int pid) @trusted {
  auto cgroupFile = buildPath("/proc", to!string(pid), "cgroup");
  if (!exists(cgroupFile)) {
    return "";
  }
  
  auto content = readText(cgroupFile);
  foreach (line; content.splitLines()) {
    // Format: hierarchy-ID:controller-list:cgroup-path
    auto parts = line.split(":");
    if (parts.length >= 3) {
      // For v2, hierarchy ID is 0 and controller-list is empty
      if (parts[0] == "0" && parts[1] == "") {
        return parts[2];
      }
    }
  }
  
  return "";
}

/// Lists all cgroups under a path
string[] listCgroups(string path = "/sys/fs/cgroup", bool recursive = true) @trusted {
  string[] cgroups;
  
  if (!exists(path)) {
    return cgroups;
  }
  
  auto mode = recursive ? SpanMode.breadth : SpanMode.shallow;
  
  foreach (entry; dirEntries(path, mode)) {
    if (entry.isDir) {
      cgroups ~= entry.name;
    }
  }
  
  return cgroups;
}

/// Gets the current process's cgroup
string getCurrentCgroup() @trusted {
  import core.sys.posix.unistd : getpid;
  return getProcessCgroup(getpid());
}

/// Formats microseconds to human-readable time
string formatMicroseconds(ulong usec) @safe {
  if (usec < 1000) {
    return format("%d µs", usec);
  } else if (usec < 1_000_000) {
    return format("%.2f ms", usec / 1000.0);
  } else if (usec < 60_000_000) {
    return format("%.2f s", usec / 1_000_000.0);
  } else if (usec < 3_600_000_000) {
    return format("%.2f m", usec / 60_000_000.0);
  } else {
    return format("%.2f h", usec / 3_600_000_000.0);
  }
}

/// Converts CPU shares (v1) to CPU weight (v2)
ulong sharesToWeight(ulong shares) @safe {
  // v1 default: 1024, v2 default: 100
  // v1 range: 2-262144, v2 range: 1-10000
  if (shares < 2) shares = 2;
  if (shares > 262144) shares = 262144;
  
  // Linear conversion
  return cast(ulong)(1 + (shares - 2) * 9999.0 / 262142.0);
}

/// Converts CPU weight (v2) to CPU shares (v1)
ulong weightToShares(ulong weight) @safe {
  // v2 default: 100, v1 default: 1024
  // v2 range: 1-10000, v1 range: 2-262144
  if (weight < 1) weight = 1;
  if (weight > 10000) weight = 10000;
  
  // Linear conversion
  return cast(ulong)(2 + (weight - 1) * 262142.0 / 9999.0);
}

private:

import std.uni : toLower;
