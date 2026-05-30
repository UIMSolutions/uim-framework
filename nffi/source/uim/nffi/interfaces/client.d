/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.nffi.interfaces.client;

@safe:

enum NFFIStandard : ubyte {
  atp45 = 0,
  app11 = 1,
  custom = 2
}

struct NFFIConfig {
  string endpoint;
  string nationCode;
  string forceId;
  NFFIStandard standard = NFFIStandard.app11;
  bool strictValidation;
  uint timeoutMs = 10_000;
}

struct NFFITrack {
  string unitId;
  string callsign;
  string affiliation;
  string symbolCode;
  double latitude;
  double longitude;
  double altitude;
  long timestamp;
  string source;
}

struct NFFIResult {
  bool success;
  ushort statusCode;
  string message;
  string referenceId;
}

alias NFFITrackHandler = void delegate(NFFITrack track) @safe;
alias NFFIResultHandler = void delegate(NFFIResult result) @safe;
alias NFFITracksHandler = void delegate(NFFITrack[] tracks) @safe;

alias NFFIPublishDelegate = NFFIResult delegate(
  NFFIConfig config,
  NFFITrack track
) @safe;

alias NFFIGetDelegate = NFFITrack delegate(
  NFFIConfig config,
  string unitId
) @safe;

alias NFFISyncDelegate = NFFITrack[] delegate(
  NFFIConfig config,
  string areaId
) @safe;

interface INFFIService {
  bool configure(NFFIConfig config);
  NFFIConfig config() const;

  bool setPublishProvider(NFFIPublishDelegate provider);
  bool setGetProvider(NFFIGetDelegate provider);
  bool setSyncProvider(NFFISyncDelegate provider);

  NFFIResult publishTrack(NFFITrack track);
  NFFITrack getTrack(string unitId);
  NFFITrack[] synchronizeArea(string areaId);

  bool getTrackAsync(string unitId, NFFITrackHandler handler);
  bool synchronizeAreaAsync(string areaId, NFFITracksHandler handler);
  bool publishTrackAsync(NFFITrack track, NFFIResultHandler handler);

  string encodeTrack(NFFITrack track);
  NFFITrack decodeTrack(string payload);
}
