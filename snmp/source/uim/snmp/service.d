/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.snmp.service;

import std.datetime : Clock, UTC;

import vibe.d : runTask;

import uim.snmp;

mixin(ShowModule!());

@safe:

class UIMSNMPService : UIMObject, ISNMPService {
  private SNMPConfig _config;
  private bool _configured;

  private SNMPGetDelegate _getProvider;
  private SNMPWalkDelegate _walkProvider;
  private SNMPSetDelegate _setProvider;

  bool configure(SNMPConfig config) {
    if (config.host.length == 0 || config.port == 0) {
      _configured = false;
      return false;
    }

    _config = config;
    _configured = true;
    return true;
  }

  SNMPConfig config() const {
    return _config;
  }

  bool setGetProvider(SNMPGetDelegate provider) {
    _getProvider = provider;
    return true;
  }

  bool setWalkProvider(SNMPWalkDelegate provider) {
    _walkProvider = provider;
    return true;
  }

  bool setSetProvider(SNMPSetDelegate provider) {
    _setProvider = provider;
    return true;
  }

  SNMPOidValue get(string oid) {
    if (!_configured || oid.length == 0) {
      return SNMPOidValueEmpty(oid);
    }

    if (_getProvider !is null) {
      try {
        return _getProvider(_config, oid);
      } catch (Exception) {
        return SNMPOidValueEmpty(oid);
      }
    }

    SNMPOidValue value;
    value.oid = oid;
    value.typeTag = "STRING";
    value.value = "uim-snmp in-memory response";
    value.timestamp = Clock.currTime(UTC()).toUnixTime();
    return value;
  }

  SNMPOidValue[] walk(string rootOid, uint maxRepetitions = 25) {
    SNMPOidValue[] values;

    if (!_configured || rootOid.length == 0 || maxRepetitions == 0) {
      return values;
    }

    if (_walkProvider !is null) {
      try {
        return _walkProvider(_config, rootOid, maxRepetitions);
      } catch (Exception) {
        return values;
      }
    }

    values ~= SNMPOidValue(rootOid ~ ".1", "STRING", "uim-device", Clock.currTime(UTC()).toUnixTime());
    values ~= SNMPOidValue(rootOid ~ ".2", "INTEGER", "42", Clock.currTime(UTC()).toUnixTime());
    return values;
  }

  SNMPResult set(string oid, string value, string typeTag = "s") {
    if (!_configured) {
      return SNMPResultErr(412, "SNMP service is not configured.");
    }

    if (oid.length == 0) {
      return SNMPResultErr(400, "oid is required");
    }

    if (_setProvider !is null) {
      try {
        return _setProvider(_config, oid, value, typeTag);
      } catch (Exception ex) {
        return SNMPResultErr(500, ex.msg);
      }
    }

    return SNMPResultOk(200, "value accepted by in-memory SNMP provider");
  }

  bool getAsync(string oid, SNMPOidValueHandler handler) {
    if (handler is null) {
      return false;
    }

    auto localOid = oid;
    auto localHandler = handler;

    (() @trusted {
      runTask(() nothrow {
        try {
          localHandler(get(localOid));
        } catch (Exception) {
        }
      });
    })();

    return true;
  }

  bool walkAsync(string rootOid, uint maxRepetitions, SNMPOidValuesHandler handler) {
    if (handler is null) {
      return false;
    }

    auto localRootOid = rootOid;
    auto localMaxRepetitions = maxRepetitions;
    auto localHandler = handler;

    (() @trusted {
      runTask(() nothrow {
        try {
          localHandler(walk(localRootOid, localMaxRepetitions));
        } catch (Exception) {
        }
      });
    })();

    return true;
  }

  bool setAsync(string oid, string value, string typeTag, SNMPResultHandler handler) {
    if (handler is null) {
      return false;
    }

    auto localOid = oid;
    auto localValue = value;
    auto localTypeTag = typeTag;
    auto localHandler = handler;

    (() @trusted {
      runTask(() nothrow {
        try {
          localHandler(set(localOid, localValue, localTypeTag));
        } catch (Exception) {
        }
      });
    })();

    return true;
  }

  SNMPOidValue parseOidLine(string line, string fallbackOid = "") {
    return snmpParseOidLine(line, fallbackOid);
  }
}

ISNMPService SNMPService() {
  return new UIMSNMPService();
}

unittest {
  auto service = SNMPService();

  SNMPConfig config;
  config.host = "snmp.example.org";
  config.port = 161;
  assert(service.configure(config));

  auto value = service.get("1.3.6.1.2.1.1.5.0");
  assert(value.oid.length > 0);

  auto values = service.walk("1.3.6.1.2.1.1", 10);
  assert(values.length >= 1);

  auto writeResult = service.set("1.3.6.1.2.1.1.5.0", "switch-02", "STRING");
  assert(writeResult.success);
}
