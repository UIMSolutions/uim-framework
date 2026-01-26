# UIM CGroups - Linux Control Groups Management for D

A D library for managing Linux Control Groups (cgroups) v1 and v2. Monitor and control resource allocation for processes including CPU, memory, I/O, and network.

## Features
- Support for cgroups v1 and v2
- CPU resource management (shares, quota, period)
- Memory limits and statistics
- Block I/O throttling
- PID limits and tracking
- Hierarchical cgroup management
- Process assignment to cgroups

## Quick Start

### Detect cgroup version
```d
import uim.cgroups;

auto version_ = detectCgroupVersion();
writeln("System uses: ", version_);
```

### Create and configure a cgroup (v2)
```d
import uim.cgroups;

auto cg = CgroupV2("/sys/fs/cgroup/myapp");
cg.create();
cg.setMemoryMax(512 * 1024 * 1024);  // 512 MB
cg.setCpuWeight(200);  // Higher priority
cg.addProcess(getpid());
```

### Read memory statistics
```d
import uim.cgroups;

auto cg = CgroupV2("/sys/fs/cgroup/myapp");
auto memStats = cg.getMemoryStat();
writefln("Current: %d, Peak: %d", memStats.current, memStats.peak);
```

### Monitor CPU usage
```d
import uim.cgroups;

auto cg = CgroupV2("/sys/fs/cgroup/myapp");
auto cpuStats = cg.getCpuStat();
writefln("User: %d µs, System: %d µs", cpuStats.usageUsec, cpuStats.systemUsec);
```

### List processes in a cgroup
```d
import uim.cgroups;

auto cg = CgroupV2("/sys/fs/cgroup/myapp");
auto pids = cg.getProcesses();
foreach (pid; pids) {
  writeln("PID: ", pid);
}
```

### Cgroups v1 support
```d
import uim.cgroups;

auto cg = CgroupV1("cpu", "/myapp");
cg.create();
cg.setController("cpu.shares", "1024");
cg.addProcess(getpid());
```

## Modules
- `uim.cgroups.common` – Common types and detection
- `uim.cgroups.v1` – Cgroups v1 implementation
- `uim.cgroups.v2` – Cgroups v2 (unified hierarchy) implementation
- `uim.cgroups.helpers` – Utility functions for parsing and formatting

## Notes
- Requires Linux with cgroups support
- May require root privileges for certain operations
- Cgroups v2 requires kernel 4.5+ and systemd 226+
- Always check if cgroup exists before operations
