/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/

# UIM-BIM UML Description

## Overview

`uim-bim` implements a domain model aligned with the **IFC 4.3** schema. The architecture follows a layered design: interfaces define contracts, model/component classes provide implementations, and helper structs (`BimFactory`, `BimQuery`) provide entry points for library consumers.

---

## 1. Interfaces

```plantuml
@startuml BIM_Interfaces

interface IBimElement {
  + globalId(): string
  + name(): string
  + description(): string
  + objectType(): string
  + tag(): string
  + ifcClass(): string
  + classifications(): string[]
  + addClassification(code: string): IBimElement
  + removeClassification(code: string): IBimElement
  + properties(): Json[string]
  + setProperty(key: string, value: Json): IBimElement
  + getProperty(key: string, defaultValue: Json): Json
  + hasProperty(key: string): bool
  + parentId(): string
  + childIds(): string[]
  + addChildId(id: string): IBimElement
  + removeChildId(id: string): IBimElement
  + toJson(): Json
  + fromJson(data: Json): IBimElement
}

interface IBimSite {
  + latitude(): double
  + longitude(): double
  + elevation(): double
  + landTitleNumber(): string
  + siteAddress(): string
  + buildingIds(): string[]
  + addBuildingId(id: string): IBimSite
}

interface IBimBuilding {
  + buildingAddress(): string
  + yearOfConstruction(): string
  + isLandmarked(): bool
  + grossFloorArea(): double
  + netFloorArea(): double
  + height(): double
  + numberOfStoreys(): int
  + storeyIds(): string[]
  + addStoreyId(id: string): IBimBuilding
}

interface IBimStorey {
  + elevation(): double
  + floorHeight(): double
  + netHeight(): double
  + storeyNumber(): int
  + grossArea(): double
  + netArea(): double
  + spaceIds(): string[]
  + componentIds(): string[]
}

interface IBimSpace {
  + spaceNumber(): string
  + predefinedType(): string
  + longName(): string
  + grossFloorArea(): double
  + netFloorArea(): double
  + netHeight(): double
  + grossVolume(): double
  + netVolume(): double
  + componentIds(): string[]
}

interface IBimComponent {
  + posX(): double
  + posY(): double
  + posZ(): double
  + rotationZ(): double
  + materialId(): string
  + layerMaterialIds(): string[]
  + isLoadBearing(): bool
  + isExternal(): bool
}

IBimElement <|-- IBimSite
IBimElement <|-- IBimBuilding
IBimElement <|-- IBimStorey
IBimElement <|-- IBimSpace
IBimElement <|-- IBimComponent

@enduml
```

---

## 2. Spatial Hierarchy

```plantuml
@startuml BIM_Spatial_Hierarchy

class UIMBimElement {
  # _globalId: string
  # _name: string
  # _description: string
  # _objectType: string
  # _tag: string
  # _parentId: string
  # _childIds: string[]
  # _classifications: string[]
  # _properties: Json[string]
  + toJson(): Json
  + fromJson(data: Json): IBimElement
}

class UIMBimSite {
  - _latitude: double
  - _longitude: double
  - _elevation: double
  - _landTitleNumber: string
  - _siteAddress: string
  - _buildingIds: string[]
}

class UIMBimBuilding {
  - _buildingAddress: string
  - _yearOfConstruction: string
  - _isLandmarked: bool
  - _grossFloorArea: double
  - _netFloorArea: double
  - _height: double
  - _numberOfStoreys: int
  - _storeyIds: string[]
}

class UIMBimStorey {
  - _elevation: double
  - _floorHeight: double
  - _netHeight: double
  - _storeyNumber: int
  - _grossArea: double
  - _netArea: double
  - _spaceIds: string[]
  - _componentIds: string[]
}

class UIMBimSpace {
  - _spaceNumber: string
  - _predefinedType: string
  - _longName: string
  - _grossFloorArea: double
  - _netFloorArea: double
  - _netHeight: double
  - _grossVolume: double
  - _netVolume: double
  - _componentIds: string[]
}

UIMBimElement <|-- UIMBimSite
UIMBimElement <|-- UIMBimBuilding
UIMBimElement <|-- UIMBimStorey
UIMBimElement <|-- UIMBimSpace

UIMBimSite       "1" o-- "0..*" UIMBimBuilding : buildingIds
UIMBimBuilding   "1" o-- "0..*" UIMBimStorey   : storeyIds
UIMBimStorey     "1" o-- "0..*" UIMBimSpace    : spaceIds

@enduml
```

---

## 3. Building Components

```plantuml
@startuml BIM_Components

class UIMBimComponent {
  - _posX: double
  - _posY: double
  - _posZ: double
  - _rotationZ: double
  - _materialId: string
  - _layerMaterialIds: string[]
  - _isLoadBearing: bool
  - _isExternal: bool
}

class UIMBimWall {
  - _length: double
  - _height: double
  - _thickness: double
  - _predefinedType: string
}

class UIMBimSlab {
  - _thickness: double
  - _predefinedType: string
}

class UIMBimColumn {
  - _height: double
  - _width: double
  - _depth: double
  - _radius: double
  - _predefinedType: string
}

class UIMBimBeam {
  - _span: double
  - _width: double
  - _depth: double
  - _predefinedType: string
}

class UIMBimDoor {
  - _overallHeight: double
  - _overallWidth: double
  - _predefinedType: string
  - _operationType: string
  - _isFireRated: bool
  - _fireRating: string
  - _isAccessible: bool
}

class UIMBimWindow {
  - _overallHeight: double
  - _overallWidth: double
  - _sillHeight: double
  - _predefinedType: string
  - _partitioningType: string
  - _uValue: double
  - _solarHeatGainCoefficient: double
}

class UIMBimOpening {
  - _width: double
  - _height: double
  - _depth: double
  - _predefinedType: string
  - _hostElementId: string
}

class UIMBimStair {
  - _numberOfRisers: int
  - _numberOfTreads: int
  - _riserHeight: double
  - _treadDepth: double
  - _width: double
  - _predefinedType: string
}

class UIMBimRoof {
  - _pitchAngle: double
  - _overhang: double
  - _predefinedType: string
}

UIMBimElement   <|-- UIMBimComponent
UIMBimComponent <|-- UIMBimWall
UIMBimComponent <|-- UIMBimSlab
UIMBimComponent <|-- UIMBimColumn
UIMBimComponent <|-- UIMBimBeam
UIMBimComponent <|-- UIMBimDoor
UIMBimComponent <|-- UIMBimWindow
UIMBimComponent <|-- UIMBimOpening
UIMBimComponent <|-- UIMBimStair
UIMBimComponent <|-- UIMBimRoof

@enduml
```

---

## 4. Properties, Materials, and Classifications

```plantuml
@startuml BIM_Properties

interface IBimProperty {
  + name(): string
  + description(): string
  + value(): Json
  + unit(): string
  + toJson(): Json
}

interface IBimPropertySet {
  + name(): string
  + description(): string
  + properties(): IBimProperty[string]
  + addProperty(prop: IBimProperty): IBimPropertySet
  + getProperty(name: string): IBimProperty
  + hasProperty(name: string): bool
  + toJson(): Json
}

interface IBimMaterial {
  + globalId(): string
  + name(): string
  + category(): string
  + density(): double
  + thermalConductivity(): double
  + specificHeat(): double
  + colour(): string
  + toJson(): Json
}

interface IBimClassification {
  + system(): string
  + edition(): string
  + code(): string
  + label(): string
  + location(): string
  + toJson(): Json
}

class UIMBimProperty {}
class UIMBimPropertySet {}
class UIMBimMaterial {}
class UIMBimClassification {}

IBimProperty       <|.. UIMBimProperty
IBimPropertySet    <|.. UIMBimPropertySet
IBimMaterial       <|.. UIMBimMaterial
IBimClassification <|.. UIMBimClassification

UIMBimPropertySet "1" o-- "0..*" UIMBimProperty : properties

@enduml
```

---

## 5. Geometry Primitives

```plantuml
@startuml BIM_Geometry

struct BimPoint3D {
  + x: double
  + y: double
  + z: double
  + distanceTo(other: BimPoint3D): double
  + toJson(): Json
  + {static} fromJson(data: Json): BimPoint3D
}

struct BimPlacement {
  + origin: BimPoint3D
  + axisZ: BimPoint3D
  + axisX: BimPoint3D
  + rotationDeg: double
  + toJson(): Json
  + {static} fromJson(data: Json): BimPlacement
}

struct BimBoundingBox {
  + min: BimPoint3D
  + max: BimPoint3D
  + width(): double
  + depth(): double
  + height(): double
  + volume(): double
  + contains(p: BimPoint3D): bool
  + intersects(other: BimBoundingBox): bool
  + toJson(): Json
  + {static} fromJson(data: Json): BimBoundingBox
}

BimPlacement    *-- "2" BimPoint3D
BimBoundingBox  *-- "2" BimPoint3D

@enduml
```

---

## 6. Helper Layer

```plantuml
@startuml BIM_Helpers

struct BimFactory {
  + {static} site(name: string): UIMBimSite
  + {static} building(name: string): UIMBimBuilding
  + {static} storey(name: string, n: int): UIMBimStorey
  + {static} space(name: string): UIMBimSpace
  + {static} wall(name: string): UIMBimWall
  + {static} slab(name: string, type: string): UIMBimSlab
  + {static} column(name: string): UIMBimColumn
  + {static} beam(name: string): UIMBimBeam
  + {static} door(name: string): UIMBimDoor
  + {static} window(name: string): UIMBimWindow
  + {static} opening(name: string): UIMBimOpening
  + {static} stair(name: string): UIMBimStair
  + {static} roof(name: string): UIMBimRoof
  + {static} material(name: string): UIMBimMaterial
  + {static} propertySet(name: string): UIMBimPropertySet
  + {static} property(name: string, value: Json, unit: string): UIMBimProperty
  + {static} classification(system: string, code: string, label: string): UIMBimClassification
}

struct BimQuery {
  + {static} byIfcClass(elements: IBimElement[], ifcClass: string): IBimElement[]
  + {static} byName(elements: IBimElement[], fragment: string): IBimElement[]
  + {static} byClassification(elements: IBimElement[], code: string): IBimElement[]
  + {static} byGlobalId(elements: IBimElement[], id: string): IBimElement
  + {static} withProperty(elements: IBimElement[], key: string): IBimElement[]
}

@enduml
```

---

## 7. Sequence: Building a Model

```plantuml
@startuml BIM_Sequence_Build

actor Developer
participant BimFactory
participant UIMBimSite
participant UIMBimBuilding
participant UIMBimStorey
participant UIMBimSpace
participant UIMBimWall

Developer -> BimFactory : site("Campus A")
BimFactory --> Developer : site: UIMBimSite

Developer -> BimFactory : building("Tower 1")
BimFactory --> Developer : building: UIMBimBuilding

Developer -> site : addBuildingId(building.globalId())

Developer -> BimFactory : storey("GF", 0)
BimFactory --> Developer : storey: UIMBimStorey

Developer -> building : addStoreyId(storey.globalId())

Developer -> BimFactory : space("Lobby")
BimFactory --> Developer : space: UIMBimSpace

Developer -> storey : addSpaceId(space.globalId())

Developer -> BimFactory : wall("South Wall")
BimFactory --> Developer : wall: UIMBimWall

Developer -> wall : length(10.0).height(3.5).thickness(0.25)

Developer -> storey : addComponentId(wall.globalId())

Developer -> wall : toJson()
wall --> Developer : Json object

@enduml
```
