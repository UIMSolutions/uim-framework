/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.smtp.interfaces.message;

@safe:

enum SMTPSecurity : ubyte {
  none = 0,
  startTLS = 1,
  tls = 2
}

enum SMTPAuthMode : ubyte {
  none = 0,
  plain = 1,
  login = 2
}

struct SMTPAddress {
  string email;
  string displayName;
}

struct SMTPServerConfig {
  string host;
  ushort port = 25;
  SMTPSecurity security = SMTPSecurity.none;
  SMTPAuthMode authMode = SMTPAuthMode.none;
  string username;
  string password;
  uint connectTimeoutMs = 5_000;
  uint commandTimeoutMs = 5_000;
}

struct SMTPResponse {
  ushort code;
  bool continued;
  string text;
}

struct SMTPResult {
  bool success;
  ushort code;
  string message;
  string transactionId;
}

interface ISMTPMessage {
  SMTPAddress from();
  ISMTPMessage from(SMTPAddress value);

  SMTPAddress[] to();
  ISMTPMessage to(const(SMTPAddress)[] value);
  ISMTPMessage addTo(SMTPAddress value);

  SMTPAddress[] cc();
  ISMTPMessage cc(const(SMTPAddress)[] value);
  ISMTPMessage addCc(SMTPAddress value);

  SMTPAddress[] bcc();
  ISMTPMessage bcc(const(SMTPAddress)[] value);
  ISMTPMessage addBcc(SMTPAddress value);

  string replyTo();
  ISMTPMessage replyTo(string value);

  string subject();
  ISMTPMessage subject(string value);

  string textBody();
  ISMTPMessage textBody(string value);

  string htmlBody();
  ISMTPMessage htmlBody(string value);

  bool isValid();
}

alias SMTPResultHandler = void delegate(SMTPResult result) @safe;
alias SMTPTransportDelegate = SMTPResult delegate(SMTPServerConfig config, string payload) @safe;

interface ISMTPService {
  bool configure(SMTPServerConfig config);
  SMTPServerConfig config() const;

  bool setTransport(SMTPTransportDelegate transport);

  string compose(ISMTPMessage message);
  SMTPResponse parseResponseLine(string line);
  SMTPResult send(ISMTPMessage message);
  bool sendAsync(ISMTPMessage message, SMTPResultHandler handler);
}
