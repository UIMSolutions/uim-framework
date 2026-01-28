/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/

module uim.entities.interfaces.attribute;

import uim.entities;
@safe:

interface IAttribute {
	// Data formats of the attribute. 
  string[] dataFormats(); 

	// Check for data format
  bool hasDataFormat(string dataFormatName);

  
}
