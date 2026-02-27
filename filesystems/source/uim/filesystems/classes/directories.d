/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.filesystems.classes.directories;

import uim.filesystems;

@safe:

/**
    * Directory entry structure
    *
    * Represents a file or subdirectory within a directory listing.
    *
    * Fields:
    * - name: The name of the entry (file or directory name)
    * - path: The full path of the entry
    * - size: The size of the entry in bytes
    * - timeModified: The last modification time of the entry
    * - isDirectory: Whether the entry is a directory
    * - isFile: Whether the entry is a file
    * - isSymlink: Whether the entry is a symbolic link
    */
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








