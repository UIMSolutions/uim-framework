/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.ldap.connection;

import vibe.core.net  : connectTCP, TCPConnection;
import vibe.core.log  : logDiagnostic, logWarn;

import uim.ldap;

mixin(ShowModule!());

// ---------------------------------------------------------------------------
// UIMGrpcUnaryChannel-style LDAP connection
// Uses vibe.d TCP for transport.  Protocol encoding is BER/ASN.1 per RFC 4511;
// the layer here provides a clean D API — the wire encoding is handled via the
// helpers.encoding module, while the TCP reads / writes use vibe.d streams.
// ---------------------------------------------------------------------------

class UIMGrpcUnaryChannelLdapConnection : UIMObject, ILdapConnection {

  private {
    string        _host;
    ushort        _port;
    bool          _useTLS;
    TCPConnection _tcp;
    bool          _connected   = false;
    bool          _bound       = false;
    int           _messageId   = 1;
  }

  this(string host = "localhost", ushort port = 389, bool useTLS = false) @safe {
    _host   = host;
    _port   = port;
    _useTLS = useTLS;
  }

  // ---- ILdapConnection properties ----------------------------------------

  @property bool   connected() const @safe { return _connected; }
  @property string host()      const @safe { return _host; }
  @property ushort port()      const @safe { return _port; }
  @property bool   useTLS()    const @safe { return _useTLS; }

  // ---- Connect / disconnect -----------------------------------------------

  bool connect() @safe {
    if (_connected) {
      return true;
    }

    try {
      // vibe.d TCP connect — TLS upgrade requires vibe-tls; flag recorded here
      _tcp       = () @trusted { return connectTCP(_host, _port); }();
      _connected = true;
      logDiagnostic("LDAP: connected to %s:%d (TLS=%s)", _host, _port, _useTLS);
      return true;
    } catch (Exception ex) {
      logWarn("LDAP: connect failed — %s", ex.msg);
      _connected = false;
      return false;
    }
  }

  void disconnect() @safe {
    if (_connected) {
      try {
        // send unbind notice before closing (best effort)
        _sendUnbindNotice();
        () @trusted { _tcp.close(); }();
      } catch (Exception) {}
      _connected = false;
      _bound     = false;
      logDiagnostic("LDAP: disconnected from %s:%d", _host, _port);
    }
  }

  // ---- LDAP operations ----------------------------------------------------

  LdapResult bind(LdapBindRequest request) @safe {
    if (!_connected) {
      return LdapFailure(LdapResultCode.unavailable, "Not connected");
    }

    try {
      auto msgId = _nextMessageId();
      auto pdu   = _encodeBind(msgId, request);
      _sendPDU(pdu);

      auto response = _receivePDU();
      auto result   = _decodeResult(response);
      _bound = result.success();
      return result;
    } catch (Exception ex) {
      return LdapFailure(LdapResultCode.other, ex.msg);
    }
  }

  LdapResult unbind() @safe {
    if (!_connected) {
      return LdapSuccess();
    }

    try {
      _sendUnbindNotice();
      _bound = false;
      return LdapSuccess();
    } catch (Exception ex) {
      return LdapFailure(LdapResultCode.other, ex.msg);
    }
  }

  LdapSearchResult search(LdapSearchRequest request) @safe {
    LdapSearchResult searchResult;
    searchResult.result = LdapSuccess();

    if (!_connected || !_bound) {
      searchResult.result = LdapFailure(
        _connected ? LdapResultCode.insufficientAccessRights : LdapResultCode.unavailable,
        _connected ? "Not bound" : "Not connected"
      );
      return searchResult;
    }

    try {
      auto msgId = _nextMessageId();
      auto pdu   = _encodeSearch(msgId, request);
      _sendPDU(pdu);

      // Receive entries and final SearchResultDone
      while (true) {
        auto response = _receivePDU();
        if (response.length == 0) { break; }

        ubyte tag = response[0];
        // SearchResultEntry = 0x64, SearchResultDone = 0x65
        if (tag == 0x65) {
          searchResult.result = _decodeResult(response);
          break;
        } else if (tag == 0x64) {
          auto entry = _decodeEntry(response);
          searchResult.entries ~= entry;
        } else {
          // unknown tag — stop
          break;
        }
      }
    } catch (Exception ex) {
      searchResult.result = LdapFailure(LdapResultCode.other, ex.msg);
    }
    return searchResult;
  }

  LdapResult add(LdapAddRequest request) @safe {
    return _simpleOperation(_encodeAdd(_nextMessageId(), request));
  }

  LdapResult modify(LdapModifyRequest request) @safe {
    return _simpleOperation(_encodeModify(_nextMessageId(), request));
  }

  LdapResult remove(LdapDeleteRequest request) @safe {
    return _simpleOperation(_encodeDelete(_nextMessageId(), request));
  }

  LdapResult modifyDN(LdapModifyDNRequest request) @safe {
    return _simpleOperation(_encodeModifyDN(_nextMessageId(), request));
  }

  LdapCompareResult compare(LdapCompareRequest request) @safe {
    LdapCompareResult cmpResult;
    cmpResult.result = LdapSuccess();

    if (!_connected || !_bound) {
      cmpResult.result = LdapFailure(
        _connected ? LdapResultCode.insufficientAccessRights : LdapResultCode.unavailable,
        _connected ? "Not bound" : "Not connected"
      );
      return cmpResult;
    }

    try {
      auto pdu    = _encodeCompare(_nextMessageId(), request);
      _sendPDU(pdu);
      auto resp   = _receivePDU();
      auto result = _decodeResult(resp);
      cmpResult.result  = result;
      cmpResult.matched = result.resultCode == LdapResultCode.compareTrue;
    } catch (Exception ex) {
      cmpResult.result = LdapFailure(LdapResultCode.other, ex.msg);
    }
    return cmpResult;
  }

  // =========================================================================
  // Internal: string → ubyte[] (trusted cast, safe since char == ubyte size)
  // =========================================================================

  private static ubyte[] _strBytes(string s) @trusted {
    return cast(ubyte[]) s;
  }

  // =========================================================================
  // Internal: message ID counter
  // =========================================================================

  private int _nextMessageId() @safe {
    return _messageId++;
  }

  // =========================================================================
  // Internal: simple send-and-receive wrapper
  // =========================================================================

  private LdapResult _simpleOperation(ubyte[] pdu) @safe {
    if (!_connected || !_bound) {
      return LdapFailure(
        _connected ? LdapResultCode.insufficientAccessRights : LdapResultCode.unavailable,
        _connected ? "Not bound" : "Not connected"
      );
    }

    try {
      _sendPDU(pdu);
      auto response = _receivePDU();
      return _decodeResult(response);
    } catch (Exception ex) {
      return LdapFailure(LdapResultCode.other, ex.msg);
    }
  }

  // =========================================================================
  // Internal: TCP send / receive
  // =========================================================================

  private void _sendPDU(ubyte[] data) @trusted {
    _tcp.write(data);
  }

  private ubyte[] _receivePDU() @trusted {
    // Read the outer SEQUENCE tag (0x30) + BER length
    ubyte[2] header;
    _tcp.read(header[]);
    if (header[0] != 0x30) {
      return null;
    }

    size_t consumed;
    size_t contentLen;

    if ((header[1] & 0x80) == 0) {
      // Short form
      consumed   = 0;
      contentLen = header[1];
    } else {
      // Long form — read additional length bytes
      ubyte numBytes = header[1] & 0x7F;
      ubyte[] lenBuf = new ubyte[](numBytes);
      _tcp.read(lenBuf);
      contentLen = 0;
      foreach (b; lenBuf) {
        contentLen = (contentLen << 8) | b;
      }
    }

    if (contentLen == 0) {
      return null;
    }

    auto content = new ubyte[](contentLen);
    _tcp.read(content);

    // Return the full PDU including the outer tag byte (not the outer length
    // — the decoders below operate on the content portion directly).
    // The first byte of content is the message-id integer tag (0x02).
    // For uniformity we return just the content so decoders can parse it.
    return content;
  }

  // =========================================================================
  // Internal: PDU encoder stubs
  //
  // These produce minimal but valid BER-encoded LDAPMessage PDUs per RFC 4511.
  // A production library would use a full ASN.1/BER codec; here we hand-encode
  // the most common structures so the connection class is self-contained and
  // easily testable without external ASN.1 libraries.
  // =========================================================================

  private ubyte[] _berInt(int value) @safe {
    if (value >= 0 && value <= 127) {
      return [0x02, 0x01, cast(ubyte) value];
    }
    // 2-byte integer
    return [0x02, 0x02, cast(ubyte)((value >> 8) & 0xFF), cast(ubyte)(value & 0xFF)];
  }

  private ubyte[] _berOctetString(string value) @trusted {
    auto bytes = cast(ubyte[]) value;
    return [cast(ubyte) 0x04] ~ berEncodeLength(bytes.length) ~ bytes;
  }

  private ubyte[] _berSequence(ubyte[] content) @safe {
    return [cast(ubyte) 0x30] ~ berEncodeLength(content.length) ~ content;
  }

  private ubyte[] _berTagged(ubyte tag, ubyte[] content) @safe {
    return [tag] ~ berEncodeLength(content.length) ~ content;
  }

  private ubyte[] _ldapMessage(int msgId, ubyte[] protocolOp) @safe {
    return _berSequence(_berInt(msgId) ~ protocolOp);
  }

  // BindRequest (APPLICATION 0)
  private ubyte[] _encodeBind(int msgId, LdapBindRequest request) @safe {
    auto version_  = _berInt(request.version_)[2 .. $]; // raw integer value only
    auto dn        = _berOctetString(request.dn);
    // Simple authentication [0] OCTET STRING
    auto auth      = _berTagged(0x80, _strBytes(request.password));
    auto bindBody  = [cast(ubyte) 0x02, cast(ubyte) 0x01, cast(ubyte) request.version_]  // version INTEGER
                   ~ _berOctetString(request.dn)                  // name LDAPDN
                   ~ auth;                                        // authentication
    return _ldapMessage(msgId, _berTagged(0x60, bindBody));       // [APPLICATION 0]
  }

  // UnbindRequest (APPLICATION 2) — no response expected
  private ubyte[] _encodeUnbind(int msgId) @safe {
    return _ldapMessage(msgId, [0x42, 0x00]);  // APPLICATION 2, empty
  }

  // SearchRequest (APPLICATION 3)
  private ubyte[] _encodeSearch(int msgId, LdapSearchRequest request) @safe {
    import std.conv : to;
    auto body_ =
        _berOctetString(request.baseDN)
      ~ [cast(ubyte) 0x0A, cast(ubyte) 0x01, cast(ubyte) request.scope_]
      ~ [cast(ubyte) 0x0A, cast(ubyte) 0x01, cast(ubyte) request.derefAliases]
      ~ _berInt(request.sizeLimit)
      ~ _berInt(request.timeLimit)
      ~ [cast(ubyte) 0x01, cast(ubyte) 0x01, request.typesOnly ? cast(ubyte) 0xFF : cast(ubyte) 0x00]
      ~ _encodeFilter(request.filter)
      ~ _encodeAttributeList(request.attributes);
    return _ldapMessage(msgId, _berTagged(0x63, body_));  // [APPLICATION 3]
  }

  // AddRequest (APPLICATION 8)
  private ubyte[] _encodeAdd(int msgId, LdapAddRequest request) @safe {
    auto attrs = _encodeAttributeList2(request.attributes);
    auto body_ = _berOctetString(request.dn) ~ _berSequence(attrs);
    return _ldapMessage(msgId, _berTagged(0x68, body_));  // [APPLICATION 8]
  }

  // ModifyRequest (APPLICATION 6)
  private ubyte[] _encodeModify(int msgId, LdapModifyRequest request) @safe {
    ubyte[] changes;
    foreach (ref change; request.changes) {
      ubyte[] vals;
      foreach (v; change.modification.values) {
        vals ~= _berOctetString(v);
      }
      auto attrSeq = _berOctetString(change.modification.type)
                   ~ _berTagged(0x31, vals);
      changes ~= _berSequence([cast(ubyte) 0x0A, cast(ubyte) 0x01, cast(ubyte) change.operation] ~ _berSequence(attrSeq));
    }
    auto body_ = _berOctetString(request.dn) ~ _berTagged(0x30, changes);
    return _ldapMessage(msgId, _berTagged(0x66, body_));  // [APPLICATION 6]
  }

  // DelRequest (APPLICATION 10)
  private ubyte[] _encodeDelete(int msgId, LdapDeleteRequest request) @safe {
    auto dnBytes = _strBytes(request.dn);
    auto op      = [cast(ubyte) 0x4A] ~ berEncodeLength(dnBytes.length) ~ dnBytes;  // [APPLICATION 10] IMPLICIT
    return _ldapMessage(msgId, op);
  }

  // ModifyDNRequest (APPLICATION 12)
  private ubyte[] _encodeModifyDN(int msgId, LdapModifyDNRequest request) @safe {
    auto body_ = _berOctetString(request.dn)
               ~ _berOctetString(request.newRDN)
               ~ [cast(ubyte) 0x01, cast(ubyte) 0x01, request.deleteOldRDN ? cast(ubyte) 0xFF : cast(ubyte) 0x00];
    if (request.newSuperior.length > 0) {
      body_ ~= _berTagged(0x80, _strBytes(request.newSuperior));
    }
    return _ldapMessage(msgId, _berTagged(0x6C, body_));  // [APPLICATION 12]
  }

  // CompareRequest (APPLICATION 14)
  private ubyte[] _encodeCompare(int msgId, LdapCompareRequest request) @safe {
    auto ava   = _berOctetString(request.attributeType)
               ~ _berOctetString(request.assertionValue);
    auto body_ = _berOctetString(request.dn) ~ _berSequence(ava);
    return _ldapMessage(msgId, _berTagged(0x6E, body_));  // [APPLICATION 14]
  }

  // Simple filter encoder: supports equality, presence, and boolean operators
  private ubyte[] _encodeFilter(string filter) @safe {
    import std.string : strip;
    auto f = filter.strip;
    if (f.length < 2 || f[0] != '(' || f[$ - 1] != ')') {
      // Default: present filter for objectClass
      return _berTagged(0x87, _strBytes("objectClass"));  // [7] IMPLICIT
    }
    auto inner = f[1 .. $ - 1];
    // AND, OR, NOT
    if (inner.length > 0 && inner[0] == '&') {
      return _berTagged(0xA0, _encodeFilterList(inner[1 .. $]));
    }
    if (inner.length > 0 && inner[0] == '|') {
      return _berTagged(0xA1, _encodeFilterList(inner[1 .. $]));
    }
    if (inner.length > 0 && inner[0] == '!') {
      return _berTagged(0xA2, _encodeFilter(inner[1 .. $]));
    }
    // Presence: type=*
    import std.string : indexOf;
    auto eqIdx = inner.indexOf('=');
    if (eqIdx > 0) {
      auto attrType = inner[0 .. eqIdx];
      auto value    = inner[eqIdx + 1 .. $];
      if (value == "*") {
        // present [7] IMPLICIT LDAPOID
        return _berTagged(0x87, _strBytes(attrType));
      }
      // Equality [3] IMPLICIT AttributeValueAssertion
      auto ava = _berOctetString(attrType) ~ _berOctetString(value);
      return _berTagged(0xA3, ava);
    }
    // Fallback: present for objectClass
    return _berTagged(0x87, _strBytes("objectClass"));
  }

  private ubyte[] _encodeFilterList(string filters) @safe {
    // Split by top-level parenthesized expressions
    ubyte[] result;
    size_t i = 0;
    while (i < filters.length) {
      if (filters[i] == '(') {
        auto end = _findMatchingParen(filters, i);
        if (end > i) {
          result ~= _encodeFilter(filters[i .. end + 1]);
          i = end + 1;
        } else {
          i++;
        }
      } else {
        i++;
      }
    }
    return result;
  }

  private size_t _findMatchingParen(string s, size_t start) @safe {
    int depth = 0;
    foreach (i; start .. s.length) {
      if (s[i] == '(') { depth++; }
      else if (s[i] == ')') {
        depth--;
        if (depth == 0) { return i; }
      }
    }
    return start;
  }

  // Encode attribute description list for SearchRequest
  private ubyte[] _encodeAttributeList(string[] attrs) @safe {
    ubyte[] result;
    foreach (a; attrs) {
      result ~= _berOctetString(a);
    }
    return _berSequence(result);
  }

  // Encode attribute list for AddRequest
  private ubyte[] _encodeAttributeList2(LdapAttribute[] attrs) @safe {
    ubyte[] result;
    foreach (ref a; attrs) {
      ubyte[] vals;
      foreach (v; a.values) {
        vals ~= _berOctetString(v);
      }
      result ~= _berSequence(_berOctetString(a.type) ~ _berTagged(0x31, vals));
    }
    return result;
  }

  // =========================================================================
  // Internal: PDU decoders
  // =========================================================================

  private LdapResult _decodeResult(ubyte[] content) @safe {
    // content starts with messageId INTEGER, then protocolOp
    // We skip over messageId and parse the result code from the op body.
    // Minimal: locate the first 0x0A (ENUMERATED) after the op tag.
    LdapResult result;
    result.resultCode = LdapResultCode.other;

    size_t i = 0;
    // Skip messageId (tag 0x02)
    i = _skipBerTLV(content, i);
    if (i >= content.length) { return result; }

    // Protocol op tag + length
    if (i >= content.length) { return result; }
    i++; // skip tag
    size_t consumed;
    auto opLen = berDecodeLength(content[i .. $], consumed);
    i += consumed;
    auto opEnd = i + opLen;

    // Inside the op: first element should be resultCode ENUMERATED (0x0A)
    if (i < content.length && content[i] == 0x0A) {
      i++;
      if (i < content.length) {
        size_t c2;
        auto enumLen = berDecodeLength(content[i .. $], c2);
        i += c2;
        if (i < content.length) {
          result.resultCode = cast(LdapResultCode) content[i];
          i += enumLen;
        }
      }
    }

    // matchedDN OCTET STRING
    if (i < opEnd && i < content.length && content[i] == 0x04) {
      i++;
      size_t c3;
      auto strLen = berDecodeLength(content[i .. $], c3);
      i += c3;
      if (i + strLen <= content.length) {
        result.matchedDN = cast(string) content[i .. i + strLen].idup;
        i += strLen;
      }
    }

    // diagnosticMessage OCTET STRING
    if (i < opEnd && i < content.length && content[i] == 0x04) {
      i++;
      size_t c4;
      auto strLen = berDecodeLength(content[i .. $], c4);
      i += c4;
      if (i + strLen <= content.length) {
        result.diagnosticMessage = cast(string) content[i .. i + strLen].idup;
      }
    }

    if (result.diagnosticMessage.length == 0) {
      result.diagnosticMessage = ldapResultText(result.resultCode);
    }

    return result;
  }

  private LdapEntry _decodeEntry(ubyte[] content) @safe {
    LdapEntry entry;

    size_t i = 0;
    // Skip messageId
    i = _skipBerTLV(content, i);
    if (i >= content.length) { return entry; }

    // Op tag (SearchResultEntry = APPLICATION 4 = 0x64) + length
    i++;  // skip tag
    size_t consumed;
    auto opLen = berDecodeLength(content[i .. $], consumed);
    i += consumed;
    auto opEnd = i + opLen;

    // objectName OCTET STRING
    if (i < opEnd && content[i] == 0x04) {
      i++;
      size_t c2;
      auto l = berDecodeLength(content[i .. $], c2);
      i += c2;
      entry.dn = cast(string) content[i .. i + l].idup;
      i += l;
    }

    // attributes SEQUENCE OF PartialAttribute
    if (i < opEnd && content[i] == 0x30) {
      i++;
      size_t c3;
      auto seqLen = berDecodeLength(content[i .. $], c3);
      i += c3;
      auto seqEnd = i + seqLen;

      while (i < seqEnd && i < content.length) {
        LdapAttribute attr;
        // Each PartialAttribute is SEQUENCE { type, vals SET }
        if (content[i] != 0x30) { break; }
        i++;
        size_t c4;
        auto attrLen = berDecodeLength(content[i .. $], c4);
        i += c4;
        auto attrEnd = i + attrLen;

        // type OCTET STRING
        if (i < attrEnd && content[i] == 0x04) {
          i++;
          size_t c5;
          auto l = berDecodeLength(content[i .. $], c5);
          i += c5;
          attr.type = cast(string) content[i .. i + l].idup;
          i += l;
        }

        // vals SET OF OCTET STRING
        if (i < attrEnd && content[i] == 0x31) {
          i++;
          size_t c6;
          auto setLen = berDecodeLength(content[i .. $], c6);
          i += c6;
          auto setEnd = i + setLen;
          while (i < setEnd && i < content.length) {
            if (content[i] == 0x04) {
              i++;
              size_t c7;
              auto l = berDecodeLength(content[i .. $], c7);
              i += c7;
              attr.values ~= cast(string) content[i .. i + l].idup;
              i += l;
            } else {
              i++;
            }
          }
        }
        entry.attributes ~= attr;
        i = attrEnd;
      }
    }

    return entry;
  }

  private size_t _skipBerTLV(const(ubyte)[] buf, size_t start) @safe {
    if (start >= buf.length) { return start; }
    auto i = start + 1; // skip tag
    size_t consumed;
    auto len = berDecodeLength(buf[i .. $], consumed);
    return i + consumed + len;
  }

  // =========================================================================
  // Internal: send unbind without waiting for response
  // =========================================================================

  private void _sendUnbindNotice() @safe {
    if (_connected) {
      try {
        auto pdu = _encodeUnbind(_nextMessageId());
        _sendPDU(pdu);
      } catch (Exception) {}
    }
  }
}

// ---------------------------------------------------------------------------
// Factory function
// ---------------------------------------------------------------------------

/// Create a new LDAP connection object (not yet connected)
UIMGrpcUnaryChannelLdapConnection LdapConnection(
  string host    = "localhost",
  ushort port    = 389,
  bool   useTLS  = false
) @safe {
  return new UIMGrpcUnaryChannelLdapConnection(host, port, useTLS);
}

/// Create a new LDAPS connection object (LDAP over TLS, default port 636)
UIMGrpcUnaryChannelLdapConnection LdapsConnection(
  string host = "localhost",
  ushort port = 636
) @safe {
  return new UIMGrpcUnaryChannelLdapConnection(host, port, true);
}

unittest {
  // Construction only — no network needed
  auto conn = LdapConnection("localhost", 389);
  assert(!conn.connected);
  assert(conn.host == "localhost");
  assert(conn.port == 389);
  assert(!conn.useTLS);

  auto tlsConn = LdapsConnection("ldap.example.com");
  assert(tlsConn.port == 636);
  assert(tlsConn.useTLS);
}
