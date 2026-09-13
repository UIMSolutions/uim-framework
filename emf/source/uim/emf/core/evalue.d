/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.emf.core.evalue;

import uim.emf;

@safe:

interface IValue {
    EClassifier eType();
    bool isNull();
    Json toJson();
}

class EValue : IValue {
    protected EClassifier _eType;
    protected bool _isNull;
    protected Json _toJson;

    EClassifier eType() {
        return _eType;
    }

    bool isNull() {
        return _isNull;
    }

    Json toJson() {
        return _toJson;
    }
}