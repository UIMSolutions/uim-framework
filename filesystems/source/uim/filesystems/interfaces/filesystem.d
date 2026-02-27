module uim.filesystems.interfaces.filesystem;

import uim.filesystems;
@safe:
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