/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes;

import uim.entities;

mixin(ShowModule!());

@safe:

public { 
	import uim.entities.classes.attributes.attribute;
	import uim.entities.classes.attributes.helpers;
}

public { 
	import uim.entities.classes.attributes.lookups;
	import uim.entities.classes.attributes.codes;
}

public { 
	import uim.entities.classes.attributes.arrays;
	import uim.entities.classes.attributes.booleans;
	import uim.entities.classes.attributes.bytes;
	import uim.entities.classes.attributes.chars;
	import uim.entities.classes.attributes.dates;
	import uim.entities.classes.attributes.datetimes;
	import uim.entities.classes.attributes.decimals;
	import uim.entities.classes.attributes.doubles;
	import uim.entities.classes.attributes.elements;
	import uim.entities.classes.attributes.entities;
	import uim.entities.classes.attributes.integers;
	import uim.entities.classes.attributes.ulongs;
	import uim.entities.classes.attributes.uuids;
}

template AttributeThis(string name) {
  const char[] AttributeThis = q{
    this() { initialize(); this.name(name);  }
    this(Json newData) { this().fromJson(newData); }
    this(UUID myId) { this().id(myId); }
    this(string myName) { this().name(myName); }
    this(UUID myId, string myName) { this(myId).name(myName); }  
  };
}

template AttributeCalls(string name) {
  const char[] AttributeCalls = `
auto `~name~`() { return new D`~name~`();  }
auto `~name~`(Json newData) { return new D`~name~`(newData); }
auto `~name~`(UUID myId) { return new D`~name~`(myId); }
auto `~name~`(string myName) { return new D`~name~`(myName); }
auto `~name~`(UUID myId, string myName) { return new D`~name~`(myId, myName); }  
`;
}

void testAttribute(UIMAttribute attribute) {
  assert(attribute);
}

static this() {
  AttributeRegistry.instance
    // Booleans
    .register("boolean", new BooleanAttribute)
    // Bytes
    .register("binary", new BinaryAttribute)
    .register("byte", new ByteAttribute)
    // Chars
    .register("char", new CharAttribute)
    // Chars -> Strings
    .register("addressLine", new AddressLineAttribute)
    .register("attributeName", new AttributeNameAttribute)
    .register("cityName", new CityNameAttribute)
    .register("colorName", new ColorNameAttribute)
    .register("companyName", new CompanyNameAttribute)
    .register("country", new CountryAttribute)
    .register("county", new CountyAttribute)
    .register("languageTag", new LanguageTagAttribute)
    .register("lastName", new LastNameAttribute)
    .register("link", new LinkAttribute)
    .register("list", new ListAttribute)
    .register("string", new StringAttribute)
    .register("url", new UrlAttribute)
    // Dates
    .register("date", new DateAttribute)
    // DateTimes
    .register("birthDate", new BirthDateAttribute)
    .register("datetime", new DatetimeAttribute)
    .register("time", new TimeAttribute);
    // Decimals
}

version(test_uim_models) { unittest {
    writeln(attributeRegistry()["boolean"].name);
    writeln(attributeRegistry()["byte"].name);
    writeln(attributeRegistry()["binary"].name);

    writeln(attributeRegistry().paths);
  }
}
