/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.html.classes.elements.inlinetext.var;

import uim.html;

mixin(ShowModule!());

@safe:

/**
  * The <var> HTML element represents a variable in a mathematical expression or a programming context. 
  * It is typically used to indicate that the text it contains is a variable name, a placeholder for a value, or a term that can be substituted with different values in different contexts. 
  * The <var> element does not carry any specific semantic meaning on its own, but it is often used in conjunction with other elements to provide additional context and meaning to the content it contains.
  *
  * The <var> element is commonly used in mathematical expressions to represent variables, such as in equations or formulas. 
  * It can also be used in programming contexts to indicate variable names or placeholders for values that can be substituted with different values in different contexts. 
  * For example, in a programming tutorial, the <var> element can be used to represent variable names in code snippets, making it clear that the text is a variable and not a literal value.
  * The <var> element is useful for marking up variables in a way that allows for better accessibility, search engine optimization, and integration with various applications that can utilize the information about variables in mathematical or programming contexts.
  * Examples
  * <var>x</var> + <var>y</var> = <var>z</var>
  * <var>radius</var> = 5
  * <var>temperature</var> = 25°C
  * <var>username</var> = "JohnDoe"
  * <var>count</var> = 10
  */
class H5Var : HtmlElement {
  mixin(HtmlTemplate!(H5Var, "Var", "var", false));
}
///
unittest {
  assert(H5Var() == "<var></var>");
  assert(H5Var("Hello") == "<var>Hello</var>");
  assert(H5Var(["test"], "Hello") == `<var class="test">Hello</var>`);
  assert(H5Var(["a":"b"], "Hello") == `<var a="b">Hello</var>`);
  assert(H5Var(["test"], ["a":"b"], "Hello") == `<var class="test" a="b">Hello</var>`);
}
