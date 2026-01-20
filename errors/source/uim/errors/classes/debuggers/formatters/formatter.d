/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.errors.classes.debuggers.formatters.formatter;

import uim.errors;
import std.array : replicate;
mixin(ShowModule!());

@safe:

class UIMErrorFormatter : UIMObject, IErrorFormatter {
  mixin(ErrorFormatterThis!());

  string _startBreak;
  string startBreak() {
    return _startBreak;
  }

  string startBreak(size_t indentLevel) {
    return _startBreak = "\n" ~ replicate(" ", indentLevel);
  }

  string _endBreak;
  string endBreak() {
    return _endBreak;
  }

  string endBreak(size_t indentLevel) {
    return _endBreak = "\n" ~ replicate(" ", indentLevel - 1);
  }

  // Convert a tree of IErrorNode objects into a plain text string.
  override string dump(IErrorNode node) {
    return export_(node, 0);
  }

  // Convert a tree of IErrorNode objects into HTML
  protected string export_(IErrorNode node, size_t indentLevel) {
    if (node is null) {
      return null; 
    }

    indentLevel += 1;
    startBreak(indentLevel);
    endBreak(indentLevel);

    if (auto errorNode = cast(DArrayErrorNode) node) {
      return exportArray(errorNode, indentLevel);
    }
    if (auto errorNode = cast(DClassErrorNode) node) {
      return exportClass(errorNode, indentLevel);
    }
    if (auto errorNode = cast(DReferenceErrorNode) node) {
      return exportReference(errorNode, indentLevel);
    }
    if (auto errorNode = cast(DPropertyErrorNode) node) {
      return exportProperty(errorNode, indentLevel);
    }
    if (auto errorNode = cast(DScalarErrorNode) node) {
      return exportScalar(errorNode, indentLevel);
    }
    if (auto errorNode = cast(DSpecialErrorNode) node) {
      return exportSpecial(errorNode, indentLevel);
    }
    throw InvalidArgumentException("Unknown node received " ~ node.classinfo.baseName);
  }

  protected string exportArray(DArrayErrorNode node, size_t indentLevel) {
    return null;
  }

  protected string exportArrayItem(IErrorNode node, size_t indentLevel) {
    return export_(node, indentLevel);
  }

  protected string exportReference(DReferenceErrorNode node, size_t indentLevel) {
    return null;
  }

  protected string exportClass(DClassErrorNode node, size_t indentLevel) {
    return null;
  }

  protected string exportProperty(DPropertyErrorNode node, size_t indentLevel) {
    return null;
  }

  protected string exportScalar(DScalarErrorNode node, size_t indentLevel) {
    return null;
  }

  protected string exportSpecial(DSpecialErrorNode node, size_t indentLevel) {
    return null;
  }
  // #endregion export
}
