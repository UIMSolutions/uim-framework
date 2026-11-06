/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.domain.enumerations.authmethod;

import uim.service;

mixin(ShowModule!());

@safe:

/// Authentication method supported by the platform.
enum AuthMethod {
  form, // Form-based authentication
  spnego, // SPNEGO authentication
  social, // Social login authentication
  certificate, // Certificate-based authentication
  saml, // SAML authentication
  oidc, // OpenID Connect authentication
  apiKey, // API key authentication
}

AuthMethod toAuthMethod(string value) {
  mixin(EnumSwitch("AuthMethod", "form"));
}
AuthMethod[] toAuthMethod(string[] values) {
  return values.map!(toAuthMethod).array;
}
string toString(AuthMethod method) {
  return method.to!string;
}
string[] toString(AuthMethod[] methods) {
  return methods.map!toString.array;
}
unittest {
  assert(AuthMethod.form.to!string == "form");
  assert(AuthMethod.spnego.to!string == "spnego");
  assert(AuthMethod.social.to!string == "social");
  assert(AuthMethod.certificate.to!string == "certificate");
  assert(AuthMethod.saml.to!string == "saml");
  assert(AuthMethod.oidc.to!string == "oidc");
  assert(AuthMethod.apiKey.to!string == "apiKey");

  assert("form".to!AuthMethod == AuthMethod.form);
  assert("spnego".to!AuthMethod == AuthMethod.spnego);
  assert("social".to!AuthMethod == AuthMethod.social);
  assert("certificate".to!AuthMethod == AuthMethod.certificate);
  assert("saml".to!AuthMethod == AuthMethod.saml);
  assert("oidc".to!AuthMethod == AuthMethod.oidc);
  assert("apiKey".to!AuthMethod == AuthMethod.apiKey);

  assert("form".toAuthMethod == AuthMethod.form);
  assert("spnego".toAuthMethod == AuthMethod.spnego);
  assert("social".toAuthMethod == AuthMethod.social);
  assert("certificate".toAuthMethod == AuthMethod.certificate);
  assert("saml".toAuthMethod == AuthMethod.saml);
  assert("oidc".toAuthMethod == AuthMethod.oidc);
  assert("apiKey".toAuthMethod == AuthMethod.apiKey);
  assert("noexists".toAuthMethod == AuthMethod.form); // Default case
  assert("".toAuthMethod == AuthMethod.form); // Default case

  assert(toString(AuthMethod.form) == "form");
  assert(toString(AuthMethod.spnego) == "spnego");
  assert(toString(AuthMethod.social) == "social");
  assert(toString(AuthMethod.certificate) == "certificate");
  assert(toString(AuthMethod.saml) == "saml");
  assert(toString(AuthMethod.oidc) == "oidc");
  assert(toString(AuthMethod.apiKey) == "apiKey");  

  assert(["form", "spnego", "social", "certificate", "saml", "oidc", "apiKey"].toAuthMethod == [AuthMethod.form, AuthMethod.spnego, AuthMethod.social, AuthMethod.certificate, AuthMethod.saml, AuthMethod.oidc, AuthMethod.apiKey]);
  assert([AuthMethod.form, AuthMethod.spnego, AuthMethod.social, AuthMethod.certificate, AuthMethod.saml, AuthMethod.oidc, AuthMethod.apiKey].toString == ["form", "spnego", "social", "certificate", "saml", "oidc", "apiKey"]);
}
