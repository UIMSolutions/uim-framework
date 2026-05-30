/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.nffi.helpers.codec;

import std.conv : to;
import std.datetime : Clock, UTC;
import std.string : indexOf, split, strip;

import uim.nffi.interfaces;

@safe:

string nffiEncodeTrack(NFFITrack track) {
  return "UnitId=" ~ track.unitId
    ~ "|Callsign=" ~ track.callsign
    ~ "|Affiliation=" ~ track.affiliation
    ~ "|Symbol=" ~ track.symbolCode
    ~ "|Lat=" ~ to!string(track.latitude)
    ~ "|Lon=" ~ to!string(track.longitude)
    ~ "|Alt=" ~ to!string(track.altitude)
    ~ "|Ts=" ~ to!string(track.timestamp)
    ~ "|Source=" ~ track.source;
}

NFFITrack nffiDecodeTrack(string payload) {
  NFFITrack track;

  auto trimmed = payload.strip();
  if (trimmed.length == 0) {
    return track;
  }

  track.timestamp = Clock.currTime(UTC()).toUnixTime();

  foreach (token; trimmed.split("|")) {
    auto eqPos = token.indexOf("=");
    if (eqPos <= 0) {
      continue;
    }

    auto key = token[0 .. cast(size_t) eqPos].strip();
    auto value = token[cast(size_t) eqPos + 1 .. $].strip();

    if (key == "UnitId") {
      track.unitId = value;
    } else if (key == "Callsign") {
      track.callsign = value;
    } else if (key == "Affiliation") {
      track.affiliation = value;
    } else if (key == "Symbol") {
      track.symbolCode = value;
    } else if (key == "Lat") {
      try {
        track.latitude = value.to!double;
      } catch (Exception) {
      }
    } else if (key == "Lon") {
      try {
        track.longitude = value.to!double;
      } catch (Exception) {
      }
    } else if (key == "Alt") {
      try {
        track.altitude = value.to!double;
      } catch (Exception) {
      }
    } else if (key == "Ts") {
      try {
        track.timestamp = value.to!long;
      } catch (Exception) {
      }
    } else if (key == "Source") {
      track.source = value;
    }
  }

  return track;
}

unittest {
  NFFITrack source;
  source.unitId = "DEU-ARMY-0007";
  source.callsign = "EAGLE-7";
  source.affiliation = "Friendly";
  source.symbolCode = "SFGPUCI----K";
  source.latitude = 50.11;
  source.longitude = 8.68;
  source.altitude = 122.5;
  source.timestamp = 1710000000;
  source.source = "UIM:NFFI";

  auto encoded = nffiEncodeTrack(source);
  assert(encoded.length > 0);

  auto decoded = nffiDecodeTrack(encoded);
  assert(decoded.unitId == "DEU-ARMY-0007");
  assert(decoded.callsign == "EAGLE-7");
}
