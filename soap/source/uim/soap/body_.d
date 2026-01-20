/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.soap.body_;

import uim.soap;
import std.algorithm;
import std.array;

@safe:

/**
 * SOAP Body
 */
class DSOAPBody : UIMObject {
    protected string _content;
    protected DSOAPFault _fault;
    
    @property string content() { return _content; }
    @property void content(string value) { _content = value; }
    
    @property DSOAPFault fault() { return _fault; }
    @property void fault(DSOAPFault value) { _fault = value; }
    
    this() {
        super();
    }
    
    this(string bodyContent) {
        this();
        this._content = bodyContent;
    }
    
    /**
     * Check if body contains a fault
     */
    bool hasFault() {
        return _fault !is null;
    }
    
    /**
     * Set fault (clears content)
     */
    void setFault(DSOAPFault soapFault) {
        _fault = soapFault;
        _content = "";
    }
    
    /**
     * Set fault with code and message
     */
    void setFault(SOAPFaultCode code, string message, SOAPVersion ver = SOAPVersion.SOAP11) {
        _fault = new DSOAPFault(code, message, ver);
        _content = "";
    }
    
    /**
     * Convert to XML
     */
    string toXML(int indent, SOAPVersion ver) {
        string ind = "  ".replicate(indent);
        string prefix = ver == SOAPVersion.SOAP11 ? "soap" : "env";
        string result = ind ~ "<" ~ prefix ~ ":Body>\n";
        
        if (hasFault()) {
            result ~= _fault.toXML(indent + 1);
        } else if (_content.length > 0) {
            // Add content lines with proper indentation
            auto lines = _content.split("\n");
            foreach (line; lines) {
                if (line.strip().length > 0) {
                    result ~= ind ~ "  " ~ line ~ "\n";
                }
            }
        }
        
        result ~= ind ~ "</" ~ prefix ~ ":Body>\n";
        
        return result;
    }
}
