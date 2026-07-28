/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.cdc.helpers.serial;

import core.stdc.errno : EAGAIN, EWOULDBLOCK, errno;
import core.sys.posix.fcntl : F_GETFL, F_SETFL, O_NOCTTY, O_NONBLOCK, O_RDWR, fcntl, open;
import core.sys.posix.sys.select : FD_ISSET, FD_SET, FD_ZERO, fd_set, select, timeval;
import core.sys.posix.termios :
  B9600,
  B19200,
  B38400,
  B57600,
  B115200,
  B230400,
  CLOCAL,
  CREAD,
  CS5,
  CS6,
  CS7,
  CS8,
  CSIZE,
  CSTOPB,
  PARENB,
  PARODD,
  TCSANOW,
  TCIOFLUSH,
  VMIN,
  VTIME,
  cfsetispeed,
  cfsetospeed,
  speed_t,
  tcflush,
  tcgetattr,
  tcsetattr,
  tcflag_t,
  termios;
import core.sys.posix.unistd : close, read, write;

import std.algorithm.searching : startsWith;
import std.string : strip, toStringz;

import uim.cdc.interfaces.port;

@safe:

bool cdcLooksLikeTtyPath(string value) {
  auto path = value.strip();
  return path.startsWith("/dev/ttyACM")
      || path.startsWith("/dev/ttyUSB")
      || path.startsWith("/dev/ttyS")
      || path.startsWith("/dev/ttyAMA");
}

private speed_t cdcBaudToSpeed(uint baudRate) @trusted {
  switch (baudRate) {
    case 9_600:
      return B9600;
    case 19_200:
      return B19200;
    case 38_400:
      return B38400;
    case 57_600:
      return B57600;
    case 230_400:
      return B230400;
    case 115_200:
    default:
      return B115200;
  }
}

private tcflag_t cdcDataBitsToFlag(ubyte dataBits) @trusted {
  switch (dataBits) {
    case 5:
      return CS5;
    case 6:
      return CS6;
    case 7:
      return CS7;
    case 8:
    default:
      return CS8;
  }
}

private bool cdcWaitForFd(int fd, uint timeoutMs, bool writable) @trusted {
  if (fd < 0) {
    return false;
  }

  fd_set set;
  FD_ZERO(&set);
  FD_SET(fd, &set);

  auto ms = timeoutMs == 0 ? 1u : timeoutMs;
  timeval tv;
  tv.tv_sec = cast(typeof(tv.tv_sec)) (ms / 1_000u);
  tv.tv_usec = cast(typeof(tv.tv_usec)) ((ms % 1_000u) * 1_000u);

  auto rc = writable
    ? select(fd + 1, null, &set, null, &tv)
    : select(fd + 1, &set, null, null, &tv);

  if (rc <= 0) {
    return false;
  }

  return FD_ISSET(fd, &set) != 0;
}

bool cdcSerialOpen(ref int fd, CDCPortConfig config) @trusted {
  if (config.devicePath.strip().length == 0) {
    fd = -1;
    return false;
  }

  auto localFd = open(config.devicePath.toStringz(), O_RDWR | O_NOCTTY | O_NONBLOCK);
  if (localFd < 0) {
    fd = -1;
    return false;
  }

  termios tio;
  if (tcgetattr(localFd, &tio) != 0) {
    close(localFd);
    fd = -1;
    return false;
  }

  tio.c_iflag = 0;
  tio.c_oflag = 0;
  tio.c_lflag = 0;
  tio.c_cflag &= ~CSIZE;
  tio.c_cflag |= CLOCAL | CREAD | cdcDataBitsToFlag(config.dataBits);

  tio.c_cflag &= ~(PARENB | PARODD | CSTOPB);

  switch (config.parity) {
    case CDCParity.none:
      break;
    case CDCParity.odd:
      tio.c_cflag |= PARENB | PARODD;
      break;
    case CDCParity.even:
      tio.c_cflag |= PARENB;
      break;
    case CDCParity.mark:
      // Mark and space parity are platform-specific; fallback keeps parity disabled.
      break;
    case CDCParity.space:
      break;
  }

  if (config.stopBits == CDCStopBits.two) {
    tio.c_cflag |= CSTOPB;
  }

  auto speed = cdcBaudToSpeed(config.baudRate);
  if (cfsetispeed(&tio, speed) != 0 || cfsetospeed(&tio, speed) != 0) {
    close(localFd);
    fd = -1;
    return false;
  }

  tio.c_cc[VMIN] = 0;
  tio.c_cc[VTIME] = 0;

  if (tcsetattr(localFd, TCSANOW, &tio) != 0) {
    close(localFd);
    fd = -1;
    return false;
  }

  tcflush(localFd, TCIOFLUSH);

  auto flags = fcntl(localFd, F_GETFL);
  if (flags >= 0) {
    fcntl(localFd, F_SETFL, flags | O_NONBLOCK);
  }

  fd = localFd;
  return true;
}

bool cdcSerialClose(ref int fd) @trusted {
  if (fd < 0) {
    return true;
  }

  auto rc = close(fd);
  fd = -1;
  return rc == 0;
}

size_t cdcSerialWrite(int fd, const(ubyte)[] payload, uint timeoutMs) @trusted {
  if (fd < 0 || payload.length == 0) {
    return 0;
  }

  size_t written = 0;
  while (written < payload.length) {
    if (!cdcWaitForFd(fd, timeoutMs, true)) {
      break;
    }

    auto chunk = payload[written .. $];
    auto rc = write(fd, chunk.ptr, chunk.length);
    if (rc > 0) {
      written += cast(size_t) rc;
      continue;
    }

    if (rc < 0 && (errno == EAGAIN || errno == EWOULDBLOCK)) {
      continue;
    }

    break;
  }

  return written;
}

ubyte[] cdcSerialRead(int fd, uint timeoutMs) @trusted {
  if (fd < 0) {
    return null;
  }

  if (!cdcWaitForFd(fd, timeoutMs, false)) {
    return null;
  }

  ubyte[2_048] buffer;
  auto rc = read(fd, buffer.ptr, buffer.length);
  if (rc <= 0) {
    return null;
  }

  return buffer[0 .. cast(size_t) rc].dup;
}

unittest {
  assert(cdcLooksLikeTtyPath("/dev/ttyACM0"));
  assert(cdcLooksLikeTtyPath("/dev/ttyUSB0"));
  assert(!cdcLooksLikeTtyPath("loop://vcp0"));
}
