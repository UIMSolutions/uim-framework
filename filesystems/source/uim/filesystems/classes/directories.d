/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.filesystems.classes.directories;

import uim.filesystems;

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








