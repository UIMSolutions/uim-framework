module uim.emf.models.dynamic;

import uim.emf;

@safe:

class DynamicEObject : EObject {
    protected EClass _class;

    protected Json[string] _values;

    this(EClass type) {
        if (type is null)
            throw new Exception("EClass must not be null");

        _class = type;
    }

    override EClass eClass() {
        return _class;
    }

    bool hasFeature(string featureName) {
        return _class.hasFeature(featureName);
    }

    override Json get(string featureName) {
        auto feature = _class.getFeature(featureName);

        if (feature is null) {
            throw new Exception(
                "Unknown feature '" ~ featureName ~
                    "' on class '" ~ _class.name ~ "'");
        }

        if (feature.many) {
            if (featureName !in _values) {
                _values[featureName] = Json.emptyArray;
            }
        }

        return (featureName in _values) ? _values[featureName] : Json(null);
    }

    // override
    // void set(string featureName, Object value) {
    //     setValue(featureName, value);
    // }

    EObject set(string featureName, Json value) {
        return setValue(featureName, value);
        return this;
    }

    EObject setValue(string featureName, Json value) {
        auto feature = _class.getFeature(featureName);

        if (feature is null) {
            throw new Exception(
                "Unknown feature '" ~ featureName ~
                    "' on class '" ~ _class.name ~ "'");
        }

        if (feature.many) {
            if (featureName !in _values) {
                _values[featureName] = Json.emptyArray;
            }
            _values[featureName] ~= value;
            return this;
        }

        // validate(feature, value);

        _values[featureName] = toJson(value);
        return this;

    }

    EObject add(string featureName, Json value) {
        auto feature = _class.getFeature(featureName);

        if (feature is null) {
            throw new Exception(
                "Unknown feature '" ~ featureName ~
                    "' on class '" ~ _class.name ~ "'");
        }

        if (feature.many) {
            if (featureName !in _values) {
                _values[featureName] = Json.emptyArray;
            }
            _values[featureName] ~= value;
            return this;
        }

        // validate(feature, value);

        // Json[] values;

        // if (featureName in _values) {
        //     auto existing = _values[featureName];

        //     if (!existing.isArray) {
        //         throw new Exception(
        //             "Feature '" ~ featureName ~
        //                 "' is expected to store a JSON array");
        //     }

        //     values = existing.get!(Json[]);
        // }

        // values ~= toJson(value);

        // _values[featureName] = Json(values);
        return this;
    }

    EObject add(string featureName, string key, Json value) {
        auto feature = _class.getFeature(featureName);

        if (feature is null) {
            throw new Exception(
                "Unknown feature '" ~ featureName ~
                    "' on class '" ~ _class.name ~ "'");
        }

        if (feature.many) {
            if (featureName !in _values) {
                _values[featureName] = Json.emptyObject;
            }
            _values[featureName][key] = value;
        }

        // if (!feature.many) {
        //     throw new Exception(
        //         "Feature '" ~ featureName ~
        //             "' is not multi-valued");
        // }

        // validate(feature, value);

        // Json[] values;

        // if (featureName in _values) {
        //     auto existing = _values[featureName];

        //     if (!existing.isArray) {
        //         throw new Exception(
        //             "Feature '" ~ featureName ~
        //                 "' is expected to store a JSON array");
        //     }

        //     values = existing.get!(Json[]);
        // }

        // values ~= toJson(value);

        // _values[featureName] = Json(values);
        return this;
    }

    bool isSet(string featureName) {
        return (featureName in _values) ? true : false;
    }

    EObject unset(string featureName) {
        _values.remove(featureName);
        return this;
    }

    protected void validate(EStructuralFeature feature, Json value) {
        if (value.isNull)
            return;

        // if (auto reference = cast(EReference)feature) {
        //     auto object = cast(EObject)value;

        //     if (object is null) {
        //         throw new Exception(
        //             "Reference '" ~ feature.name ~
        //                 "' requires an EObject");
        //     }
        // }
    }

    // protected void validate(T)(
    //     EStructuralFeature feature,
    //     auto ref T value)
    //         if (!is(T : Object)) {
    //     if (auto reference = cast(EReference)feature) {
    //         throw new Exception(
    //             "Reference '" ~ feature.name ~
    //                 "' requires an EObject");
    //     }
    // }

    // protected Json toJson(Object value) {
    //     if (value is null)
    //         return Json(null);

    //     if (auto EObject = cast(EObject)value) {
    //         auto referenceValue = Json.emptyObject;
    //         referenceValue["eClass"] = Json(EObject.eClass.name);
    //         return referenceValue;
    //     }

    //     return Json(value.classinfo.name);
    // }

    protected Json toJson(Json value) {
        Json result = Json.emptyObject;
        _values.byKeyValue.each!((kv) {
            result[kv.key] = kv.value;
        });
        return result;
    }
}

unittest {
    // auto person = new EClass("Person")
    //     .addAttribute(new EAttribute("name", typeid(string)));

    // auto dynamicObject = new DynamicEObject(person);
    // assert(dynamicObject.isSet("name") == false);
    // dynamicObject.set("name", Json("John Doe"));
    // assert(dynamicObject.isSet("name") == true);
    // assert(dynamicObject.get("name") == Json("John Doe"));
    // dynamicObject.unset("name");
    // assert(dynamicObject.isSet("name") == false);
}
