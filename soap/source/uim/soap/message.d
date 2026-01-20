/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.soap.message;

import uim.soap;

@safe:

/**
 * Complete SOAP message with envelope
 */
class DSOAPMessage : UIMObject {
    protected DSOAPEnvelope _envelope;
    
    @property DSOAPEnvelope envelope() { return _envelope; }
    @property void envelope(DSOAPEnvelope value) { _envelope = value; }
    
    this() {
        super();
        this._envelope = new DSOAPEnvelope();
    }
    
    this(SOAPVersion ver) {
        super();
        this._envelope = new DSOAPEnvelope(ver);
    }
    
    /**
     * Get SOAP version
     */
    @property SOAPVersion version_() {
        return _envelope.version_;
    }
    
    /**
     * Set SOAP version
     */
    @property void version_(SOAPVersion value) {
        _envelope.version_ = value;
    }
    
    /**
     * Get header
     */
    @property DSOAPHeader header() {
        return _envelope.header;
    }
    
    /**
     * Get body
     */
    @property DSOAPBody body_() {
        return _envelope.body_;
    }
    
    /**
     * Add header element
     */
    void addHeaderElement(string name, string content) {
        _envelope.header.addElement(name, content);
    }
    
    /**
     * Add header element with namespace
     */
    void addHeaderElement(DSOAPHeaderElement element) {
        _envelope.header.addElement(element);
    }
    
    /**
     * Set body content
     */
    void setBody(string content) {
        _envelope.body_.content = content;
    }
    
    /**
     * Set fault
     */
    void setFault(SOAPFaultCode code, string message) {
        _envelope.body_.setFault(code, message, _envelope.version_);
    }
    
    /**
     * Set fault
     */
    void setFault(DSOAPFault fault) {
        _envelope.body_.fault = fault;
    }
    
    /**
     * Check if message has fault
     */
    bool hasFault() {
        return _envelope.body_.hasFault();
    }
    
    /**
     * Get content type for HTTP header
     */
    string getContentType() {
        return uim.soap.version_.getContentType(_envelope.version_);
    }
    
    /**
     * Convert to XML string
     */
    string toXML() {
        return _envelope.toXML();
    }
    
    /**
     * Create a request message
     */
    static DSOAPMessage createRequest(string methodName, string methodNamespace, 
                                       string[string] parameters, 
                                       SOAPVersion ver = SOAPVersion.SOAP11) @trusted {
        auto message = new DSOAPMessage(ver);
        
        // Build method call XML
        string body = "<" ~ methodName ~ " xmlns=\"" ~ methodNamespace ~ "\">\n";
        
        foreach (key, value; parameters) {
            body ~= "  <" ~ key ~ ">" ~ value ~ "</" ~ key ~ ">\n";
        }
        
        body ~= "</" ~ methodName ~ ">";
        
        message.setBody(body);
        
        return message;
    }
    
    /**
     * Create a response message
     */
    static DSOAPMessage createResponse(string methodName, string methodNamespace,
                                        string result,
                                        SOAPVersion ver = SOAPVersion.SOAP11) {
        auto message = new DSOAPMessage(ver);
        
        string body = "<" ~ methodName ~ "Response xmlns=\"" ~ methodNamespace ~ "\">\n";
        body ~= "  <" ~ methodName ~ "Result>" ~ result ~ "</" ~ methodName ~ "Result>\n";
        body ~= "</" ~ methodName ~ "Response>";
        
        message.setBody(body);
        
        return message;
    }
    
    /**
     * Create a fault message
     */
    static DSOAPMessage createFault(SOAPFaultCode code, string message,
                                     SOAPVersion ver = SOAPVersion.SOAP11) {
        auto msg = new DSOAPMessage(ver);
        msg.setFault(code, message);
        return msg;
    }
}
