/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.soap.fault;

import uim.soap;
import std.algorithm;
import std.array;

@safe:

/**
 * SOAP Fault codes
 */
enum SOAPFaultCode {
    VersionMismatch,  // Invalid SOAP version
    MustUnderstand,   // Required header not understood
    Client,           // Client error
    Server            // Server error
}

/**
 * SOAP Fault for error reporting
 */
class DSOAPFault : UIMObject {
    protected SOAPFaultCode _faultCode;
    protected string _faultString;
    protected string _faultActor;
    protected string _detail;
    protected SOAPVersion _version;
    
    @property SOAPFaultCode faultCode() { return _faultCode; }
    @property void faultCode(SOAPFaultCode value) { _faultCode = value; }
    
    @property string faultString() { return _faultString; }
    @property void faultString(string value) { _faultString = value; }
    
    @property string faultActor() { return _faultActor; }
    @property void faultActor(string value) { _faultActor = value; }
    
    @property string detail() { return _detail; }
    @property void detail(string value) { _detail = value; }
    
    @property SOAPVersion version_() { return _version; }
    @property void version_(SOAPVersion value) { _version = value; }
    
    this() {
        super();
        this._version = SOAPVersion.SOAP11;
    }
    
    this(SOAPFaultCode code, string message) {
        this();
        this._faultCode = code;
        this._faultString = message;
    }
    
    this(SOAPFaultCode code, string message, SOAPVersion ver) {
        this(code, message);
        this._version = ver;
    }
    
    private string escapeXML(string text) @trusted {
        return text
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&apos;");
    }
    
    private string getFaultCodeString() {
        string prefix = _version == SOAPVersion.SOAP11 ? "soap" : "env";
        final switch (_faultCode) {
            case SOAPFaultCode.VersionMismatch:
                return prefix ~ ":VersionMismatch";
            case SOAPFaultCode.MustUnderstand:
                return prefix ~ ":MustUnderstand";
            case SOAPFaultCode.Client:
                return prefix ~ ":Client";
            case SOAPFaultCode.Server:
                return prefix ~ ":Server";
        }
    }
    
    /**
     * Convert to XML
     */
    string toXML(int indent = 0) {
        string ind = "  ".replicate(indent);
        string result = "";
        
        if (_version == SOAPVersion.SOAP11) {
            // SOAP 1.1 format
            result ~= ind ~ "<soap:Fault>\n";
            result ~= ind ~ "  <faultcode>" ~ getFaultCodeString() ~ "</faultcode>\n";
            result ~= ind ~ "  <faultstring>" ~ escapeXML(_faultString) ~ "</faultstring>\n";
            
            if (_faultActor.length > 0) {
                result ~= ind ~ "  <faultactor>" ~ escapeXML(_faultActor) ~ "</faultactor>\n";
            }
            
            if (_detail.length > 0) {
                result ~= ind ~ "  <detail>" ~ escapeXML(_detail) ~ "</detail>\n";
            }
            
            result ~= ind ~ "</soap:Fault>\n";
        } else {
            // SOAP 1.2 format
            result ~= ind ~ "<env:Fault>\n";
            result ~= ind ~ "  <env:Code>\n";
            result ~= ind ~ "    <env:Value>" ~ getFaultCodeString() ~ "</env:Value>\n";
            result ~= ind ~ "  </env:Code>\n";
            result ~= ind ~ "  <env:Reason>\n";
            result ~= ind ~ "    <env:Text xml:lang=\"en\">" ~ escapeXML(_faultString) ~ "</env:Text>\n";
            result ~= ind ~ "  </env:Reason>\n";
            
            if (_faultActor.length > 0) {
                result ~= ind ~ "  <env:Node>" ~ escapeXML(_faultActor) ~ "</env:Node>\n";
            }
            
            if (_detail.length > 0) {
                result ~= ind ~ "  <env:Detail>" ~ escapeXML(_detail) ~ "</env:Detail>\n";
            }
            
            result ~= ind ~ "</env:Fault>\n";
        }
        
        return result;
    }
}
