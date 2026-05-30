/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.nffi.service;

import std.datetime : Clock, UTC;

import vibe.d : runTask;

import uim.nffi;

mixin(ShowModule!());

@safe:

class UIMNFFIService : UIMObject, INFFIService {
  private NFFIConfig _config;
  private bool _configured;

  private NFFIPublishDelegate _publishProvider;
  private NFFIGetDelegate _getProvider;
  private NFFISyncDelegate _syncProvider;

  bool configure(NFFIConfig config) {
    if (config.endpoint.length == 0) {
      _configured = false;
      return false;
    }

    _config = config;
    _configured = true;
    return true;
  }

  NFFIConfig config() const {
    return _config;
  }

  bool setPublishProvider(NFFIPublishDelegate provider) {
    _publishProvider = provider;
    return true;
  }

  bool setGetProvider(NFFIGetDelegate provider) {
    _getProvider = provider;
    return true;
  }

  bool setSyncProvider(NFFISyncDelegate provider) {
    _syncProvider = provider;
    return true;
  }

  NFFIResult publishTrack(NFFITrack track) {
    if (!_configured) {
      return NFFIResultErr(412, "NFFI service is not configured.");
    }

    if (track.unitId.length == 0) {
      return NFFIResultErr(400, "unitId is required");
    }

    if (_publishProvider !is null) {
      try {
        return _publishProvider(_config, track);
      } catch (Exception ex) {
        return NFFIResultErr(500, ex.msg);
      }
    }

    auto referenceId = _config.nationCode ~ "-" ~ track.unitId;
    return NFFIResultOk(200, "NFFI track published by in-memory provider", referenceId);
  }

  NFFITrack getTrack(string unitId) {
    if (!_configured || unitId.length == 0) {
      return NFFITrackEmpty(unitId);
    }

    if (_getProvider !is null) {
      try {
        return _getProvider(_config, unitId);
      } catch (Exception) {
        return NFFITrackEmpty(unitId);
      }
    }

    NFFITrack track;
    track.unitId = unitId;
    track.callsign = "EAGLE-7";
    track.affiliation = "Friendly";
    track.symbolCode = "SFGPUCI----K";
    track.latitude = 50.1109;
    track.longitude = 8.6821;
    track.altitude = 120.0;
    track.timestamp = Clock.currTime(UTC()).toUnixTime();
    track.source = "uim-nffi in-memory provider";
    return track;
  }

  NFFITrack[] synchronizeArea(string areaId) {
    NFFITrack[] tracks;

    if (!_configured || areaId.length == 0) {
      return tracks;
    }

    if (_syncProvider !is null) {
      try {
        return _syncProvider(_config, areaId);
      } catch (Exception) {
        return tracks;
      }
    }

    auto first = getTrack(_config.forceId.length > 0 ? _config.forceId : "DEU-ARMY-0001");
    tracks ~= first;

    auto second = first;
    second.unitId = "DEU-ARMY-0002";
    second.callsign = "EAGLE-2";
    second.longitude += 0.02;
    tracks ~= second;

    return tracks;
  }

  bool getTrackAsync(string unitId, NFFITrackHandler handler) {
    if (handler is null) {
      return false;
    }

    auto localUnitId = unitId;
    auto localHandler = handler;

    (() @trusted {
      runTask(() nothrow {
        try {
          localHandler(getTrack(localUnitId));
        } catch (Exception) {
        }
      });
    })();

    return true;
  }

  bool synchronizeAreaAsync(string areaId, NFFITracksHandler handler) {
    if (handler is null) {
      return false;
    }

    auto localAreaId = areaId;
    auto localHandler = handler;

    (() @trusted {
      runTask(() nothrow {
        try {
          localHandler(synchronizeArea(localAreaId));
        } catch (Exception) {
        }
      });
    })();

    return true;
  }

  bool publishTrackAsync(NFFITrack track, NFFIResultHandler handler) {
    if (handler is null) {
      return false;
    }

    auto localTrack = track;
    auto localHandler = handler;

    (() @trusted {
      runTask(() nothrow {
        try {
          localHandler(publishTrack(localTrack));
        } catch (Exception) {
        }
      });
    })();

    return true;
  }

  string encodeTrack(NFFITrack track) {
    return nffiEncodeTrack(track);
  }

  NFFITrack decodeTrack(string payload) {
    return nffiDecodeTrack(payload);
  }
}

INFFIService NFFIService() {
  return new UIMNFFIService();
}

unittest {
  auto service = NFFIService();

  NFFIConfig config;
  config.endpoint = "https://nffi.example.mil/feed";
  config.nationCode = "DEU";
  config.forceId = "DEU-ARMY-0007";
  assert(service.configure(config));

  auto track = service.getTrack("DEU-ARMY-0007");
  assert(track.unitId.length > 0);

  auto encoded = service.encodeTrack(track);
  assert(encoded.length > 0);

  auto decoded = service.decodeTrack(encoded);
  assert(decoded.unitId == track.unitId);

  auto published = service.publishTrack(track);
  assert(published.success);
}
