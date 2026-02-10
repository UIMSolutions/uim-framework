/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.filesystems.async_;

import uim.filesystems;

@safe:

/// Read file asynchronously
auto readFileAsync(string path) {
    return readFile(NativePath(path));
}

/// Write file asynchronously
void writeFileAsync(string path, const(ubyte)[] data) {
    writeFile(NativePath(path), data);
}

/// Append to file asynchronously
void appendFileAsync(string path, const(ubyte)[] data) @trusted {
    auto dataStr = cast(string) data;
    vibe.core.file.appendToFile(NativePath(path), dataStr);
}

/// Copy file asynchronously
void copyFileAsync(string source, string dest) {
    copyFile(NativePath(source), NativePath(dest));
}

/// Move file asynchronously
void moveFileAsync(string source, string dest) {
    moveFile(NativePath(source), NativePath(dest));
}

/// Delete file asynchronously
void deleteFileAsync(string path) {
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
auto getFileInfoAsync(string path) {
    return getFileInfo(NativePath(path));
}

/// Open file stream for reading
auto openFileRead(string path) {
    return openFile(NativePath(path), FileMode.read);
}

/// Open file stream for writing
auto openFileWrite(string path) {
    return openFile(NativePath(path), FileMode.createTrunc);
}

/// Open file stream for appending
auto openFileAppend(string path) {
    return openFile(NativePath(path), FileMode.append);
}

/// Read file stream asynchronously with callback
void readFileStream(string path, void delegate(scope FileStream stream) @safe callback) {
    auto stream = openFileRead(path);
    scope(exit) stream.close();
    callback(stream);
}

/// Write file stream asynchronously with callback
void writeFileStream(string path, void delegate(scope FileStream stream) @safe callback) {
    auto stream = openFileWrite(path);
    scope(exit) stream.close();
    callback(stream);
}

/// Read text file asynchronously
string readTextAsync(string path) @trusted {
    auto data = readFileAsync(path);
    return cast(string) data;
}

/// Write text file asynchronously
void writeTextAsync(string path, string content) {
    writeFileAsync(path, cast(const(ubyte)[]) content);
}

/// Wrapper for async file operations with error handling
struct AsyncFile {
    private NativePath _path;
    
    this(string path) {
        _path = NativePath(path);
    }
    
    /// Read entire file
    ubyte[] read() {
        return readFile(_path);
    }
    
    /// Read file as text
    string readText() @trusted {
        return cast(string) readFile(_path);
    }
    
    /// Write data to file
    void write(const(ubyte)[] data) {
        writeFile(_path, data);
    }
    
    /// Write text to file
    void writeText(string content) {
        writeFile(_path, cast(const(ubyte)[]) content);
    }
    
    /// Append data to file
    void append(const(ubyte)[] data) @trusted {
        auto dataStr = cast(string) data;
        vibe.core.file.appendToFile(_path, dataStr);
    }
    
    /// Copy to destination
    void copyTo(string dest) {
        copyFile(_path, NativePath(dest));
    }
    
    /// Move to destination
    void moveTo(string dest) {
        moveFile(_path, NativePath(dest));
    }
    
    /// Delete file
    void remove() {
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
    auto info() {
        return getFileInfo(_path);
    }
}

/// Create async file handle
AsyncFile asyncFile(string path) {
    return AsyncFile(path);
}

// Note: Unittests for async operations would require vibe.d event loop
// They are omitted here but would be similar to sync operations
