/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.filesystems.classes.metadata;

import std.file;
import std.datetime : SysTime;
import std.exception : enforce;

@safe:

/// File metadata structure
struct FileMetadata {
    string path;
    ulong size;
    SysTime timeCreated;
    SysTime timeModified;
    SysTime timeAccessed;
    bool isFile;
    bool isDirectory;
    bool isSymlink;
    uint attributes;
    
    version (Posix) {
        uint userId;
        uint groupId;
        uint permissions;
    }
}

/// Get file metadata
FileMetadata getMetadata(string path) @trusted {
    enforce(exists(path), "Path does not exist: " ~ path);
    
    FileMetadata meta;
    meta.path = path;
    
    auto attrs = getAttributes(path);
    meta.attributes = attrs;
    meta.isFile = isFile(path);
    meta.isDirectory = isDir(path);
    meta.isSymlink = isSymlink(path);
    
    if (meta.isFile) {
        meta.size = getSize(path);
    }
    
    SysTime accessTime, modificationTime;
    getTimes(path, accessTime, modificationTime);
    meta.timeAccessed = accessTime;
    meta.timeModified = modificationTime;
    
    version (Posix) {
        import core.sys.posix.sys.stat;
        stat_t statbuf;
        if (stat(path.ptr, &statbuf) == 0) {
            meta.userId = statbuf.st_uid;
            meta.groupId = statbuf.st_gid;
            meta.permissions = statbuf.st_mode & 0x1FF; // 0o7777 = 0x1FF
        }
    }
    
    return meta;
}

/// Get file size
size_t getFileSize(string path) @trusted {
    enforce(exists(path), "Path does not exist: " ~ path);
    return getSize(path);
}

/// Get last modification time
SysTime getModificationTime(string path) @trusted {
    enforce(exists(path), "Path does not exist: " ~ path);
    return timeLastModified(path);
}

/// Set modification time
void setModificationTime(string path, SysTime time) @trusted {
    enforce(exists(path), "Path does not exist: " ~ path);
    setTimes(path, SysTime.init, time);
}

/// Get file attributes
uint getFileAttributes(string path) @trusted {
    enforce(exists(path), "Path does not exist: " ~ path);
    return getAttributes(path);
}

/// Set file attributes
void setFileAttributes(string path, uint attributes) @trusted {
    enforce(exists(path), "Path does not exist: " ~ path);
    setAttributes(path, attributes);
}

version (Posix) {
    /// File permissions structure
    struct FilePermissions {
        bool ownerRead;
        bool ownerWrite;
        bool ownerExecute;
        bool groupRead;
        bool groupWrite;
        bool groupExecute;
        bool otherRead;
        bool otherWrite;
        bool otherExecute;
        
        /// Convert to octal mode (e.g., 0o755)
        uint toMode() const {
            uint mode = 0;
            if (ownerRead) mode |= 0x100; // 0o400
            if (ownerWrite) mode |= 0x80; // 0o200
            if (ownerExecute) mode |= 0x40; // 0o100
            if (groupRead) mode |= 0x20; // 0o040
            if (groupWrite) mode |= 0x10; // 0o020
            if (groupExecute) mode |= 0x08; // 0o010
            if (otherRead) mode |= 0x04; // 0o004
            if (otherWrite) mode |= 0x02; // 0o002
            if (otherExecute) mode |= 0x01; // 0o001
            return mode;
        }
        
        /// Create from octal mode
        static FilePermissions fromMode(uint mode) {
            FilePermissions perms;
            perms.ownerRead = (mode & 0x100) != 0; // 0o400
            perms.ownerWrite = (mode & 0x80) != 0; // 0o200
            perms.ownerExecute = (mode & 0x40) != 0; // 0o100
            perms.groupRead = (mode & 0x20) != 0; // 0o040
            perms.groupWrite = (mode & 0x10) != 0; // 0o020
            perms.groupExecute = (mode & 0x08) != 0; // 0o010
            perms.otherRead = (mode & 0x04) != 0; // 0o004
            perms.otherWrite = (mode & 0x02) != 0; // 0o002
            perms.otherExecute = (mode & 0x01) != 0; // 0o001
            return perms;
        }
    }
    
    /// Get file permissions
    FilePermissions getPermissions(string path) @trusted {
        import core.sys.posix.sys.stat : stat, stat_t, S_IRWXU, S_IRWXG, S_IRWXO;
        import std.string : toStringz;

        enforce(exists(path), "Path does not exist: " ~ path);

        stat_t statbuf;
        enforce(stat(toStringz(path), &statbuf) == 0, "Failed to get file stats");

        return FilePermissions.fromMode(statbuf.st_mode & 0x1FF); // 0o7777 = 0x1FF
    }
    
    /// Set file permissions
    void setPermissions(string path, FilePermissions perms) @trusted {
        import core.sys.posix.sys.stat;
        import std.string : toStringz;

        enforce(exists(path), "Path does not exist: " ~ path);
        enforce(chmod(toStringz(path), perms.toMode()) == 0, "Failed to set permissions");
    }
    
    /// Set file permissions from octal mode
    void setPermissions(string path, uint mode) @trusted {
        import core.sys.posix.sys.stat;
        import std.string : toStringz;

        enforce(exists(path), "Path does not exist: " ~ path);
        enforce(chmod(toStringz(path), mode) == 0, "Failed to set permissions");
    }
    
    /// Get file owner user ID
    uint getOwnerId(string path) @trusted {
        import core.sys.posix.sys.stat;
        import std.string : toStringz;

        enforce(exists(path), "Path does not exist: " ~ path);

        stat_t statbuf;
        enforce(stat(toStringz(path), &statbuf) == 0, "Failed to get file stats");

        return statbuf.st_uid;
    }
    
    /// Get file owner group ID
    uint getGroupId(string path) @trusted {
        import core.sys.posix.sys.stat;
        import std.string : toStringz;

        enforce(exists(path), "Path does not exist: " ~ path);

        stat_t statbuf;
        enforce(stat(toStringz(path), &statbuf) == 0, "Failed to get file stats");

        return statbuf.st_gid;
    }
    
    /// Change file owner
    void changeOwner(string path, uint userId, uint groupId) @trusted {
        import core.sys.posix.unistd;
        import std.string : toStringz;

        enforce(exists(path), "Path does not exist: " ~ path);
        enforce(chown(toStringz(path), userId, groupId) == 0, "Failed to change owner");
    }
}

unittest {
    import std.path : buildPath;
    import std.file : tempDir, exists, remove;
    import std.uuid : randomUUID;
    
    auto testFile = buildPath(tempDir(), "metadata-test-" ~ randomUUID().toString());
    scope(exit) {
        if (exists(testFile)) {
            remove(testFile);
        }
    }
    
    // Create test file
    write(testFile, "test content");
    
    // Test get metadata
    auto meta = getMetadata(testFile);
    assert(meta.isFile);
    assert(!meta.isDirectory);
    assert(meta.size > 0);
    
    version (Posix) {
        // Test permissions
        auto perms = getPermissions(testFile);
        assert(perms.ownerRead || perms.ownerWrite);
    }
}
