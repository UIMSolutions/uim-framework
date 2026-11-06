/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.domain.enumerations.sso;

import uim.service;

mixin(ShowModule!());

@safe:
/// SSO protocol.
enum SsoProtocol {
  saml,
  oidc,
}

SsoProtocol toSsoProtocol(string value) {
  mixin(EnumSwitch("SsoProtocol", "saml"));
}
SsoProtocol[] toSsoProtocol(string[] values) {
  return values.map!toSsoProtocol.array;
}

string toString(SsoProtocol protocol) {
  return protocol.to!string;
}
string[] toString(SsoProtocol[] protocols) {
  return protocols.map!toString.array;
}
/// 
unittest {
  assert(SsoProtocol.saml.to!string == "saml");
  assert(SsoProtocol.oidc.to!string == "oidc");

  assert("saml".to!SsoProtocol == SsoProtocol.saml);
  assert("oidc".to!SsoProtocol == SsoProtocol.oidc);

  assert("saml".toSsoProtocol == SsoProtocol.saml);
  assert("oidc".toSsoProtocol == SsoProtocol.oidc);
  assert("noexists".toSsoProtocol == SsoProtocol.saml); // Default case
  assert("".toSsoProtocol == SsoProtocol.saml); // Default case

  assert(toString(SsoProtocol.saml) == "saml");
  assert(toString(SsoProtocol.oidc) == "oidc");

  assert(["saml", "oidc"].toSsoProtocol == [SsoProtocol.saml, SsoProtocol.oidc]);
  assert([SsoProtocol.saml, SsoProtocol.oidc].toString == ["saml", "oidc"]);
}

