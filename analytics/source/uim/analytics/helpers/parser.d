/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.analytics.helpers.parser;

import std.algorithm.searching : canFind;
import std.conv : to;
import std.string : split, splitLines, strip;

import uim.analytics.interfaces;

@safe:

AnalyticsPoint[] analyticsParseCsvSeries(
  string csvContent,
  string metric,
  char separator = ','
) {
  AnalyticsPoint[] values;

  if (csvContent.strip().length == 0 || metric.strip().length == 0) {
    return values;
  }

  auto lines = splitLines(csvContent);
  foreach (lineIndex, line; lines) {
    auto trimmed = line.strip();
    if (trimmed.length == 0) {
      continue;
    }

    if (lineIndex == 0 && trimmed.canFind("value")) {
      continue;
    }

    auto parts = trimmed.split(separator);
    if (parts.length == 0) {
      continue;
    }

    AnalyticsPoint point;
    point.metric = metric;
    point.dimension = "";

    try {
      if (parts.length >= 2) {
        point.timestamp = parts[0].strip().to!long;
        point.value = parts[1].strip().to!double;
      } else {
        point.timestamp = cast(long) lineIndex;
        point.value = parts[0].strip().to!double;
      }
    } catch (Exception) {
      continue;
    }

    if (parts.length >= 3) {
      point.dimension = parts[2].strip();
    }

    values ~= point;
  }

  return values;
}

unittest {
  auto csv = "timestamp,value,dimension\n1,10.0,eu\n2,20.0,eu\n";
  auto points = analyticsParseCsvSeries(csv, "sales");
  assert(points.length == 2);
  assert(points[0].value == 10.0);
  assert(points[1].dimension == "eu");
}
