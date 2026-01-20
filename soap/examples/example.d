module soap.examples.example;

import std.stdio;
import uim.soap;

void main() {
    writeln("=== SOAP Library Examples ===\n");
    
    example1_BasicSOAP11Message();
    example2_BasicSOAP12Message();
    example3_MessageWithHeader();
    example4_SOAPFault11();
    example5_SOAPFault12();
    example6_WebServiceRequest();
    example7_WebServiceResponse();
    example8_AuthenticationHeader();
    example9_CompleteSOAPMessage();
    example10_ErrorHandling();
}

void example1_BasicSOAP11Message() {
    writeln("Example 1: Basic SOAP 1.1 Message");
    writeln("----------------------------------");
    
    auto message = new DSOAPMessage(SOAPVersion.SOAP11);
    message.setBody("<GetWeather><City>New York</City></GetWeather>");
    
    writeln("SOAP 1.1 Message:");
    writeln(message.toXML());
}

void example2_BasicSOAP12Message() {
    writeln("Example 2: Basic SOAP 1.2 Message");
    writeln("----------------------------------");
    
    auto message = new DSOAPMessage(SOAPVersion.SOAP12);
    message.setBody("<GetTemperature><Location>London</Location></GetTemperature>");
    
    writeln("SOAP 1.2 Message:");
    writeln(message.toXML());
}

void example3_MessageWithHeader() {
    writeln("Example 3: Message with Header");
    writeln("-------------------------------");
    
    auto message = new DSOAPMessage(SOAPVersion.SOAP11);
    
    // Add header elements
    message.addHeaderElement("TransactionID", "12345");
    message.addHeaderElement("Timestamp", "2026-01-20T10:30:00Z");
    
    message.setBody("<CalculatePrice><Product>Widget</Product></CalculatePrice>");
    
    writeln("Message with headers:");
    writeln(message.toXML());
}

void example4_SOAPFault11() {
    writeln("Example 4: SOAP 1.1 Fault");
    writeln("-------------------------");
    
    auto fault = new DSOAPFault(SOAPFaultCode.Client, "Invalid input parameters", SOAPVersion.SOAP11);
    fault.faultActor = "http://example.org/service";
    fault.detail = "The 'City' parameter is required but was not provided";
    
    auto message = new DSOAPMessage(SOAPVersion.SOAP11);
    message.setFault(fault);
    
    writeln("SOAP 1.1 Fault:");
    writeln(message.toXML());
}

void example5_SOAPFault12() {
    writeln("Example 5: SOAP 1.2 Fault");
    writeln("-------------------------");
    
    auto fault = new DSOAPFault(SOAPFaultCode.Server, "Internal server error", SOAPVersion.SOAP12);
    fault.faultActor = "http://example.org/service";
    fault.detail = "Database connection failed";
    
    auto message = new DSOAPMessage(SOAPVersion.SOAP12);
    message.setFault(fault);
    
    writeln("SOAP 1.2 Fault:");
    writeln(message.toXML());
}

void example6_WebServiceRequest() {
    writeln("Example 6: Web Service Request");
    writeln("-------------------------------");
    
    // Create request parameters
    string[string] params;
    params["CityName"] = "Paris";
    params["CountryCode"] = "FR";
    
    auto message = DSOAPMessage.createRequest(
        "GetCityWeather",
        "http://example.org/weather",
        params,
        SOAPVersion.SOAP11
    );
    
    writeln("Weather service request:");
    writeln(message.toXML());
}

void example7_WebServiceResponse() {
    writeln("Example 7: Web Service Response");
    writeln("--------------------------------");
    
    auto message = DSOAPMessage.createResponse(
        "GetCityWeather",
        "http://example.org/weather",
        "<Temperature>22</Temperature><Condition>Sunny</Condition>",
        SOAPVersion.SOAP11
    );
    
    writeln("Weather service response:");
    writeln(message.toXML());
}

void example8_AuthenticationHeader() {
    writeln("Example 8: Authentication Header");
    writeln("---------------------------------");
    
    auto message = new DSOAPMessage(SOAPVersion.SOAP11);
    
    // Create authentication header with mustUnderstand
    auto authHeader = new DSOAPHeaderElement("Authentication", "http://example.org/auth", "");
    authHeader.mustUnderstand = true;
    authHeader.content = "<Username>john.doe</Username><Password>secret123</Password>";
    
    message.addHeaderElement(authHeader);
    message.setBody("<GetUserProfile><UserID>12345</UserID></GetUserProfile>");
    
    writeln("Message with authentication header:");
    writeln(message.toXML());
}

void example9_CompleteSOAPMessage() {
    writeln("Example 9: Complete SOAP Message");
    writeln("---------------------------------");
    
    auto message = new DSOAPMessage(SOAPVersion.SOAP12);
    
    // Multiple headers
    auto sessionHeader = new DSOAPHeaderElement("SessionID", "http://example.org/session", "ABC-123-XYZ");
    sessionHeader.mustUnderstand = true;
    message.addHeaderElement(sessionHeader);
    
    message.addHeaderElement("RequestID", "REQ-2026-001");
    message.addHeaderElement("ClientVersion", "2.1.0");
    
    // Body with complex operation
    string body = `<SubmitOrder xmlns="http://example.org/orders">
  <OrderID>ORD-2026-12345</OrderID>
  <Customer>
    <Name>Alice Johnson</Name>
    <Email>alice@example.com</Email>
  </Customer>
  <Items>
    <Item>
      <ProductCode>PROD-001</ProductCode>
      <Quantity>2</Quantity>
      <Price>49.99</Price>
    </Item>
    <Item>
      <ProductCode>PROD-002</ProductCode>
      <Quantity>1</Quantity>
      <Price>99.99</Price>
    </Item>
  </Items>
  <TotalAmount>199.97</TotalAmount>
</SubmitOrder>`;
    
    message.setBody(body);
    
    writeln("Complete SOAP message:");
    writeln(message.toXML());
    writeln("Content-Type: ", message.getContentType());
}

void example10_ErrorHandling() {
    writeln("Example 10: Error Handling");
    writeln("--------------------------");
    
    // Create different types of faults
    auto versionFault = DSOAPMessage.createFault(
        SOAPFaultCode.VersionMismatch,
        "SOAP version mismatch",
        SOAPVersion.SOAP11
    );
    
    auto mustUnderstandFault = DSOAPMessage.createFault(
        SOAPFaultCode.MustUnderstand,
        "Required header not understood",
        SOAPVersion.SOAP12
    );
    
    auto clientFault = DSOAPMessage.createFault(
        SOAPFaultCode.Client,
        "Invalid request format",
        SOAPVersion.SOAP11
    );
    
    auto serverFault = DSOAPMessage.createFault(
        SOAPFaultCode.Server,
        "Service temporarily unavailable",
        SOAPVersion.SOAP12
    );
    
    writeln("Version Mismatch Fault:");
    writeln(versionFault.toXML());
    
    writeln("\nMust Understand Fault:");
    writeln(mustUnderstandFault.toXML());
    
    writeln("\nClient Fault:");
    writeln(clientFault.toXML());
    
    writeln("\nServer Fault:");
    writeln(serverFault.toXML());
}
