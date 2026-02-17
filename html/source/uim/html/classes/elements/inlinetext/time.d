/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.time;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The <time> HTML element represents a specific period in time. 
  * It can be used to encode dates, times, or both, and it provides a machine-readable format for representing temporal data. 
  * The <time> element can be used to mark up dates and times in a way that allows browsers and other user agents to understand and process the information, such as for displaying it in a localized format or for enabling features like calendar integration.
  *
  * The <time> element can include a datetime attribute that specifies the date and time in a standardized format (ISO 8601). 
  * This allows for better interoperability and enables user agents to parse and manipulate the temporal data effectively
  * The content of the <time> element can be human-readable text that describes the date or time, while the datetime attribute provides a machine-readable representation of the same information.  
  * For example, <time datetime="2023-09-15T14:30">September 15, 2023 at 2:30 PM</time> represents a specific date and time, where the datetime attribute provides the machine-readable format, and the content provides a human-readable description.
  * The <time> element is useful for marking up dates and times in a way that allows for better accessibility, search engine optimization, and integration with various applications that can utilize temporal data.
  * 
  * Examples
  * <time datetime="2023-09-15">September 15, 2023</time>
  * <time datetime="2023-09-15T14:30">September 15, 2023 at 2:30 PM</time>
  * <time datetime="2023-09-15T14:30Z">September 15, 2023 at 2:30 PM UTC</time>
  * <time datetime="2023-09-15T14:30+02:00">September 15, 2023 at 2:30 PM CEST</time>
  * 
  */
class H5Time : HtmlElement {
  mixin H5This!("time", false);

  mixin(H5Calls!("time"));
}
///
unittest {
  assert(H5Time() == "<time></time>");
  assert(H5Time("Hello") == "<time>Hello</time>");
}
