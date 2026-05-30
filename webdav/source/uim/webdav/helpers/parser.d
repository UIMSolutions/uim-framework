/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.webdav.helpers.parser;

import std.conv : to;
import std.regex : matchAll, matchFirst;
import std.string : strip;

import uim.webdav.interfaces.client;

@safe:

WebDAVResource[] webdavParsePropfindResponse(string xmlContent) {
  WebDAVResource[] result;

  foreach (responseBlock; matchAll(xmlContent, `(?s)<d:response>(.*?)</d:response>`)) {
    if (responseBlock.captures.length < 2) {
      continue;
    }

    auto block = responseBlock.captures[1];
    WebDAVResource resource;

    auto hrefMatch = matchFirst(block, `(?s)<d:href>(.*?)</d:href>`);
    if (!hrefMatch.empty && hrefMatch.captures.length >= 2) {
      resource.href = hrefMatch.captures[1].strip();
    }

    resource.collection = !matchFirst(block, `(?s)<d:collection\s*/>`).empty;

    auto lengthMatch = matchFirst(block, `(?s)<d:getcontentlength>(.*?)</d:getcontentlength>`);
    if (!lengthMatch.empty && lengthMatch.captures.length >= 2) {
      try {
        resource.contentLength = lengthMatch.captures[1].strip().to!ulong;
      } catch (Exception) {
      }
    }

    auto typeMatch = matchFirst(block, `(?s)<d:getcontenttype>(.*?)</d:getcontenttype>`);
    if (!typeMatch.empty && typeMatch.captures.length >= 2) {
      resource.contentType = typeMatch.captures[1].strip();
    }

    auto etagMatch = matchFirst(block, `(?s)<d:getetag>(.*?)</d:getetag>`);
    if (!etagMatch.empty && etagMatch.captures.length >= 2) {
      resource.etag = etagMatch.captures[1].strip();
    }

    auto modifiedMatch = matchFirst(block, `(?s)<d:getlastmodified>(.*?)</d:getlastmodified>`);
    if (!modifiedMatch.empty && modifiedMatch.captures.length >= 2) {
      resource.lastModified = modifiedMatch.captures[1].strip();
    }

    if (resource.href.length > 0) {
      result ~= resource;
    }
  }

  return result;
}

unittest {
  auto xml = `<?xml version="1.0"?>
<d:multistatus xmlns:d="DAV:">
  <d:response>
    <d:href>/dav/docs/</d:href>
    <d:propstat>
      <d:prop>
        <d:resourcetype><d:collection/></d:resourcetype>
      </d:prop>
    </d:propstat>
  </d:response>
  <d:response>
    <d:href>/dav/docs/readme.txt</d:href>
    <d:propstat>
      <d:prop>
        <d:getcontentlength>120</d:getcontentlength>
        <d:getcontenttype>text/plain</d:getcontenttype>
      </d:prop>
    </d:propstat>
  </d:response>
</d:multistatus>`;

  auto resources = webdavParsePropfindResponse(xml);
  assert(resources.length == 2);
  assert(resources[0].collection);
  assert(resources[1].contentLength == 120);
}
