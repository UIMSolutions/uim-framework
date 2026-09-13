/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.emf.core.eclassifier;

import uim.emf;

@safe:
interface EClassifier {
    string name();
}

class EClassifierBase : EClassifier {
    protected string _name;

    string name() {
        return _name;
    }
}