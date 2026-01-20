# UIM SOAP Library

A comprehensive D library for working with SOAP (Simple Object Access Protocol), supporting both SOAP 1.1 and SOAP 1.2 specifications.

## Features

- **SOAP 1.1 and 1.2 Support**: Full implementation of both SOAP versions
- **Complete Message Structure**: Envelope, Header, Body, and Fault components
- **Header Management**: Custom headers with mustUnderstand and actor/role attributes
- **Fault Handling**: Comprehensive error reporting with SOAP Faults
- **Type-Safe**: Leverages D's strong type system
- **XML Generation**: Clean, well-formatted SOAP XML output
- **Standards Compliant**: Follows W3C SOAP specifications

## Installation

Add to your `dub.sdl`:

```sdl
dependency "uim-framework:soap" version="~>1.0.0"
```

Or in `dub.json`:

```json
{
  "dependencies": {
    "uim-framework:soap": "~>1.0.0"
  }
}
```

## Quick Start

```d
import uim.soap;
import std.stdio;

void main() {
    // Create SOAP message
    auto message = new DSOAPMessage(SOAPVersion.SOAP11);
    
    // Set body content
    message.setBody("<GetWeather><City>New York</City></GetWeather>");
    
    // Generate XML
    writeln(message.toXML());
}
```

## Core Components

### SOAP Message

The main class for creating SOAP messages:

```d
auto message = new DSOAPMessage(SOAPVersion.SOAP11);
```

### SOAP Envelope

The root element containing header and body:

```d
auto envelope = new DSOAPEnvelope(SOAPVersion.SOAP12);
```

### SOAP Header

Optional metadata and routing information:

```d
// Add simple header
message.addHeaderElement("TransactionID", "12345");

// Add header with attributes
auto authHeader = new DSOAPHeaderElement("Authentication", "http://example.org/auth", "<Token>ABC123</Token>");
authHeader.mustUnderstand = true;
message.addHeaderElement(authHeader);
```

### SOAP Body

The main content of the message:

```d
message.setBody("<MethodName><Param>Value</Param></MethodName>");
```

### SOAP Fault

Error reporting:

```d
auto fault = new DSOAPFault(SOAPFaultCode.Client, "Invalid parameter");
fault.detail = "The 'City' parameter is required";
message.setFault(fault);
```

## SOAP Versions

### SOAP 1.1

```d
auto message = new DSOAPMessage(SOAPVersion.SOAP11);
// Content-Type: text/xml; charset=utf-8
// Namespace: http://schemas.xmlsoap.org/soap/envelope/
```

### SOAP 1.2

```d
auto message = new DSOAPMessage(SOAPVersion.SOAP12);
// Content-Type: application/soap+xml; charset=utf-8
// Namespace: http://www.w3.org/2003/05/soap-envelope
```

## Examples

### Basic SOAP Request

```d
auto message = new DSOAPMessage(SOAPVersion.SOAP11);
message.setBody(`
<GetStockPrice xmlns="http://example.org/stock">
  <Symbol>MSFT</Symbol>
</GetStockPrice>
`);

string xml = message.toXML();
```

Output:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetStockPrice xmlns="http://example.org/stock">
      <Symbol>MSFT</Symbol>
    </GetStockPrice>
  </soap:Body>
</soap:Envelope>
```

### Request with Parameters

```d
string[string] params;
params["CityName"] = "London";
params["CountryCode"] = "GB";

auto message = DSOAPMessage.createRequest(
    "GetCityWeather",
    "http://example.org/weather",
    params,
    SOAPVersion.SOAP11
);
```

### Response Message

```d
auto message = DSOAPMessage.createResponse(
    "GetCityWeather",
    "http://example.org/weather",
    "<Temperature>18</Temperature><Condition>Cloudy</Condition>",
    SOAPVersion.SOAP11
);
```

### Message with Authentication Header

```d
auto message = new DSOAPMessage(SOAPVersion.SOAP11);

auto authHeader = new DSOAPHeaderElement("Authentication", "http://example.org/auth", "");
authHeader.mustUnderstand = true;
authHeader.content = "<Username>john</Username><Password>secret</Password>";

message.addHeaderElement(authHeader);
message.setBody("<GetUserData><UserID>12345</UserID></GetUserData>");
```

### SOAP Fault (Error Response)

```d
// SOAP 1.1 Fault
auto fault = new DSOAPFault(
    SOAPFaultCode.Client,
    "Invalid input parameter",
    SOAPVersion.SOAP11
);
fault.faultActor = "http://example.org/service";
fault.detail = "The 'Symbol' parameter must be a valid stock ticker";

auto message = new DSOAPMessage(SOAPVersion.SOAP11);
message.setFault(fault);
```

Output:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <soap:Fault>
      <faultcode>soap:Client</faultcode>
      <faultstring>Invalid input parameter</faultstring>
      <faultactor>http://example.org/service</faultactor>
      <detail>The 'Symbol' parameter must be a valid stock ticker</detail>
    </soap:Fault>
  </soap:Body>
</soap:Envelope>
```

### Complete Web Service Call

```d
auto message = new DSOAPMessage(SOAPVersion.SOAP12);

// Session header
auto sessionHeader = new DSOAPHeaderElement(
    "SessionID", 
    "http://example.org/session", 
    "ABC-123-XYZ"
);
sessionHeader.mustUnderstand = true;
message.addHeaderElement(sessionHeader);

// Request tracking
message.addHeaderElement("RequestID", "REQ-2026-001");

// Body with order details
string body = `<SubmitOrder xmlns="http://example.org/orders">
  <OrderID>ORD-12345</OrderID>
  <Customer>
    <Name>Alice Johnson</Name>
    <Email>alice@example.com</Email>
  </Customer>
  <Items>
    <Item>
      <ProductCode>PROD-001</ProductCode>
      <Quantity>2</Quantity>
    </Item>
  </Items>
</SubmitOrder>`;

message.setBody(body);

// Get content type for HTTP header
string contentType = message.getContentType();
```

## Fault Codes

SOAP supports standard fault codes:

```d
enum SOAPFaultCode {
    VersionMismatch,  // Invalid SOAP version
    MustUnderstand,   // Required header not understood
    Client,           // Client-side error
    Server            // Server-side error
}
```

### Creating Faults

```d
// Quick fault creation
auto faultMessage = DSOAPMessage.createFault(
    SOAPFaultCode.Server,
    "Service temporarily unavailable",
    SOAPVersion.SOAP12
);

// Detailed fault
auto fault = new DSOAPFault(SOAPFaultCode.Client, "Invalid request");
fault.faultActor = "http://example.org/service";
fault.detail = "Missing required field: CustomerID";
message.setFault(fault);
```

## Header Attributes

### mustUnderstand

Indicates that the receiver must understand the header:

```d
auto header = new DSOAPHeaderElement("Security", "http://example.org/security", "<Token>...</Token>");
header.mustUnderstand = true;  // Receiver must process this header
```

### actor/role

Specifies the intended recipient:

```d
auto header = new DSOAPHeaderElement("Routing", "", "<NextHop>http://proxy.example.org</NextHop>");
header.actor = "http://schemas.xmlsoap.org/soap/actor/next";  // SOAP 1.1
// or
header.actor = "http://www.w3.org/2003/05/soap-envelope/role/next";  // SOAP 1.2
```

## API Reference

### DSOAPMessage

**Constructors:**
- `this()` - Create SOAP 1.1 message
- `this(SOAPVersion ver)` - Create message with specific version

**Properties:**
- `SOAPVersion version_` - Get/set SOAP version
- `DSOAPHeader header` - Access header
- `DSOAPBody body_` - Access body

**Methods:**
- `void addHeaderElement(string name, string content)` - Add simple header
- `void addHeaderElement(DSOAPHeaderElement element)` - Add detailed header
- `void setBody(string content)` - Set body content
- `void setFault(SOAPFaultCode code, string message)` - Set fault
- `bool hasFault()` - Check for fault
- `string getContentType()` - Get HTTP Content-Type
- `string toXML()` - Generate XML

**Static Methods:**
- `DSOAPMessage createRequest(...)` - Create request message
- `DSOAPMessage createResponse(...)` - Create response message
- `DSOAPMessage createFault(...)` - Create fault message

### DSOAPHeader

**Methods:**
- `void addElement(DSOAPHeaderElement element)` - Add header element
- `void addElement(string name, string content)` - Add simple element
- `bool isEmpty()` - Check if empty

### DSOAPHeaderElement

**Properties:**
- `string name` - Element name
- `string namespace` - Element namespace
- `string content` - Element content
- `bool mustUnderstand` - Must understand flag
- `string actor` - Actor/role URI

### DSOAPBody

**Properties:**
- `string content` - Body content
- `DSOAPFault fault` - Fault object

**Methods:**
- `bool hasFault()` - Check for fault
- `void setFault(DSOAPFault fault)` - Set fault

### DSOAPFault

**Properties:**
- `SOAPFaultCode faultCode` - Fault code
- `string faultString` - Error message
- `string faultActor` - Actor that caused fault
- `string detail` - Detailed error info

### DSOAPEnvelope

**Properties:**
- `DSOAPHeader header` - Envelope header
- `DSOAPBody body_` - Envelope body
- `SOAPVersion version_` - SOAP version

**Methods:**
- `string toXML()` - Generate XML

## Use Cases

- **Web Services**: Create SOAP-based web services
- **Enterprise Integration**: Integrate with legacy SOAP services
- **B2B Communication**: Business-to-business data exchange
- **Financial Services**: Banking and payment systems
- **Telecommunications**: Telecom service interfaces
- **Government Services**: Public sector web services
- **Healthcare**: HL7 and healthcare integrations

## Standards

This library implements:
- [SOAP 1.1 Specification](https://www.w3.org/TR/2000/NOTE-SOAP-20000508/)
- [SOAP 1.2 Specification](https://www.w3.org/TR/soap12/)
- W3C XML Standards

## HTTP Integration

When sending SOAP messages over HTTP:

```d
auto message = new DSOAPMessage(SOAPVersion.SOAP11);
message.setBody("...");

// Set HTTP headers
string contentType = message.getContentType();
// Content-Type: text/xml; charset=utf-8 (SOAP 1.1)
// or application/soap+xml; charset=utf-8 (SOAP 1.2)

string soapAction = "http://example.org/GetData";
// SOAPAction header (SOAP 1.1 only)

string xml = message.toXML();
// POST to endpoint with xml as body
```

## Error Handling

```d
try {
    auto message = new DSOAPMessage(SOAPVersion.SOAP11);
    message.setBody("...");
    
    // Send to service...
    
    if (message.hasFault()) {
        auto fault = message.body_.fault;
        writeln("Fault: ", fault.faultString);
        writeln("Detail: ", fault.detail);
    }
} catch (Exception e) {
    auto faultMsg = DSOAPMessage.createFault(
        SOAPFaultCode.Server,
        "Internal error: " ~ e.msg,
        SOAPVersion.SOAP11
    );
}
```

## Best Practices

1. **Always specify SOAP version** - Be explicit about SOAP 1.1 vs 1.2
2. **Use mustUnderstand wisely** - Only for critical headers
3. **Include proper namespaces** - Use namespace URIs for methods
4. **Handle faults gracefully** - Always check for faults in responses
5. **Set SOAPAction header** - Required for SOAP 1.1 (optional for 1.2)
6. **Validate XML content** - Ensure well-formed XML in body
7. **Use appropriate fault codes** - Client vs Server faults

## License

Apache License 2.0

## Author

Ozan Nurettin Süel (UIManufaktur)

## Contributing

Contributions are welcome! Please submit issues and pull requests on GitHub.
