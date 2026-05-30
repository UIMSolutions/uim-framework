/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.snmp.interfaces.client;

@safe:

enum SNMPVersion : ubyte {
  v1 = 0,
  v2c = 1,
  v3 = 2
}

enum SNMPSecurityLevel : ubyte {
  noAuthNoPriv = 0,
  authNoPriv = 1,
  authPriv = 2
}

struct SNMPConfig {
  string host;
  ushort port = 161;
  SNMPVersion snmpVersion = SNMPVersion.v2c;
  SNMPSecurityLevel securityLevel = SNMPSecurityLevel.noAuthNoPriv;
  string community = "public";
  string username;
  string authPassword;
  string privPassword;
  uint timeoutMs = 5_000;
}

struct SNMPOidValue {
  string oid;
  string typeTag;
  string value;
  long timestamp;
}

struct SNMPResult {
  bool success;
  ushort statusCode;
  string message;
}

alias SNMPResultHandler = void delegate(SNMPResult result) @safe;
alias SNMPOidValueHandler = void delegate(SNMPOidValue value) @safe;
alias SNMPOidValuesHandler = void delegate(SNMPOidValue[] values) @safe;

alias SNMPGetDelegate = SNMPOidValue delegate(
  SNMPConfig config,
  string oid
) @safe;

alias SNMPWalkDelegate = SNMPOidValue[] delegate(
  SNMPConfig config,
  string rootOid,
  uint maxRepetitions
) @safe;

alias SNMPSetDelegate = SNMPResult delegate(
  SNMPConfig config,
  string oid,
  string value,
  string typeTag
) @safe;

interface ISNMPService {
  bool configure(SNMPConfig config);
  SNMPConfig config() const;

  bool setGetProvider(SNMPGetDelegate provider);
  bool setWalkProvider(SNMPWalkDelegate provider);
  bool setSetProvider(SNMPSetDelegate provider);

  SNMPOidValue get(string oid);
  SNMPOidValue[] walk(string rootOid, uint maxRepetitions = 25);
  SNMPResult set(string oid, string value, string typeTag = "s");

  bool getAsync(string oid, SNMPOidValueHandler handler);
  bool walkAsync(string rootOid, uint maxRepetitions, SNMPOidValuesHandler handler);
  bool setAsync(string oid, string value, string typeTag, SNMPResultHandler handler);

  SNMPOidValue parseOidLine(string line, string fallbackOid = "");
}
