module uim.filesystems.interfaces.watcher;

import uim.filesystems;
@safe:
interface IFileSystemWatcher {
    void onEvent(WatchCallback callback) @safe;
    void start() @trusted;
    void stop() @safe;
    bool isRunning() const @safe;
}