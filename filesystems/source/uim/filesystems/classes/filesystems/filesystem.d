module uim.filesystems.classes.filesystems.filesystem;

import uim.filesystems;
@safe:

class Filesystem {
    // Placeholder for filesystem-related methods and properties

    /// Create directory
    void createDirectory(string path) @trusted {
        if (!exists(path)) {
            mkdir(path);
        }
    }
}
