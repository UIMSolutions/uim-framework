module uim.emf.core.epackage;

import uim.emf;

@safe:

interface EPackage {
    string name();
    string nsURI();

    EClass getEClass(string name);
    EFactory factory();
}

class EPackageBase : EPackage {
    protected string _name;
    protected string _nsURI;
    protected EClass[] _eClasses;
    protected EFactory _factory;

    string name() {
        return _name;
    }

    string nsURI() {
        return _nsURI;
    }

    EClass getEClass(string name) {
        foreach (eClass; _eClasses) {
            if (eClass.name == name)
                return eClass;
        }
        return null;
    }

    EFactory factory() {
        return _factory;
    }
}