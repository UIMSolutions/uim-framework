/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.filesystems.temporary;

import std.file;
import std.path;
import std.uuid : randomUUID;
import std.exception : enforce;

@safe:

/// Temporary file that is automatically deleted on destruction
struct TemporaryFile {
    private string _path;
    private bool _autoDelete = true;
    
    @disable this();
    @disable this(this); // Disable copying
    
    /// Create temporary file with optional prefix and suffix
    this(string prefix, string suffix = "", bool autoDelete = true) @trusted {
        _autoDelete = autoDelete;
        auto tempDir = std.file.tempDir();
        auto uuid = randomUUID().toString();
        _path = buildPath(tempDir, prefix ~ "-" ~ uuid ~ suffix);
        
        // Create empty file
        std.file.write(_path, "");
    }
    
    /// Destructor - delete file if auto-delete is enabled
    ~this() @trusted {
        if (_autoDelete && _path.length > 0 && exists(_path)) {
            try {
                remove(_path);
            } catch (Exception) {
                // Ignore errors during cleanup
            }
        }
    }
    
    /// Get file path
    string path() const @safe {
        return _path;
    }
    
    /// Disable auto-deletion
    void keep() @safe {
        _autoDelete = false;
    }
    
    /// Write content to file
    void write(string content) @trusted {
        std.file.write(_path, content);
    }
    
    /// Write bytes to file
    void write(const ubyte[] data) @trusted {
        std.file.write(_path, data);
    }
    
    /// Read content from file
    string readText() @trusted {
        return cast(string) read(_path);
    }
    
    /// Read bytes from file
    ubyte[] readBytes() @trusted {
        return cast(ubyte[]) read(_path);
    }
}

/// Temporary directory that is automatically deleted on destruction
struct TemporaryDirectory {
    private string _path;
    private bool _autoDelete = true;
    
    @disable this();
    @disable this(this); // Disable copying
    
    /// Create temporary directory with optional prefix
    this(string prefix, bool autoDelete = true) @trusted {
        _autoDelete = autoDelete;
        auto tempDir = std.file.tempDir();
        auto uuid = randomUUID().toString();
        _path = buildPath(tempDir, prefix ~ "-" ~ uuid);
        
        mkdirRecurse(_path);
    }
    
    /// Destructor - delete directory if auto-delete is enabled
    ~this() @trusted {
        if (_autoDelete && _path.length > 0 && exists(_path)) {
            try {
                rmdirRecurse(_path);
            } catch (Exception) {
                // Ignore errors during cleanup
            }
        }
    }
    
    /// Get directory path
    string path() const @safe {
        return _path;
    }
    
    /// Disable auto-deletion
    void keep() @safe {
        _autoDelete = false;
    }
    
    /// Create file in temporary directory
    string createFile(string name) @trusted {
        auto filePath = buildPath(_path, name);
        write(filePath, "");
        return filePath;
    }
    
    /// Create subdirectory in temporary directory
    string createDirectory(string name) @trusted {
        auto dirPath = buildPath(_path, name);
        mkdirRecurse(dirPath);
        return dirPath;
    }
}

/// Create temporary file with content
string createTemporaryFile(string content, string prefix = "tmp", string suffix = "") @trusted {
    auto tempDir = std.file.tempDir();
    auto uuid = randomUUID().toString();
    auto path = buildPath(tempDir, prefix ~ "-" ~ uuid ~ suffix);
    
    write(path, content);
    return path;
}

/// Create temporary directory
string createTemporaryDirectory(string prefix = "tmpdir") @trusted {
    auto tempDir = std.file.tempDir();
    auto uuid = randomUUID().toString();
    auto path = buildPath(tempDir, prefix ~ "-" ~ uuid);
    
    mkdirRecurse(path);
    return path;
}

/// Get system temporary directory
string getTemporaryDirectory() @trusted {
    return std.file.tempDir();
}

unittest {
    import std.stdio : writeln;
    
    // Test temporary file
    {
        auto tf = TemporaryFile("test", ".txt");
        auto path = tf.path();
        assert(exists(path));
        
        tf.write("Hello World");
        assert(tf.readText() == "Hello World");
    }
    // File should be deleted after scope
    
    // Test temporary directory
    {
        auto td = TemporaryDirectory("testdir");
        auto path = td.path();
        assert(exists(path));
        assert(isDir(path));
        
        auto file = td.createFile("test.txt");
        assert(exists(file));
    }
    // Directory should be deleted after scope
}
