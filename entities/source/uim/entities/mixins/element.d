/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.mixins.element;

import uim.entities;

mixin(ShowModule!());

@safe:

template ElementThis(string name) {
  const char[] ElementThis = `
		this() { super(); }
		this(string myName) { this().name(myName); }
		this(Json aJson) { this().fromJson(aJson); }
		override UIMElement create() { return `~name~`; }
  `;
}

template ElementCalls(string name) {
  const char[] ElementCalls = `
		auto `~name~`() { return new D`~name~`; } 
		auto `~name~`(string myName) { return new D`~name~`(myName); } 
		auto `~name~`(Json json) { return new D`~name~`(json); } 
  `;
} 