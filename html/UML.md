/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/

# UIM-HTML UML Description

## Overview
The UIM-HTML library provides a fluent, type-safe API for composing HTML documents and elements in D. The architecture is centered on a small set of interfaces and base classes (`IHtmlElement`, `HtmlElement`, `HtmlDocument`) that are specialized through mixins and concrete HTML5 element classes.

## Architecture Layers

### 1. Interface Layer (uim.html.interfaces)
Defines the contracts for attributes, generic elements, form elements, and input behavior.

```plantuml
@startuml HTML_Interfaces

interface IHtmlAttribute {
  + name(): string
  + name(value: string): IHtmlAttribute
  + value(): string
  + value(val: string): IHtmlAttribute
  + toString(): string
}

interface IHtmlElement {
  + tagName(): string
  + tagName(value: string): IHtmlElement
  + content(): string
  + content(values: string[]): IHtmlElement
  + content(elements: IHtmlElement[]): IHtmlElement
  + addContent(values: string[]): IHtmlElement
  + addContent(elements: IHtmlElement[]): IHtmlElement
  + selfClosing(): bool
  + selfClosing(value: bool): IHtmlElement
  + attribute(name: string, value: string): IHtmlElement
  + attribute(name: string): IHtmlAttribute
  + id(value: string): IHtmlElement
  + id(): string
  + addClass(className: string): IHtmlElement
  + style(styleValue: string): IHtmlElement
  + text(textContent: string): IHtmlElement
  + toString(): string
}

interface IHtmlForm {
  + name(): IHtmlAttribute
  + name(nameValue: string): IHtmlForm
  + action(url: string): IHtmlForm
  + method(methodValue: string): IHtmlForm
  + post(): IHtmlForm
  + get(): IHtmlForm
  + enctype(value: string): IHtmlForm
}

interface IFormElement {
  + form(): IHtmlAttribute
  + form(formId: string): IFormElement
}

interface IInput {
  + type(): IHtmlAttribute
  + type(typeValue: string): IInput
}

IHtmlForm --|> IHtmlElement
IFormElement --|> IHtmlElement
IInput --|> IFormElement

@enduml
```

### 2. Core Implementation Layer (uim.html.classes)
Provides the foundational classes used by all concrete HTML element implementations.

```plantuml
@startuml HTML_Core_Classes

class HtmlAttribute {
  - _name: string
  - _value: string

  + name(): string
  + name(value: string): IHtmlAttribute
  + value(): string
  + value(val: string): IHtmlAttribute
  + toString(): string
  + create(name: string, value: string): IHtmlAttribute
}

class HtmlElement {
  - _tagName: string
  - _content: string
  - _selfClosing: bool
  - _attributes: IHtmlAttribute[string]
  - _children: IHtmlElement[]

  + tagName(): string
  + tagName(value: string): IHtmlElement
  + content(): string
  + content(values: string[]): IHtmlElement
  + content(elements: IHtmlElement[]): IHtmlElement
  + addContent(values: string[]): IHtmlElement
  + addContent(elements: IHtmlElement[]): IHtmlElement
  + attribute(name: string, value: string): IHtmlElement
  + attribute(name: string): IHtmlAttribute
  + removeAttribute(name: string): IHtmlElement
  + id(value: string): IHtmlElement
  + id(): string
  + addClass(className: string): IHtmlElement
  + style(styleValue: string): IHtmlElement
  + toString(): string
}

class HtmlDocument {
  - _title: string
  - _lang: string
  - _charset: string
  - _head: IHtmlElement
  - _body: IHtmlElement
  - _metaTags: string[]
  - _stylesheets: string[]
  - _scripts: string[]

  + title(): string
  + title(value: string): HtmlDocument
  + lang(): string
  + lang(value: string): HtmlDocument
  + charset(): string
  + charset(value: string): HtmlDocument
  + addMeta(name: string, content: string): HtmlDocument
  + addStylesheet(href: string): HtmlDocument
  + addScript(src: string): HtmlDocument
  + addInlineStyle(css: string): HtmlDocument
  + addInlineScript(js: string): HtmlDocument
  + head(): IHtmlElement
  + body(): IHtmlElement
  + toString(): string
}

HtmlAttribute ..|> IHtmlAttribute
HtmlElement ..|> IHtmlElement
HtmlDocument *-- IHtmlElement : head
HtmlDocument *-- IHtmlElement : body
HtmlElement o-- IHtmlAttribute : attributes
HtmlElement o-- IHtmlElement : children

@enduml
```

### 3. Element Specialization Layer (uim.html.classes.elements.*)
Concrete HTML tags are modeled as specialized classes inheriting `HtmlElement`.

```plantuml
@startuml HTML_Element_Specialization

class HtmlElement

class H5Div {
  + this(...)
}

class H5Img {
  + src(source: string): H5Img
  + src(): IHtmlAttribute
  + alt(text: string): H5Img
  + alt(): IHtmlAttribute
  + width(size: string): H5Img
  + width(): IHtmlAttribute
  + height(size: string): H5Img
  + height(): IHtmlAttribute
}

class H5Form {
  + name(): H5Form
  + name(nameValue: string): H5Form
  + action(url: string): H5Form
  + method(methodValue: string): H5Form
  + post(): H5Form
  + get(): H5Form
  + enctype(value: string): H5Form
}

class H5Input {
  + type(typeValue: string): H5Input
  + type(): string
  + name(nameValue: string): H5Input
  + value(valueValue: string): H5Input
  + placeholder(text: string): H5Input
  + required(isRequired: bool): H5Input
  + disabled(isDisabled: bool): H5Input
  + readonly(isReadonly: bool): H5Input
  + checked(isChecked: bool): H5Input
}

class "<<mixin>> H5This" as H5This
class "<<mixin>> H5Calls" as H5Calls
class "<<mixin>> HtmlTemplate" as HtmlTemplate
class "<<mixin>> HtmlMethods" as HtmlMethods
class "<<mixin>> H5InputThis" as H5InputThis

H5Div --|> HtmlElement
H5Img --|> HtmlElement
H5Form --|> HtmlElement
H5Input --|> HtmlElement

H5Div ..> HtmlTemplate : uses
H5Img ..> HtmlTemplate : uses
H5Form ..> HtmlTemplate : uses
H5Input ..> HtmlTemplate : uses
HtmlTemplate ..> H5This : composes
HtmlTemplate ..> H5Calls : composes
HtmlTemplate ..> HtmlMethods : composes
H5Input ..> H5InputThis : optional typed setup

note right of HtmlTemplate
Preferred element mixin entry point.
Combines constructor overloads,
static opCall factories,
and fluent attribute helpers.
end note

note right of H5Calls
Generates static opCall factory
methods for concise API usage.
end note

@enduml
```

### 4. UDA Metadata Layer (uim.html.udas)
The library exposes UDAs for compile-time metadata and reflection.

```plantuml
@startuml HTML_UDA_Layer

struct HtmlTag {
  + name: string
  + this(tagName: string)
}

struct VoidElement

struct HtmlCategory {
  + name: string
  + this(categoryName: string)
}

struct SupportsAttribute {
  + name: string
  + this(attributeName: string)
}

struct DeprecatedHtml {
  + reason: string
  + this(deprecationReason: string)
}

class "<<template>> hasHtmlTagAttribute" as hasHtmlTagAttribute
class "<<template>> getHtmlTagAttribute" as getHtmlTagAttribute
class "<<template>> hasVoidElementAttribute" as hasVoidElementAttribute
class "<<template>> hasHtmlCategoryAttribute" as hasHtmlCategoryAttribute
class "<<template>> getHtmlCategoryAttribute" as getHtmlCategoryAttribute
class "<<template>> hasSupportsAttributeAttribute" as hasSupportsAttributeAttribute
class "<<template>> getSupportsAttribute" as getSupportsAttribute
class "<<template>> getSupportsAttributes" as getSupportsAttributes
class "<<template>> hasDeprecatedHtmlAttribute" as hasDeprecatedHtmlAttribute
class "<<template>> getDeprecatedHtmlAttribute" as getDeprecatedHtmlAttribute

hasHtmlTagAttribute ..> HtmlTag
getHtmlTagAttribute ..> HtmlTag
hasVoidElementAttribute ..> VoidElement
hasHtmlCategoryAttribute ..> HtmlCategory
getHtmlCategoryAttribute ..> HtmlCategory
hasSupportsAttributeAttribute ..> SupportsAttribute
getSupportsAttribute ..> SupportsAttribute
getSupportsAttributes ..> SupportsAttribute
hasDeprecatedHtmlAttribute ..> DeprecatedHtml
getDeprecatedHtmlAttribute ..> DeprecatedHtml

@enduml
```

### 5. Document Rendering Sequence
Shows how a complete page is assembled and rendered to a final HTML string.

```plantuml
@startuml HTML_Rendering_Sequence

actor Client
participant "HtmlDocument" as Doc
participant "Head(IHtmlElement)" as Head
participant "Body(IHtmlElement)" as Body
participant "H5Div" as Div
participant "H5Img" as Img

Client -> Doc: HtmlDocument()
Client -> Doc: title("Landing")
Client -> Doc: addStylesheet("app.css")
Client -> Body: addContent(H5Div("Welcome"))
Client -> Img: src("logo.png").alt("Logo")
Client -> Body: addContent(Img)
Client -> Doc: toString()

activate Doc
Doc -> Head: content()
Doc -> Body: content()
Doc --> Client: "<!DOCTYPE html>..."
deactivate Doc

@enduml
```

## Notes
- Most concrete elements are generated with `HtmlTemplate!(ElementType, Name, Tag, selfClosing)`, which composes `H5This`, `H5Calls`, and `HtmlMethods`.
- `HtmlDocument` owns page-level concerns (head/body/meta/resources), while `HtmlElement` focuses on tag-level composition and rendering.
- UDA support in `uim.html.udas` enables compile-time classification and metadata-driven tooling for elements.
