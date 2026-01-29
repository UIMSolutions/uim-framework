/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.values;

import uim.entities;

@safe:

public {
  import uim.entities.classes.values.value;
  import uim.entities.classes.values.map;
}

// Packages
public {
  import uim.entities.classes.values.arrays;
  import uim.entities.classes.values.datetimes;
  import uim.entities.classes.values.elements;
  import uim.entities.classes.values.lookups;
  import uim.entities.classes.values.maps;
  import uim.entities.classes.values.scalars;
  import uim.entities.classes.values.uuids;
}

// Modules
public {
  import uim.entities.classes.values.entity;
  import uim.entities.classes.values.null_;
  import uim.entities.classes.values.object_;
}

template ValueThis(string name) { // Name for future releases
  const char[] ValueThis = q{  
    this() { super(); }
    this(IAttribute theAttribute) { this().attribute(theAttribute); }
    };
}

template ValueCalls(string name, string datatype = null) {
  const char[] ValueCalls = `  
    auto `
    ~ name ~ `() { return new D` ~ name ~ `; }
    auto `
    ~ name ~ `(UIMAttribute theAttribute) { return new D` ~ name ~ `(theAttribute); }
    auto `
    ~ name ~ `(string theValue) { return new D` ~ name ~ `(theValue); }
    auto `
    ~ name ~ `(Json theValue) { return new D` ~ name ~ `(theValue); }
    auto `
    ~ name ~ `(UIMAttribute theAttribute, string theValue) { return new D` ~ name ~ `(theAttribute, theValue); }
    auto `
    ~ name ~ `(UIMAttribute theAttribute, Json theValue) { return new D` ~ name ~ `(theAttribute, theValue); }
  `
    ~
    (datatype ?
        ` auto ` ~ name ~ `(` ~ datatype ~ ` theValue) { return new D` ~ name ~ `(theValue); }
    auto `
        ~ name ~ `(UIMAttribute theAttribute, ` ~ datatype ~ ` theValue) { return new D` ~ name ~ `(theAttribute, theValue); }` : "");
}

/* template ValueProperty(string name) {
  const char[] EntityCalls = `
    auto `~name~`() { return this.values[`~name~`]; } 
    O `~name~`(this O)(string newValue) { this.values[`~name~`].value(newValue); return cast(O)this; } 
    O `~name~`(this O)(Json newValue) { this.values[`~name~`].value(newValue); return cast(O)this;  } 
  `;
} */
