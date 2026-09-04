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