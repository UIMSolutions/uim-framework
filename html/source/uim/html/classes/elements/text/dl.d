/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.lists.dl;

import uim.html;

mixin(ShowModule!());

@safe:

/** 
 * The <dl> HTML element represents a description list. 
 * A description list is a list of terms and their descriptions, and it is typically used to create a glossary or a list of questions and answers. 
 * The <dl> element contains one or more pairs of <dt> (definition term) and <dd> (definition description) elements, where each <dt> element represents a term and each <dd> element provides the corresponding description for that term. 
 * The <dl> element can also contain other flow content, such as headings, paragraphs, and images, to provide additional context or information about the terms and their descriptions.
 */
class Dl : HtmlElement {
  this() {
    super("dl");
  }

  static Dl opCall() {
    return new Dl();
  }
}

auto dl() {
  return new Dl();
}
///
unittest {
  assert(Dl() == "<dl></dl>");
}
