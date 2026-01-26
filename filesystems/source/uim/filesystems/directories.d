/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.filesystems.directories;

import std.file;
import std.path;
import std.algorithm : filter, map, sort;
import std.array : array;
import std.exception : enforce;
import std.datetime : SysTime;

@safe:

/// Directory entry information
struct DirectoryEntry {
    string name;
    string path;
    ulong size;
    SysTime timeModified;
    bool isDirectory;
    bool isFile;
    bool isSymlink;
}

/// Directory listing options
struct ListOptions {
    bool recursive = false;
    bool includeHidden = false;
    bool followSymlinks = false;
    string pattern = "*";
}

/// Create directory
void createDirectory(string path) @trusted {
    if (!exists(path)) {
        mkdir(path);
    }
}

/// Create directory with all parent directories
void createDirectories(string path) @trusted {
    if (!exists(path)) {
        mkdirRecurse(path);
    }
}

/// Delete empty directory
void deleteDirectory(string path) @trusted {
    enforce(exists(path), "Directory does not exist: " ~ path);
    enforce(isDir(path), "Path is not a directory: " ~ path);
    rmdir(path);
}

/// Delete directory recursively
void deleteDirectoryRecursive(string path) @trusted {
    enforce(exists(path), "Directory does not exist: " ~ path);
    enforce(isDir(path), "Path is not a directory: " ~ path);
    rmdirRecurse(path);
}

/// Check if directory exists
bool directoryExists(string path) @trusted nothrow {
    try {
        return exists(path) && isDir(path);
    } catch (Exception) {
        return false;
    }
}

/// Check if directory is empty
bool isDirectoryEmpty(string path) @trusted {
    enforce(exists(path), "Directory does not exist: " ~ path);
    enforce(isDir(path), "Path is not a directory: " ~ path);
    
    foreach (entry; dirEntries(path, SpanMode.shallow)) {
        return false;
    }
    return true;
}

/// List directory contents
DirectoryEntry[] listDirectory(string path, ListOptions options = ListOptions.init) @trusted {
    enforce(exists(path), "Directory does not exist: " ~ path);
    enforce(isDir(path), "Path is not a directory: " ~ path);
    
    DirectoryEntry[] entries;
    
    auto spanMode = options.recursive ? SpanMode.breadth : SpanMode.shallow;
    
    foreach (entry; dirEntries(path, options.pattern, spanMode, options.followSymlinks)) {
        // Skip hidden files if requested
        if (!options.includeHidden && baseName(entry.name).length > 0 && baseName(entry.name)[0] == '.') {
            continue;
        }
        
        DirectoryEntry de;
        de.name = baseName(entry.name);
        de.path = entry.name;
        de.size = entry.isDir ? 0 : entry.size;
        de.timeModified = entry.timeLastModified;
        de.isDirectory = entry.isDir;
        de.isFile = entry.isFile;
        de.isSymlink = entry.isSymlink;
        
        entries ~= de;
    }
    
    return entries;
}

/// Get all files in directory (recursive)
string[] getFiles(string path, string pattern = "*") @trusted {
    enforce(exists(path), "Directory does not exist: " ~ path);
    
    string[] files;
    foreach (entry; dirEntries(path, pattern, SpanMode.breadth)) {
        if (entry.isFile) {
            files ~= entry.name;
        }
    }
    return files;
}

/// Get all directories in directory (recursive)
string[] getDirectories(string path) @trusted {
    enforce(exists(path), "Directory does not exist: " ~ path);
    
    string[] dirs;
    foreach (entry; dirEntries(path, SpanMode.breadth)) {
        if (entry.isDir) {
            dirs ~= entry.name;
        }
    }
    return dirs;
}

/// Calculate total size of directory
ulong directorySize(string path, bool recursive = true) @trusted {
    enforce(exists(path), "Directory does not exist: " ~ path);
    enforce(isDir(path), "Path is not a directory: " ~ path);
    
    ulong totalSize = 0;
    auto spanMode = recursive ? SpanMode.breadth : SpanMode.shallow;
    
    foreach (entry; dirEntries(path, spanMode)) {
        if (entry.isFile) {
            totalSize += entry.size;
        }
    }
    
    return totalSize;
}

/// Copy directory recursively
void copyDirectory(string source, string dest) @trusted {
    enforce(exists(source), "Source directory does not exist: " ~ source);
    enforce(isDir(source), "Source is not a directory: " ~ source);
    
    if (!exists(dest)) {
        mkdirRecurse(dest);
    }
    
    foreach (entry; dirEntries(source, SpanMode.shallow)) {
        auto destPath = buildPath(dest, baseName(entry.name));
        
        if (entry.isDir) {
            copyDirectory(entry.name, destPath);
        } else {
            std.file.copy(entry.name, destPath);
        }
    }
}

/// Move directory
void moveDirectory(string source, string dest) @trusted {
    enforce(exists(source), "Source directory does not exist: " ~ source);
    enforce(isDir(source), "Source is not a directory: " ~ source);
    
    if (!exists(dirName(dest))) {
        mkdirRecurse(dirName(dest));
    }
    
    rename(source, dest);
}

/// Walk directory tree with callback
void walkDirectory(string path, void delegate(string path, bool isDir) @safe callback) @trusted {
    enforce(exists(path), "Directory does not exist: " ~ path);
    
    foreach (entry; dirEntries(path, SpanMode.breadth)) {
        callback(entry.name, entry.isDir);
    }
}

/// Find files matching predicate
string[] findFiles(string path, bool delegate(string) @safe predicate) @trusted {
    enforce(exists(path), "Directory does not exist: " ~ path);
    
    string[] results;
    foreach (entry; dirEntries(path, SpanMode.breadth)) {
        if (entry.isFile && predicate(entry.name)) {
            results ~= entry.name;
        }
    }
    return results;
}

/// Get current working directory
string getCurrentDirectory() @trusted {
    return getcwd();
}

/// Change current working directory
void changeDirectory(string path) @trusted {
    enforce(exists(path), "Directory does not exist: " ~ path);
    enforce(isDir(path), "Path is not a directory: " ~ path);
    chdir(path);
}

unittest {
    import std.path : tempDir, buildPath;
    import std.uuid : randomUUID;
    
    auto testDir = buildPath(tempDir(), "uim-fs-dir-test-" ~ randomUUID().toString());
    scope(exit) {
        if (exists(testDir)) {
            rmdirRecurse(testDir);
        }
    }
    
    // Test create directories
    auto subDir = buildPath(testDir, "sub", "nested");
    createDirectories(subDir);
    assert(directoryExists(subDir));
    
    // Test list directory
    write(buildPath(subDir, "file.txt"), "test");
    auto entries = listDirectory(testDir, ListOptions(true));
    assert(entries.length > 0);
    
    // Test directory size
    auto size = directorySize(testDir);
    assert(size >= 4); // At least "test" bytes
}
