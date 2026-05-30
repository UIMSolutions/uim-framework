/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.smtp.models.message;

import uim.smtp;

mixin(ShowModule!());

@safe:

class UIMSMTPMessage : UIMObject, ISMTPMessage {
  private SMTPAddress _from;
  private SMTPAddress[] _to;
  private SMTPAddress[] _cc;
  private SMTPAddress[] _bcc;
  private string _replyTo;
  private string _subject;
  private string _textBody;
  private string _htmlBody;

  SMTPAddress from() {
    return _from;
  }

  ISMTPMessage from(SMTPAddress value) {
    _from = value;
    return this;
  }

  SMTPAddress[] to() {
    return _to.dup;
  }

  ISMTPMessage to(const(SMTPAddress)[] value) {
    _to = value.dup;
    return this;
  }

  ISMTPMessage addTo(SMTPAddress value) {
    if (value.email.length > 0) {
      _to ~= value;
    }

    return this;
  }

  SMTPAddress[] cc() {
    return _cc.dup;
  }

  ISMTPMessage cc(const(SMTPAddress)[] value) {
    _cc = value.dup;
    return this;
  }

  ISMTPMessage addCc(SMTPAddress value) {
    if (value.email.length > 0) {
      _cc ~= value;
    }

    return this;
  }

  SMTPAddress[] bcc() {
    return _bcc.dup;
  }

  ISMTPMessage bcc(const(SMTPAddress)[] value) {
    _bcc = value.dup;
    return this;
  }

  ISMTPMessage addBcc(SMTPAddress value) {
    if (value.email.length > 0) {
      _bcc ~= value;
    }

    return this;
  }

  string replyTo() {
    return _replyTo;
  }

  ISMTPMessage replyTo(string value) {
    _replyTo = value;
    return this;
  }

  string subject() {
    return _subject;
  }

  ISMTPMessage subject(string value) {
    _subject = value;
    return this;
  }

  string textBody() {
    return _textBody;
  }

  ISMTPMessage textBody(string value) {
    _textBody = value;
    return this;
  }

  string htmlBody() {
    return _htmlBody;
  }

  ISMTPMessage htmlBody(string value) {
    _htmlBody = value;
    return this;
  }

  bool isValid() {
    return _from.email.length > 0 && _to.length > 0 && (_textBody.length > 0 || _htmlBody.length > 0);
  }
}

ISMTPMessage SMTPMessage() {
  return new UIMSMTPMessage();
}

unittest {
  auto message = SMTPMessage()
    .from(SMTPAddress("sender@example.org", "Sender"))
    .addTo(SMTPAddress("receiver@example.org", "Receiver"))
    .subject("Hello")
    .textBody("Payload");

  assert(message.isValid());
  assert(message.to().length == 1);
}
