/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.cdc.models.port;

import std.string : strip;

import vibe.d : runTask;

import uim.cdc;

mixin(ShowModule!());

@safe:

class UIMCDCService : UIMObject, ICDCService {
  private CDCPortConfig _config;
  private bool _isOpen;
  private bool _loopback;
  private ubyte[] _buffer;

  bool open(CDCPortConfig config) {
    if (config.devicePath.strip().length == 0) {
      _isOpen = false;
      return false;
    }

    _config = config;
    _loopback = cdcIsLoopbackPath(config.devicePath);
    _isOpen = true;

    if (_buffer.length > 0) {
      _buffer.length = 0;
    }

    return true;
  }

  bool close() {
    if (!_isOpen) {
      return false;
    }

    _isOpen = false;
    _buffer.length = 0;
    return true;
  }

  bool isOpen() const {
    return _isOpen;
  }

  CDCPortConfig config() const {
    return _config;
  }

  bool setLoopback(bool enabled) {
    _loopback = enabled;
    return true;
  }

  bool clearBuffers() {
    _buffer.length = 0;
    return true;
  }

  CDCResult writeText(string value) {
    if (!_isOpen) {
      return cdcFail("CDC port is not open");
    }

    auto normalized = _config.newlineDelimited ? cdcNormalizeLineEndings(value) : value;
    return writeBytes(cdcStringToBytes(normalized));
  }

  CDCResult writeBytes(const(ubyte)[] value) {
    if (!_isOpen) {
      return cdcFail("CDC port is not open");
    }

    if (value.length == 0) {
      return cdcOk(0, "nothing to write");
    }

    if (_loopback) {
      _buffer ~= value;
      return cdcOk(value.length, "loopback write complete");
    }

    auto bytesWritten = cdcTryWriteDevice(_config.devicePath, value);
    if (bytesWritten == value.length) {
      return cdcOk(bytesWritten, "device write complete");
    }

    return cdcFail("unable to write full CDC payload to device");
  }

  bool readFrame(out CDCFrame frame) {
    frame = CDCFrame.init;

    if (!_isOpen) {
      return false;
    }

    if (_loopback) {
      if (_buffer.length == 0) {
        return false;
      }

      auto frameEnd = cdcFindFrameEnd(_buffer, _config.newlineDelimited);
      if (frameEnd == 0) {
        return false;
      }

      auto raw = _buffer[0 .. frameEnd].dup;
      _buffer = _buffer[frameEnd .. $].dup;

      frame.channel = "loopback";
      frame.payload = raw;
      frame.text = cdcBytesToString(raw);
      return true;
    }

    auto payload = cdcTryReadDevice(_config.devicePath, _config.readTimeoutMs, _config.newlineDelimited);
    if (payload.length == 0) {
      return false;
    }

    frame.channel = "device";
    frame.payload = payload;
    frame.text = cdcBytesToString(payload);
    return true;
  }

  bool writeTextAsync(string value, CDCResultHandler handler) {
    if (handler is null) {
      return false;
    }

    auto localValue = value;
    auto localHandler = handler;

    (() @trusted {
      runTask(() nothrow {
        try {
          localHandler(writeText(localValue));
        } catch (Exception) {
        }
      });
    })();

    return true;
  }

  bool writeBytesAsync(const(ubyte)[] value, CDCResultHandler handler) {
    if (handler is null) {
      return false;
    }

    auto localValue = value.dup;
    auto localHandler = handler;

    (() @trusted {
      runTask(() nothrow {
        try {
          localHandler(writeBytes(localValue));
        } catch (Exception) {
        }
      });
    })();

    return true;
  }

  bool pollAsync(CDCFrameHandler handler, uint intervalMs = 100) {
    if (handler is null || !_isOpen) {
      return false;
    }

    auto localHandler = handler;
    (() @trusted {
      runTask(() nothrow {
        try {
          CDCFrame frame;
          if (readFrame(frame)) {
            localHandler(frame);
          }
        } catch (Exception) {
        }
      });
    })();

    return true;
  }
}

ICDCService CDCService() {
  return new UIMCDCService();
}

unittest {
  CDCPortConfig cfg;
  cfg.devicePath = "loop://vcp0";

  auto service = CDCService();
  assert(service.open(cfg));

  auto wr = service.writeText("AT+PING\n");
  assert(wr.success);
  assert(wr.bytesTransferred > 0);

  CDCFrame frame;
  assert(service.readFrame(frame));
  assert(frame.payload.length > 0);

  assert(service.close());
}
