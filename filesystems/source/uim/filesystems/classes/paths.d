/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.filesystems.classes.paths;

import std.path;
import std.file : exists, getcwd;
import std.algorithm : map, filter;
import std.array : array, split;
import std.string : strip;

@safe:

/// Normalize path (resolve . and .., convert separators)
string normalizePath(string path) {
    return buildNormalizedPath(path);
}

/// Join path components
string joinPaths(string[] components...) {
    return buildPath(components);
}

/// Get absolute path
string absolutePath(string path) @trusted {
    return std.path.absolutePath(path, getcwd());
}

/// Get relative path from base to target
string relativePath(string target, string base = null) @trusted {
    if (base is null) {
        base = getcwd();
    }
    return std.path.relativePath(target, base);
}

/// Get directory name (parent directory)
string directoryName(string path) {
    return dirName(path);
}

/// Get base name (file name with extension)
string baseName(string path) {
    return std.path.baseName(path);
}

/// Get file name without extension
string fileNameWithoutExtension(string path) {
    return stripExtension(baseName(path));
}

/// Get file extension (including dot)
string fileExtension(string path) {
    return extension(path);
}

/// Change file extension
string changeExtension(string path, string newExt) {
    return setExtension(path, newExt);
}

/// Remove file extension
string removeExtension(string path) {
    return stripExtension(path);
}

/// Check if path is absolute
bool isAbsolutePath(string path) {
    return std.path.isAbsolute(path);
}

/// Check if path is relative
bool isRelativePath(string path) {
    return !isAbsolutePath(path);
}

/// Check if path is valid (no invalid characters)
bool isValidPath(string path) @safe nothrow {
    try {
        return std.path.isValidPath(path);
    } catch (Exception) {
        return false;
    }
}

/// Check if path exists
bool pathExists(string path) @trusted nothrow {
    try {
        return exists(path);
    } catch (Exception) {
        return false;
    }
}

/// Split path into components
string[] splitPath(string path) {
    return pathSplitter(path).array;
}

/// Get drive/root from path (Windows: C:, Unix: /)
string driveName(string path) {
    return std.path.driveName(path);
}

/// Strip drive/root from path
string stripDrive(string path) {
    return std.path.stripDrive(path);
}

/// Expand tilde (~) in path to home directory
string expandTilde(string path) @trusted {
    return std.path.expandTilde(path);
}

/// Get common prefix of multiple paths
string commonPrefix(string[] paths) {
    if (paths.length == 0) return "";
    if (paths.length == 1) return paths[0];
    
    auto components = paths.map!(p => splitPath(p)).array;
    string[] common;
    
    size_t minLength = size_t.max;
    foreach (comp; components) {
        if (comp.length < minLength) {
            minLength = comp.length;
        }
    }
    
    foreach (i; 0 .. minLength) {
        auto first = components[0][i];
        bool allMatch = true;
        
        foreach (comp; components[1 .. $]) {
            if (comp[i] != first) {
                allMatch = false;
                break;
            }
        }
        
        if (allMatch) {
            common ~= first;
        } else {
            break;
        }
    }
    
    return buildPath(common);
}

/// Check if child path is under parent path
bool isUnderPath(string child, string parent) @trusted {
    auto absChild = absolutePath(child);
    auto absParent = absolutePath(parent);
    
    import std.algorithm : startsWith;
    return absChild.startsWith(absParent);
}

/// Clean path (remove redundant separators, etc.)
string cleanPath(string path) {
    return buildNormalizedPath(path);
}

/// Get path depth (number of components)
size_t pathDepth(string path) {
    return splitPath(path).length;
}

/// Compare two paths (case-sensitive or insensitive based on OS)
bool pathsEqual(string path1, string path2) {
    version (Windows) {
        import std.uni : toLower;
        return normalizePath(path1).toLower() == normalizePath(path2).toLower();
    } else {
        return normalizePath(path1) == normalizePath(path2);
    }
}

unittest {
    // Test normalize
    assert(normalizePath("a/./b/../c") == "a/c" || normalizePath("a/./b/../c") == "a\\c");
    
    // Test join
    assert(joinPaths("a", "b", "c") == buildPath("a", "b", "c"));
    
    // Test base name
    assert(baseName("/path/to/file.txt") == "file.txt");
    
    // Test extension
    assert(fileExtension("file.txt") == ".txt");
    assert(fileNameWithoutExtension("file.txt") == "file");
    
    // Test directory name
    version (Posix) {
        assert(directoryName("/path/to/file.txt") == "/path/to");
    }
    
    // Test is absolute
    version (Posix) {
        assert(isAbsolutePath("/absolute/path"));
        assert(!isAbsolutePath("relative/path"));
    }
    version (Windows) {
        assert(isAbsolutePath("C:\\absolute\\path"));
        assert(!isAbsolutePath("relative\\path"));
    }
}
