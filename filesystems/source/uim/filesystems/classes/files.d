/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.filesystems.classes.files;

import std.file;
import std.stdio : File;
import std.string : strip;
import std.path : baseName, dirName, extension;
import std.array : array;
import std.algorithm : filter;
import std.exception : enforce;

@safe:

/// File operation options
struct FileOptions {
    bool createParentDirs = true;
    bool overwrite = false;
    bool backup = false;
    string backupSuffix = ".bak";
}

/// Progress callback type
alias ProgressCallback = void delegate(double progress) @safe;

/// Read entire file as text
string readFileText(string path) @trusted {
    enforce(exists(path), "File does not exist: " ~ path);
    return cast(string) read(path);
}

/// Read entire file as bytes
ubyte[] readFileBytes(string path) @trusted {
    enforce(exists(path), "File does not exist: " ~ path);
    return cast(ubyte[]) read(path);
}

/// Read file line by line
string[] readFileLines(string path) @trusted {
    enforce(exists(path), "File does not exist: " ~ path);
    
    string[] lines;
    auto f = File(path, "r");
    scope(exit) f.close();
    
    foreach (line; f.byLine()) {
        lines ~= line.idup;
    }
    return lines;
}

/// Write text to file
void writeFileText(string path, string content, FileOptions options = FileOptions.init) @trusted {
    if (options.createParentDirs) {
        ensureParentDirectory(path);
    }
    
    if (!options.overwrite && exists(path)) {
        throw new Exception("File already exists: " ~ path);
    }
    
    if (options.backup && exists(path)) {
        copyFile(path, path ~ options.backupSuffix);
    }
    
    write(path, content);
}

/// Write bytes to file
void writeFileBytes(string path, const ubyte[] data, FileOptions options = FileOptions.init) @trusted {
    if (options.createParentDirs) {
        ensureParentDirectory(path);
    }
    
    if (!options.overwrite && exists(path)) {
        throw new Exception("File already exists: " ~ path);
    }
    
    if (options.backup && exists(path)) {
        copyFile(path, path ~ options.backupSuffix);
    }
    
    write(path, data);
}

/// Append text to file
void appendFileText(string path, string content, FileOptions options = FileOptions.init) @trusted {
    if (options.createParentDirs) {
        ensureParentDirectory(path);
    }
    
    std.file.append(path, content);
}

/// Copy file from source to destination
void copyFile(string source, string dest, ProgressCallback onProgress = null) @trusted {
    enforce(exists(source), "Source file does not exist: " ~ source);
    
    ensureParentDirectory(dest);
    
    if (onProgress) {
        // Copy with progress tracking
        auto sourceFile = File(source, "rb");
        auto destFile = File(dest, "wb");
        scope(exit) {
            sourceFile.close();
            destFile.close();
        }
        
        auto totalSize = sourceFile.size();
        ulong bytesCopied = 0;
        ubyte[4096] buffer;
        
        while (!sourceFile.eof()) {
            auto chunk = sourceFile.rawRead(buffer[]);
            if (chunk.length > 0) {
                destFile.rawWrite(chunk);
                bytesCopied += chunk.length;
                onProgress(cast(double)bytesCopied / totalSize);
            }
        }
    } else {
        // Simple copy
        std.file.copy(source, dest);
    }
}

/// Move/rename file
void moveFile(string source, string dest, FileOptions options = FileOptions.init) @trusted {
    enforce(exists(source), "Source file does not exist: " ~ source);
    
    if (!options.overwrite && exists(dest)) {
        throw new Exception("Destination file already exists: " ~ dest);
    }
    
    if (options.backup && exists(dest)) {
        copyFile(dest, dest ~ options.backupSuffix);
    }
    
    ensureParentDirectory(dest);
    rename(source, dest);
}

/// Delete file
void deleteFile(string path, FileOptions options = FileOptions.init) @trusted {
    enforce(exists(path), "File does not exist: " ~ path);
    
    if (options.backup) {
        copyFile(path, path ~ options.backupSuffix);
    }
    
    remove(path);
}

/// Check if file exists
bool fileExists(string path) @trusted nothrow {
    try {
        return exists(path) && isFile(path);
    } catch (Exception) {
        return false;
    }
}

/// Get file size in bytes
ulong fileSize(string path) @trusted {
    enforce(exists(path), "File does not exist: " ~ path);
    return getSize(path);
}

/// Get file extension
string fileExtension(string path) @safe {
    return extension(path);
}

/// Get file name without directory
string fileName(string path) @safe {
    return baseName(path);
}

/// Atomic file write (write to temp, then rename)
void writeFileAtomic(string path, string content) @trusted {
    import std.uuid : randomUUID;
    
    auto tempPath = path ~ "." ~ randomUUID().toString() ~ ".tmp";
    scope(failure) {
        if (exists(tempPath)) {
            remove(tempPath);
        }
    }
    
    write(tempPath, content);
    rename(tempPath, path);
}

/// Create hard link
void createHardLink(string source, string linkPath) @trusted {
    enforce(exists(source), "Source file does not exist: " ~ source);
    version (Posix) {
        import core.sys.posix.unistd : link;
        enforce(link(source.ptr, linkPath.ptr) == 0, "Failed to create hard link");
    } else {
        throw new Exception("Hard links not supported on this platform");
    }
}

/// Create symbolic link
void createSymlink(string target, string link) @trusted {
    std.file.symlink(target, link);
}

/// Read symbolic link target
string readSymlink(string link) @trusted {
    enforce(exists(link), "Symlink does not exist: " ~ link);
    return std.file.readLink(link);
}

/// Check if path is a symbolic link
bool isSymlink(string path) @trusted nothrow {
    try {
        return std.file.isSymlink(path);
    } catch (Exception) {
        return false;
    }
}

// Helper function
private void ensureParentDirectory(string path) @trusted {
    import std.path : dirName;
    auto dir = dirName(path);
    if (dir.length > 0 && !exists(dir)) {
        mkdirRecurse(dir);
    }
}

unittest {
    import std.path : buildPath;
    import std.file : tempDir, exists, rmdirRecurse;
    import std.uuid : randomUUID;
    
    auto testDir = buildPath(tempDir(), "uim-filesystems-test-" ~ randomUUID().toString());
    scope(exit) {
        if (exists(testDir)) {
            rmdirRecurse(testDir);
        }
    }
    
    mkdirRecurse(testDir);
    
    // Test write and read
    auto testFile = buildPath(testDir, "test.txt");
    writeFileText(testFile, "Hello World", FileOptions(true, true));
    assert(readFileText(testFile) == "Hello World");
    
    // Test file exists
    assert(fileExists(testFile));
    
    // Test file size
    assert(fileSize(testFile) > 0);
    
    // Test copy
    auto copyPath = buildPath(testDir, "copy.txt");
    copyFile(testFile, copyPath);
    assert(fileExists(copyPath));
    assert(readFileText(copyPath) == "Hello World");
    
    // Test atomic write
    writeFileAtomic(testFile, "Updated");
    assert(readFileText(testFile) == "Updated");
}
