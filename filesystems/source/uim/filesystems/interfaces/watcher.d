module uim.filesystems.interfaces.watcher;

interface IFileSystemWatcher {
    void onEvent(WatchCallback callback) @safe;
    void start() @trusted;
    void stop() @safe;
    bool isRunning() const @safe;
}