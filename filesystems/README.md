# Library 📚 uim-filesystems

Updated on 1. February 2026

[![uim-filesystems](https://github.com/UIMSolutions/uim-framework/actions/workflows/uim-filesystems.yml/badge.svg)](https://github.com/UIMSolutions/uim-framework/actions/workflows/uim-filesystems.yml) [![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

A filesystem operations library for D, providing both synchronous and asynchronous file/directory operations with vibe.d integration.

## Features

### File Operations

- **Read/Write**: Sync and async file reading/writing with various encodings
- **Copy/Move**: Efficient file copying and moving with progress callbacks
- **Delete**: Safe file deletion with backup options
- **Metadata**: Access and modify file attributes, permissions, timestamps
- **Locking**: File locking mechanisms for concurrent access control

### Directory Operations

- **Creation**: Create single or nested directories
- **Listing**: List directory contents with filtering and sorting
- **Traversal**: Recursive directory walking with callbacks
- **Deletion**: Safe recursive directory removal
- **Monitoring**: Watch directories for changes (file system events)

### Path Utilities

- **Normalization**: Clean and normalize file paths
- **Resolution**: Resolve relative paths, symlinks
- **Manipulation**: Join, split, get extensions, basenames
- **Validation**: Check path validity, existence, types

### Advanced Features

- **Temporary Files**: Create and manage temporary files/directories
- **File Watching**: Monitor filesystem changes in real-time
- **Atomic Operations**: Atomic file writes with transactions
- **Compression**: Built-in support for compressed file operations
- **Virtual FS**: Abstract filesystem interface for testing

## Quick Start

```d
import uim.filesystems;

// Read a file
auto content = readFileText("config.json");

// Write a file atomically
writeFileAtomic("output.txt", "Hello World");

// Copy with progress
copyFile("large.bin", "backup.bin", (progress) {
    writeln("Progress: ", progress * 100, "%");
});

// List directory
foreach (entry; listDirectory("/etc")) {
    writefln("%s: %s bytes", entry.name, entry.size);
}

// Watch for changes
auto watcher = createFileWatcher("/var/log");
watcher.onChange((path, event) {
    writefln("File %s was %s", path, event);
});

// Async operations with vibe.d
import vibe.core.core;

runTask({
    auto data = readFileAsync("large.dat").await;
    writeFileAsync("copy.dat", data).await;
});
```

## Modules

### `uim.filesystems.files`

Core file operations: read, write, copy, move, delete, metadata.

### `uim.filesystems.directories`

Directory operations: create, list, traverse, delete, search.

### `uim.filesystems.paths`

Path manipulation utilities: normalize, join, split, resolve.

### `uim.filesystems.watcher`

File system monitoring: watch directories and files for changes.

### `uim.filesystems.temporary`

Temporary file/directory management with automatic cleanup.

### `uim.filesystems.async`

Asynchronous filesystem operations using vibe.d.

### `uim.filesystems.metadata`

File metadata and attributes: permissions, timestamps, ownership.

## Installation

Add to your `dub.sdl`:

```sdl
dependency "uim-framework:filesystems" version="*"
```

## License

Apache License 2.0
