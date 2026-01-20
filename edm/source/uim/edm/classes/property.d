/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.edm.classes.property;

import uim.edm;

@safe:

/**
 * Base property implementation
 */
abstract class EdmProperty : EdmNamedElement, IEdmProperty {
    mixin(ObjThis!("EdmProperty"));
    
    protected EdmPropertyKind _propertyKind;
    protected IEdmType _propertyType;
    protected bool _nullable = true;
    protected IEdmStructuredType _declaringType;
    
    this(IEdmStructuredType declaring, string propertyName, IEdmType type, EdmPropertyKind kind) {
        super(declaring ? declaring.schema() : null, propertyName);
        _declaringType = declaring;
        _propertyType = type;
        _propertyKind = kind;
    }
    
    override EdmPropertyKind propertyKind() {
        return _propertyKind;
    }
    
    override IEdmType propertyType() {
        return _propertyType;
    }
    
    override bool nullable() {
        return _nullable;
    }
    
    EdmProperty nullable(bool value) {
        _nullable = value;
        return this;
    }
    
    override IEdmStructuredType declaringType() {
        return _declaringType;
    }
}

/**
 * Structural property (data member)
 */
class EdmStructuralProperty : EdmProperty, IEdmStructuralProperty {
    mixin(ObjThis!("EdmStructuralProperty"));
    
    protected string _defaultValue;
    protected int _maxLength = -1;
    protected int _precision = -1;
    protected int _scale = -1;
    protected bool _unicode = true;
    
    this(IEdmStructuredType declaring, string propertyName, IEdmType type) {
        super(declaring, propertyName, type, EdmPropertyKind.Structural);
    }
    
    override string defaultValue() {
        return _defaultValue;
    }
    
    EdmStructuralProperty defaultValue(string value) {
        _defaultValue = value;
        return this;
    }
    
    override int maxLength() {
        return _maxLength;
    }
    
    EdmStructuralProperty maxLength(int value) {
        _maxLength = value;
        return this;
    }
    
    override int precision() {
        return _precision;
    }
    
    EdmStructuralProperty precision(int value) {
        _precision = value;
        return this;
    }
    
    override int scale() {
        return _scale;
    }
    
    EdmStructuralProperty scale(int value) {
        _scale = value;
        return this;
    }
    
    override bool unicode() {
        return _unicode;
    }
    
    EdmStructuralProperty unicode(bool value) {
        _unicode = value;
        return this;
    }
}

/**
 * Navigation property (relationship)
 */
class EdmNavigationProperty : EdmProperty, IEdmNavigationProperty {
    mixin(ObjThis!("EdmNavigationProperty"));
    
    protected IEdmNavigationProperty _partner;
    protected bool _isCollection;
    protected bool _containsTarget;
    
    this(IEdmStructuredType declaring, string propertyName, IEdmType targetType, bool collection = false) {
        super(declaring, propertyName, targetType, EdmPropertyKind.Navigation);
        _isCollection = collection;
    }
    
    override IEdmNavigationProperty partner() {
        return _partner;
    }
    
    EdmNavigationProperty partner(IEdmNavigationProperty value) {
        _partner = value;
        return this;
    }
    
    override bool isCollection() {
        return _isCollection;
    }
    
    override IEdmType targetType() {
        return _propertyType;
    }
    
    override bool containsTarget() {
        return _containsTarget;
    }
    
    EdmNavigationProperty containsTarget(bool value) {
        _containsTarget = value;
        return this;
    }
}
