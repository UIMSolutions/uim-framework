
module uim.filesystems.classes.filesystems.filesystem;
interface IFilesystem {
    void createDirectory(string path);
    void createDirectories(string path);
    void deleteDirectory(string path);
    void deleteDirectoryRecursive(string path);
    bool directoryExists(string path) nothrow;
    bool isDirectoryEmpty(string path);
    DirectoryEntry[] listDirectory(string path, ListOptions options = ListOptions.init);
    string[] getFiles(string path, string pattern = "*");
    string[] getDirectories(string path);
    ulong directorySize(string path, bool recursive = true);
    void copyDirectory(string source, string dest);
    void moveDirectory(string source, string dest);
    void walkDirectory(string path, void delegate(string path, bool isDir) @safe callback);
    string[] findFiles(string path, bool delegate(string) @safe predicate);
    string getCurrentDirectory();
    void changeDirectory(string path);
}

import uim.filesystems;

@safe:

class UIMFilesystem : UIMObject, IFilesystem {
    // Placeholder for filesystem-related methods and properties

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
            if (!options.includeHidden && std.path.baseName(entry.name)
                .length > 0 && std.path.baseName(entry.name)[0] == '.') {
                continue;
            }

            DirectoryEntry de;
            de.name = std.path.baseName(entry.name);
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
            auto destPath = buildPath(dest, std.path.baseName(entry.name));

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
}

unittest {
    import std.path : buildPath;
    import std.file : tempDir, exists, rmdirRecurse, write;
    import std.uuid : randomUUID;
    
    auto testDir = buildPath(tempDir(), "uim-fs-dir-test-" ~ randomUUID().toString());
    scope(exit) {
        if (exists(testDir)) {
            rmdirRecurse(testDir);
        }
    }
    
    auto fs = new UIMFilesystem();

    // Test create directories
    auto subDir = buildPath(testDir, "sub", "nested");
    fs.createDirectories(subDir);
    assert(fs.directoryExists(subDir));
    
    // Test list directory
    write(buildPath(subDir, "file.txt"), "test");
    auto entries = fs.listDirectory(testDir, ListOptions(true));
    assert(entries.length > 0);
    
    // Test directory size
    auto size = fs.directorySize(testDir);
    assert(size >= 4); // At least "test" bytes
}