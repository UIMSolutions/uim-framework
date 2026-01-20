/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.soap.version_;

import uim.soap;

@safe:

/**
 * SOAP protocol version
 */
enum SOAPVersion {
    SOAP11,  // SOAP 1.1
    SOAP12   // SOAP 1.2
}

/**
 * Get namespace URI for SOAP version
 */
string getEnvelopeNamespace(SOAPVersion ver) {
    final switch (ver) {
        case SOAPVersion.SOAP11:
            return "http://schemas.xmlsoap.org/soap/envelope/";
        case SOAPVersion.SOAP12:
            return "http://www.w3.org/2003/05/soap-envelope";
    }
}

/**
 * Get encoding namespace for SOAP version
 */
string getEncodingNamespace(SOAPVersion ver) {
    final switch (ver) {
        case SOAPVersion.SOAP11:
            return "http://schemas.xmlsoap.org/soap/encoding/";
        case SOAPVersion.SOAP12:
            return "http://www.w3.org/2003/05/soap-encoding";
    }
}

/**
 * Get content type for SOAP version
 */
string getContentType(SOAPVersion ver) {
    final switch (ver) {
        case SOAPVersion.SOAP11:
            return "text/xml; charset=utf-8";
        case SOAPVersion.SOAP12:
            return "application/soap+xml; charset=utf-8";
    }
}
