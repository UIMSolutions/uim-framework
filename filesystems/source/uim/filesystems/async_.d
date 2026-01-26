/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.filesystems.async_;

import vibe.core.file;
import vibe.core.stream;
import vibe.core.path : NativePath;
import std.exception : enforce;

@safe:

/// Read file asynchronously
auto readFileAsync(string path) @safe {
    return readFile(NativePath(path));
}

/// Write file asynchronously
void writeFileAsync(string path, const(ubyte)[] data) @safe {
    writeFile(NativePath(path), data);
}

/// Append to file asynchronously
void appendFileAsync(string path, const(ubyte)[] data) @safe {
    appendToFile(NativePath(path), data);
}

/// Copy file asynchronously
void copyFileAsync(string source, string dest) @safe {
    copyFile(NativePath(source), NativePath(dest));
}

/// Move file asynchronously
void moveFileAsync(string source, string dest) @safe {
    moveFile(NativePath(source), NativePath(dest));
}

/// Delete file asynchronously
void deleteFileAsync(string path) @safe {
    removeFile(NativePath(path));
}

/// Check if file exists asynchronously
bool existsFileAsync(string path) @safe nothrow {
    try {
        return existsFile(NativePath(path));
    } catch (Exception) {
        return false;
    }
}

/// Get file info asynchronously
auto getFileInfoAsync(string path) @safe {
    return getFileInfo(NativePath(path));
}

/// Open file stream for reading
auto openFileRead(string path) @safe {
    return openFile(NativePath(path), FileMode.read);
}

/// Open file stream for writing
auto openFileWrite(string path) @safe {
    return openFile(NativePath(path), FileMode.createTrunc);
}

/// Open file stream for appending
auto openFileAppend(string path) @safe {
    return openFile(NativePath(path), FileMode.append);
}

/// Read file stream asynchronously with callback
void readFileStream(string path, void delegate(scope InputStream stream) @safe callback) @safe {
    auto stream = openFileRead(path);
    scope(exit) stream.close();
    callback(stream);
}

/// Write file stream asynchronously with callback
void writeFileStream(string path, void delegate(scope OutputStream stream) @safe callback) @safe {
    auto stream = openFileWrite(path);
    scope(exit) stream.close();
    callback(stream);
}

/// Read text file asynchronously
string readTextAsync(string path) @safe {
    auto data = readFileAsync(path);
    return cast(string) data;
}

/// Write text file asynchronously
void writeTextAsync(string path, string content) @safe {
    writeFileAsync(path, cast(const(ubyte)[]) content);
}

/// Wrapper for async file operations with error handling
struct AsyncFile {
    private NativePath _path;
    
    this(string path) @safe {
        _path = NativePath(path);
    }
    
    /// Read entire file
    ubyte[] read() @safe {
        return readFile(_path);
    }
    
    /// Read file as text
    string readText() @safe {
        return cast(string) readFile(_path);
    }
    
    /// Write data to file
    void write(const(ubyte)[] data) @safe {
        writeFile(_path, data);
    }
    
    /// Write text to file
    void writeText(string content) @safe {
        writeFile(_path, cast(const(ubyte)[]) content);
    }
    
    /// Append data to file
    void append(const(ubyte)[] data) @safe {
        appendToFile(_path, data);
    }
    
    /// Copy to destination
    void copyTo(string dest) @safe {
        copyFile(_path, NativePath(dest));
    }
    
    /// Move to destination
    void moveTo(string dest) @safe {
        moveFile(_path, NativePath(dest));
    }
    
    /// Delete file
    void remove() @safe {
        removeFile(_path);
    }
    
    /// Check if exists
    bool exists() @safe nothrow {
        try {
            return existsFile(_path);
        } catch (Exception) {
            return false;
        }
    }
    
    /// Get file info
    auto info() @safe {
        return getFileInfo(_path);
    }
}

/// Create async file handle
AsyncFile asyncFile(string path) @safe {
    return AsyncFile(path);
}

// Note: Unittests for async operations would require vibe.d event loop
// They are omitted here but would be similar to sync operations
