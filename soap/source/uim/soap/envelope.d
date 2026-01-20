/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.soap.envelope;

import uim.soap;
import std.algorithm;
import std.array;

@safe:

/**
 * SOAP Envelope - root element of a SOAP message
 */
class DSOAPEnvelope : UIMObject {
    protected DSOAPHeader _header;
    protected DSOAPBody _body;
    protected SOAPVersion _version;
    
    @property DSOAPHeader header() { return _header; }
    @property void header(DSOAPHeader value) { _header = value; }
    
    @property DSOAPBody body_() { return _body; }
    @property void body_(DSOAPBody value) { _body = value; }
    
    @property SOAPVersion version_() { return _version; }
    @property void version_(SOAPVersion value) { _version = value; }
    
    this() {
        super();
        this._header = new DSOAPHeader();
        this._body = new DSOAPBody();
        this._version = SOAPVersion.SOAP11;
    }
    
    this(SOAPVersion ver) {
        this();
        this._version = ver;
    }
    
    /**
     * Convert to XML
     */
    string toXML() {
        string result = `<?xml version="1.0" encoding="UTF-8"?>` ~ "\n";
        
        string prefix = _version == SOAPVersion.SOAP11 ? "soap" : "env";
        string ns = getEnvelopeNamespace(_version);
        
        result ~= "<" ~ prefix ~ ":Envelope xmlns:" ~ prefix ~ "=\"" ~ ns ~ "\">\n";
        
        // Add header if not empty
        if (!_header.isEmpty()) {
            result ~= _header.toXML(1, _version);
        }
        
        // Add body
        result ~= _body.toXML(1, _version);
        
        result ~= "</" ~ prefix ~ ":Envelope>\n";
        
        return result;
    }
}
