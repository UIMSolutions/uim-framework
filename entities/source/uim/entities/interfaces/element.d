/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.entities.interfaces.element;

import uim.entities;
@safe:

interface IElement {
	// Read data from STRINGAA
  void readFromStringAA(STRINGAA reqParameters, bool usePrefix = false);

  // Read data from request
  void readFromRequest(STRINGAA requestValues, bool usePrefix = true);
}