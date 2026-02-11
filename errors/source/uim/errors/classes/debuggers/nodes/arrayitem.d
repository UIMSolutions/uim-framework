/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.errors.classes.debuggers.nodes.arrayitem;

import uim.errors;
mixin(ShowModule!());
@safe:


// Dump node for Array Items.
class ArrayItemErrorNode : ErrorNode {
  mixin(ErrorNodeThis!("ArrayItem"));

  private IErrorNode _key;
  private IErrorNode _value;

  /**
    * aKey - The node for the item key
    * aValue - The node for the array value
    */
  this(IErrorNode aKey, IErrorNode aValue) {
    super();
    _key = aKey;
    // _value = aValue;
  }

  // Get value
/*   @property IErrorNode value() {
    return _value;
  } */

  // Get the key
  @property IErrorNode key() {
    return _key;
  }

/*   IErrorNode[] children() {
    return [value];
  } */
}
