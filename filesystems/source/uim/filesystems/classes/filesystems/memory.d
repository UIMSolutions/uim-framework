/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.filesystems.classes.filesystems.memory;

import uim.filesystems;
@safe:  

/** 
  * In-memory filesystem implementation for testing and temporary storage.
  * This filesystem exists only in memory and does not persist data to disk.
  *
  * Note: This is a simplified implementation for demonstration purposes. It does not support all filesystem features
  * such as permissions, symbolic links, or advanced metadata. It is designed for use cases where a lightweight, temporary filesystem is needed, such as unit testing or caching.
  *
  * Example usage:
  * auto memFS = new MemoryFilesystem("TempFS", "Temporary In-Memory Filesystem", 1024 * 1024); // 1 MB capacity
  * memFS.createDirectory("/temp");
  * memFS.createFile("/temp/file.txt");
  * memFS.writeFile("/temp/file.txt", "Hello, World!");
  * auto content = memFS.readFile("/temp/file.txt");
  * writeln("File content: ", content);
  */
class MemoryFilesystem : UIMFilesystem {
    /* private struct InMemoryFile {
        ubyte[] data;
        SysTime lastModified;
    }
    
    private immutable string _name;
    private immutable string _label;
    private immutable string _type = "MemoryFilesystem";
    private size_t _capacity; // in bytes
    private size_t _used; // in bytes
    private FileMode _mode;
    private FileAccess _access;
    
    private __gshared __thread InMemoryFile[string] _files;
    
    /// Constructor
    this(string name, string label, size_t capacity, FileMode mode = FileMode.readWrite, FileAccess access = FileAccess.user) @trusted {
        _name = name;
        _label = label;
        _capacity = capacity;
        _used = 0;
        _mode = mode;
        _access = access;
    }
    
    /// Get filesystem name
    override string name() const {
        return _name;
    }
    
    /// Get filesystem label
    override string label() const {
        return _label;
    }
    
    /// Get filesystem type
    override string type() const {
        return _type;
    } */ 
}