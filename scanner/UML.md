# UIM-SCANNER UML Description

## Overview

UIM-SCANNER provides a compact D source scanning architecture for metadata extraction from files and source strings.

## Core Types

```plantuml
@startuml Scanner_Core

enum DSymbolKind {
  unknown
  class_
  struct_
  interface_
  enum_
  union_
  template_
  function_
  alias_
  mixinTemplate
}

struct DImportEntry {
  + moduleName: string
  + isStatic: bool
  + isPublic: bool
}

struct DSymbolEntry {
  + kind: DSymbolKind
  + name: string
  + signature: string
  + line: size_t
}

struct DScanOptions {
  + includeFunctions: bool
  + includePrivate: bool
}

struct DScanResult {
  + filePath: string
  + moduleName: string
  + imports: DImportEntry[]
  + symbols: DSymbolEntry[]
  + lineCount: size_t
  + byteCount: size_t
  + hasUnitTests: bool
}

struct DDirectoryScanResult {
  + rootPath: string
  + files: DScanResult[]
  + fileCount: size_t
  + symbolCount: size_t
}

interface IDCodeScannerService {
  + scanSource(source: string, filePath: string, options: DScanOptions): DScanResult
  + scanFile(filePath: string, options: DScanOptions): DScanResult
  + scanDirectory(rootPath: string, recursive: bool, options: DScanOptions): DDirectoryScanResult
  + scanSourceAsync(source: string, handler, filePath: string, options: DScanOptions): bool
}

class UIMDCodeScannerService
UIMDCodeScannerService ..|> IDCodeScannerService

@enduml
```

## Helper Layer

```plantuml
@startuml Scanner_Helpers

class ScannerCodecHelpers {
  + scannerStripLineComment(line: string): string
  + scannerParseImportLine(line: string): DImportEntry
  + scannerParseDeclaration(line: string, lineNumber: size_t): DSymbolEntry
  + scannerLooksLikeFunction(line: string): bool
  + scannerExtractFunctionName(line: string): string
}

UIMDCodeScannerService --> ScannerCodecHelpers : declaration and import parsing

@enduml
```

## Sequence

```plantuml
@startuml Scanner_Sequence

actor Application
participant Service as "UIMDCodeScannerService"
participant Parser as "ScannerCodecHelpers"
participant Task as "vibe.d runTask"
participant Handler as "DScanResultHandler"

Application -> Service: scanSource(source, filePath, options)
Service -> Parser: parse imports and declarations line-by-line
Parser --> Service: DScanResult
Service --> Application: DScanResult

Application -> Service: scanSourceAsync(source, handler, filePath, options)
Service -> Task: runTask(callback)
Task -> Handler: callback(result)

@enduml
```
