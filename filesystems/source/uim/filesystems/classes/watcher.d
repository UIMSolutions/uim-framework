/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.filesystems.classes.watcher;

import uim.filesystems;

@safe:

/// File system event types
enum FileSystemEvent {
    Created,
    Modified,
    Deleted,
    Renamed,
    Unknown
}

interface IFileSystemWatcher {
    void onEvent(WatchCallback callback) @safe;
    void start() @trusted;
    void stop() @safe;
    bool isRunning() const @safe;
}

/// File system change notification
struct FileSystemChange {
    string path;
    FileSystemEvent event;
    SysTime timestamp;
}

/// File system watcher callback
alias WatchCallback = void delegate(FileSystemChange change) @safe;

/// Simple polling-based file system watcher
class FileSystemWatcher : IFileSystemWatcher {
    private string _path;
    private bool _recursive;
    private WatchCallback _callback;
    private bool _running;
    private SysTime[string] _lastModified;
    
    /// Create watcher for path
    this(string path, bool recursive = false) @safe {
        enforce(exists(path), "Path does not exist: " ~ path);
        _path = path;
        _recursive = recursive;
        _running = false;
    }
    
    /// Set callback for file system events
    void onEvent(WatchCallback callback) @safe {
        _callback = callback;
    }
    
    /// Start watching (polling-based)
    void start() @trusted {
        import core.thread : Thread;
        import core.time : msecs;
        
        _running = true;
        
        // Initial scan
        updateFileList();
        
        // Polling loop (simplified - would use OS-specific APIs in production)
        while (_running) {
            checkForChanges();
            Thread.sleep(msecs(1000)); // Poll every second
        }
    }
    
    /// Stop watching
    void stop() @safe {
        _running = false;
    }
    
    /// Check if watching is active
    bool isRunning() const @safe {
        return _running;
    }
    
    private void updateFileList() @trusted {
        _lastModified.clear();
        
        if (isFile(_path)) {
            _lastModified[_path] = timeLastModified(_path);
        } else if (isDir(_path)) {
            auto spanMode = _recursive ? SpanMode.breadth : SpanMode.shallow;
            foreach (entry; dirEntries(_path, spanMode)) {
                if (entry.isFile) {
                    _lastModified[entry.name] = entry.timeLastModified;
                }
            }
        }
    }
    
    private void checkForChanges() @trusted {
        if (!_callback) return;
        
        SysTime[string] currentFiles;
        
        if (isFile(_path)) {
            if (exists(_path)) {
                currentFiles[_path] = timeLastModified(_path);
            }
        } else if (isDir(_path)) {
            auto spanMode = _recursive ? SpanMode.breadth : SpanMode.shallow;
            foreach (entry; dirEntries(_path, spanMode)) {
                if (entry.isFile) {
                    currentFiles[entry.name] = entry.timeLastModified;
                }
            }
        }
        
        import std.datetime : Clock;
        auto now = Clock.currTime();
        
        // Check for new or modified files
        foreach (path, modTime; currentFiles) {
            if (path !in _lastModified) {
                // New file
                FileSystemChange change;
                change.path = path;
                change.event = FileSystemEvent.Created;
                change.timestamp = now;
                _callback(change);
            } else if (_lastModified[path] != modTime) {
                // Modified file
                FileSystemChange change;
                change.path = path;
                change.event = FileSystemEvent.Modified;
                change.timestamp = now;
                _callback(change);
            }
        }
        
        // Check for deleted files
        foreach (path, modTime; _lastModified) {
            if (path !in currentFiles) {
                FileSystemChange change;
                change.path = path;
                change.event = FileSystemEvent.Deleted;
                change.timestamp = now;
                _callback(change);
            }
        }
        
        _lastModified = currentFiles;
    }
}

/// Create file system watcher
FileSystemWatcher createWatcher(string path, bool recursive = false) @safe {
    return new FileSystemWatcher(path, recursive);
}

unittest {
    import std.path : buildPath;
    import std.file : tempDir, exists, rmdirRecurse;
    import std.uuid : randomUUID;
    import core.thread : Thread;
    import core.time : msecs;
    
    auto testDir = buildPath(tempDir(), "watcher-test-" ~ randomUUID().toString());
    scope(exit) {
        if (exists(testDir)) {
            rmdirRecurse(testDir);
        }
    }
    
    mkdirRecurse(testDir);
    
    bool eventReceived = false;
    
    auto watcher = createWatcher(testDir, false);
    watcher.onEvent((change) @trusted {
        eventReceived = true;
    });
    
    // Note: Full testing would require threading
    // This is a basic structure test
    assert(!watcher.isRunning());
}
