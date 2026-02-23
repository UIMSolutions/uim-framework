/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.maths.annotationxml;

import uim.html;

mixin(ShowModule!());

@safe:

class H5AnnotationXml : HtmlElement {
  mixin(H5This!("annotation-xml", false));

  mixin(AttributeMethods!H5AnnotationXml);

  mixin(H5Calls!("AnnotationXml"));
}
///
unittest {
  assert(H5AnnotationXml() == "<annotation-xml></annotation-xml>");
  assert(H5AnnotationXml("Hello") == "<annotation-xml>Hello</annotation-xml>");
}
