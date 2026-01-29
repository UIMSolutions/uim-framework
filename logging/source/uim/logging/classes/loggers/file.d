/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.logging.classes.loggers.file;

import uim.logging.classes.loggers.base;
import std.stdio : File;
import std.file : exists, mkdirRecurse;
import std.path : dirName;
import core.sync.mutex;

/**
 * File logger that writes logs to a file
 */
class FileLogger : DLogger {
    private {
        string _filename;
        File _file;
        Mutex _mutex;
        bool _isOpen;
        size_t _maxFileSize = 10 * 1024 * 1024; // 10 MB default
        bool _autoRotate = true;
    }
    
    this(string filename, string loggerName = "File") {
        super(loggerName);
        _filename = filename;
        _mutex = new Mutex();
        openFile();
    }
    
    ~this() {
        close();
    }
    
    @property string filename() { return _filename; }
    
    @property size_t maxFileSize() { return _maxFileSize; }
    @property void maxFileSize(size_t value) { _maxFileSize = value; }
    
    @property bool autoRotate() { return _autoRotate; }
    @property void autoRotate(bool value) { _autoRotate = value; }
    
    private void openFile() {
        import std.file : getSize;
        
        synchronized(_mutex) {
            // Create directory if it doesn't exist
            auto dir = dirName(_filename);
            if (!exists(dir)) {
                mkdirRecurse(dir);
            }
            
            // Open file in append mode
            _file = File(_filename, "a");
            _isOpen = true;
            
            // Check if rotation is needed
            if (_autoRotate && exists(_filename)) {
                auto fileSize = getSize(_filename);
                if (fileSize > _maxFileSize) {
                    rotate();
                }
            }
        }
    }
    
    private void rotate() {
        import std.file : rename, remove;
        import std.format : format;
        import std.datetime : Clock;
        
        synchronized(_mutex) {
            if (_isOpen) {
                _file.close();
                _isOpen = false;
            }
            
            // Rotate with timestamp
            auto timestamp = Clock.currTime();
            auto newName = format("%s.%04d%02d%02d_%02d%02d%02d",
                _filename,
                timestamp.year, timestamp.month, timestamp.day,
                timestamp.hour, timestamp.minute, timestamp.second
            );
            
            if (exists(_filename)) {
                rename(_filename, newName);
            }
            
            openFile();
        }
    }
    
    protected override void writeLog(string formattedMessage) {
        synchronized(_mutex) {
            if (!_isOpen) {
                openFile();
            }
            
            _file.writeln(formattedMessage);
            _file.flush();
            
            // Check if rotation is needed after writing
            if (_autoRotate) {
                import std.file : getSize;
                auto currentSize = getSize(_filename);
                if (currentSize > _maxFileSize) {
                    rotate();
                }
            }
        }
    }
    
    override void flush() {
        synchronized(_mutex) {
            if (_isOpen) {
                _file.flush();
            }
        }
    }
    
    override void close() {
        synchronized(_mutex) {
            if (_isOpen) {
                _file.close();
                _isOpen = false;
            }
        }
    }
}

/**
 * Factory function to create a file logger
 */
DFileLogger FileLogger(string filename, string name = "File") {
    return new DFileLogger(filename, name);
}
