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