/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.pop3.service;

import std.conv : to;

import vibe.d : runTask;

import uim.pop3;

mixin(ShowModule!());

@safe:

class UIMPOP3Service : UIMObject, IPOP3Service {
  private POP3Config _config;
  private bool _configured;

  private POP3StatDelegate _statProvider;
  private POP3ListDelegate _listProvider;
  private POP3UidlDelegate _uidlProvider;
  private POP3RetrDelegate _retrProvider;
  private POP3DeleDelegate _deleProvider;

  bool configure(POP3Config config) {
    if (config.host.length == 0 || config.port == 0) {
      _configured = false;
      return false;
    }

    _config = config;
    _configured = true;
    return true;
  }

  POP3Config config() const {
    return _config;
  }

  bool setStatProvider(POP3StatDelegate provider) {
    _statProvider = provider;
    return true;
  }

  bool setListProvider(POP3ListDelegate provider) {
    _listProvider = provider;
    return true;
  }

  bool setUidlProvider(POP3UidlDelegate provider) {
    _uidlProvider = provider;
    return true;
  }

  bool setRetrProvider(POP3RetrDelegate provider) {
    _retrProvider = provider;
    return true;
  }

  bool setDeleProvider(POP3DeleDelegate provider) {
    _deleProvider = provider;
    return true;
  }

  POP3Status stat() {
    if (!_configured) {
      return POP3StatusErr("POP3 service is not configured.");
    }

    if (_statProvider !is null) {
      try {
        return _statProvider(_config);
      } catch (Exception ex) {
        return POP3StatusErr(ex.msg);
      }
    }

    return POP3StatusOk(2, 4096, "in-memory POP3 status");
  }

  POP3MessageMeta[] list() {
    POP3MessageMeta[] result;
    if (!_configured) {
      return result;
    }

    if (_listProvider !is null) {
      try {
        return _listProvider(_config);
      } catch (Exception) {
        return result;
      }
    }

    result ~= POP3MessageMeta(1, 1024, "uid-1");
    result ~= POP3MessageMeta(2, 3072, "uid-2");
    return result;
  }

  POP3MessageMeta[] uidl() {
    POP3MessageMeta[] result;
    if (!_configured) {
      return result;
    }

    if (_uidlProvider !is null) {
      try {
        return _uidlProvider(_config);
      } catch (Exception) {
        return result;
      }
    }

    result ~= POP3MessageMeta(1, 0, "uid-1");
    result ~= POP3MessageMeta(2, 0, "uid-2");
    return result;
  }

  POP3Message retr(uint number) {
    if (!_configured || number == 0) {
      return POP3MessageEmpty(number);
    }

    if (_retrProvider !is null) {
      try {
        return _retrProvider(_config, number);
      } catch (Exception) {
        return POP3MessageEmpty(number);
      }
    }

    auto uid = "uid-" ~ number.to!string;
    auto raw = "From: system@example.org\r\n"
      ~ "To: user@example.org\r\n"
      ~ "Subject: POP3 demo\r\n"
      ~ "\r\n"
      ~ "This message was retrieved from in-memory POP3 provider.";

    return parseRetrResponse(number, uid, raw);
  }

  POP3Result dele(uint number) {
    if (!_configured) {
      return POP3ResultErr("POP3 service is not configured.");
    }

    if (number == 0) {
      return POP3ResultErr("message number must be greater than 0");
    }

    if (_deleProvider !is null) {
      try {
        return _deleProvider(_config, number);
      } catch (Exception ex) {
        return POP3ResultErr(ex.msg);
      }
    }

    return POP3ResultOk("message marked for deletion");
  }

  bool statAsync(POP3StatusHandler handler) {
    if (handler is null) {
      return false;
    }

    auto localHandler = handler;
    (() @trusted {
      runTask(() nothrow {
        try {
          localHandler(stat());
        } catch (Exception) {
        }
      });
    })();

    return true;
  }

  bool retrAsync(uint number, POP3MessageHandler handler) {
    if (handler is null) {
      return false;
    }

    auto localHandler = handler;
    auto localNumber = number;
    (() @trusted {
      runTask(() nothrow {
        try {
          localHandler(retr(localNumber));
        } catch (Exception) {
        }
      });
    })();

    return true;
  }

  bool deleAsync(uint number, POP3ResultHandler handler) {
    if (handler is null) {
      return false;
    }

    auto localHandler = handler;
    auto localNumber = number;
    (() @trusted {
      runTask(() nothrow {
        try {
          localHandler(dele(localNumber));
        } catch (Exception) {
        }
      });
    })();

    return true;
  }

  POP3Status parseStatusLine(string line) {
    return pop3ParseStatusLine(line);
  }

  POP3MessageMeta parseListLine(string line) {
    return pop3ParseListLine(line);
  }

  POP3MessageMeta parseUidlLine(string line) {
    return pop3ParseUidlLine(line);
  }

  POP3Message parseRetrResponse(uint number, string uid, string raw) {
    return pop3ParseRetrResponse(number, uid, raw);
  }
}

IPOP3Service POP3Service() {
  return new UIMPOP3Service();
}

unittest {
  auto service = POP3Service();

  POP3Config config;
  config.host = "pop.example.org";
  config.port = 110;
  assert(service.configure(config));

  auto status = service.stat();
  assert(status.success);

  auto listing = service.list();
  assert(listing.length >= 1);

  auto message = service.retr(1);
  assert(message.number == 1);

  auto deletion = service.dele(1);
  assert(deletion.success);
}
