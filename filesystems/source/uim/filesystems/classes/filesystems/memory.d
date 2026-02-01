/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.filesystems.classes.filesystems.memory;

import uim.filesystems;
@safe:  

/// In-memory file representation
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
    override string name() const @safe {
        return _name;
    }
    
    /// Get filesystem label
    override string label() const @safe {
        return _label;
    }
    
    /// Get filesystem type
    override string type() const @safe {
        return _type;
    } */ 
}