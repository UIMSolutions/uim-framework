/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.edifact.helpers.codec;

import std.array : appender;
import std.string : split, strip;

import uim.edifact.interfaces;

@safe:

EDIFACTSegment edifactParseSegment(string line) {
  EDIFACTSegment segment;

  auto trimmed = line.strip();
  if (trimmed.length == 0) {
    return segment;
  }

  auto pieces = trimmed.split("+");
  if (pieces.length == 0) {
    return segment;
  }

  segment.tag = pieces[0].strip();
  foreach (idx; 1 .. pieces.length) {
    segment.elements ~= pieces[idx].strip();
  }

  return segment;
}

EDIFACTSegment[] edifactParseSegments(string interchange) {
  EDIFACTSegment[] segments;

  if (interchange.strip().length == 0) {
    return segments;
  }

  foreach (chunk; interchange.split("'")) {
    auto segment = edifactParseSegment(chunk);
    if (segment.tag.length > 0) {
      segments ~= segment;
    }
  }

  return segments;
}

string edifactSerializeSegments(const(EDIFACTSegment)[] segments) {
  auto buffer = appender!string();

  foreach (segment; segments) {
    if (segment.tag.length == 0) {
      continue;
    }

    buffer.put(segment.tag);
    foreach (element; segment.elements) {
      buffer.put('+');
      buffer.put(element);
    }
    buffer.put('\'');
  }

  return buffer.data;
}

unittest {
  auto parsed = edifactParseSegment("BGM+220+PO-100+9");
  assert(parsed.tag == "BGM");
  assert(parsed.elements.length == 3);

  auto list = edifactParseSegments("UNH+1+ORDERS:D:96A:UN'BGM+220+PO-100+9'");
  assert(list.length == 2);

  auto text = edifactSerializeSegments(list);
  assert(text.length > 0);
}
