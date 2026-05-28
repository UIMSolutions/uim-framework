/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/

# UIM-SQL UML Description

## Overview
The UIM-SQL library is a three-tier SQL toolkit: a dialect-aware query builder produces parameterised SQL, a driver interface abstracts the underlying connection, and an in-process loopback driver enables testing without a live database.

## Core Contracts

```plantuml
@startuml SQL_Interfaces

enum SqlValueType {
  text
  integer_
  float_
  boolean_
  null_
}

enum SqlColumnType {
  text
  integer_
  float_
  boolean_
  blob
  null_
}

enum SqlDialect {
  generic
  mysql
  postgresql
  sqlite
  mssql
}

class SqlValue {
  + type: SqlValueType
  + textValue: string
  + intValue: long
  + floatValue: double
  + boolValue: bool
  + isNull(): bool
  + toString(): string
}

class SqlParameter {
  + name: string
  + index: int
  + value: SqlValue
}

class SqlQuery {
  + sql: string
  + params: SqlParameter[]
}

class SqlColumnInfo {
  + name: string
  + type: SqlColumnType
}

interface ISqlRow {
  + text(column: string): string
  + integer_(column: string): long
  + float_(column: string): double
  + boolean_(column: string): bool
  + isNull(column: string): bool
  + columnNames(): string[]
}

interface ISqlResult {
  + empty(): bool
  + front(): ISqlRow
  + popFront(): void
  + rowCount(): size_t
  + columns(): SqlColumnInfo[]
  + close(): void
}

interface ISqlDriver {
  + open(connectionString: string): bool
  + close(): bool
  + query(sql: string, params: SqlParameter[]): ISqlResult
  + execute(sql: string, params: SqlParameter[]): int
  + beginTransaction(): void
  + commit(): void
  + rollback(): void
  + name(): string
}

interface ISqlConnection {
  + open(connectionString: string): bool
  + close(): bool
  + isOpen(): bool
  + query(sql: string, params: SqlParameter[]): ISqlResult
  + execute(sql: string, params: SqlParameter[]): int
  + queryAsync(sql: string, params: SqlParameter[], callback: delegate): void
  + beginTransaction(): bool
  + commit(): bool
  + rollback(): bool
  + inTransaction(): bool
  + connectionString(): string
  + driverName(): string
}

ISqlRow --o ISqlResult : rows
ISqlDriver --o ISqlConnection : delegates to
SqlValue --* SqlParameter
SqlParameter --o SqlQuery
SqlColumnInfo --o ISqlResult

@enduml
```

## Query Builder Layer

```plantuml
@startuml SQL_Builders

class SqlSelectBuilder {
  - _table: string
  - _columns: string[]
  - _joins: string[]
  - _whereClauses: string[]
  - _whereParams: SqlParameter[]
  - _orderByClauses: string[]
  - _limit: uint
  - _offset: uint
  + select_(columns: string[]): SqlSelectBuilder
  + join_(clause: string): SqlSelectBuilder
  + where_(condition: string): SqlSelectBuilder
  + where_(condition: string, value: SqlValue): SqlSelectBuilder
  + orderBy(column: string, asc: bool): SqlSelectBuilder
  + limit_(n: uint): SqlSelectBuilder
  + offset_(n: uint): SqlSelectBuilder
  + build(): SqlQuery
}

class SqlInsertBuilder {
  - _table: string
  - _columns: string[]
  - _values: SqlParameter[]
  + set_(column: string, value: SqlValue): SqlInsertBuilder
  + build(): SqlQuery
}

class SqlUpdateBuilder {
  - _table: string
  - _setClauses: string[]
  - _setParams: SqlParameter[]
  - _whereClauses: string[]
  - _whereParams: SqlParameter[]
  + set_(column: string, value: SqlValue): SqlUpdateBuilder
  + where_(condition: string): SqlUpdateBuilder
  + where_(condition: string, value: SqlValue): SqlUpdateBuilder
  + build(): SqlQuery
}

class SqlDeleteBuilder {
  - _table: string
  - _whereClauses: string[]
  - _whereParams: SqlParameter[]
  + where_(condition: string): SqlDeleteBuilder
  + where_(condition: string, value: SqlValue): SqlDeleteBuilder
  + build(): SqlQuery
}

SqlSelectBuilder ..> SqlQuery : produces
SqlInsertBuilder ..> SqlQuery : produces
SqlUpdateBuilder ..> SqlQuery : produces
SqlDeleteBuilder ..> SqlQuery : produces

@enduml
```

## Implementation Layer

```plantuml
@startuml SQL_Implementations

class UIMSqlRow {
  - _data: string[string]
}

class UIMSqlResult {
  - _rows: ISqlRow[]
  - _pos: size_t
  - _columns: SqlColumnInfo[]
}

class UIMSqlConnection {
  - _open: bool
  - _inTransaction: bool
  - _connectionString: string
  - _driver: ISqlDriver
}

class UIMSqlLoopbackDriver {
  - _queryHandlers: QueryHandler[string]
  - _execHandlers: ExecHandler[string]
  - _defaultQueryHandler: QueryHandler
  + registerQuery(sql: string, handler: QueryHandler): UIMSqlLoopbackDriver
  + registerExec(sql: string, handler: ExecHandler): UIMSqlLoopbackDriver
  + setDefaultQuery(handler: QueryHandler): UIMSqlLoopbackDriver
  + presetRows(sql: string, rows: string[string][]): UIMSqlLoopbackDriver
}

UIMSqlRow ..|> ISqlRow
UIMSqlResult ..|> ISqlResult
UIMSqlConnection ..|> ISqlConnection
UIMSqlLoopbackDriver ..|> ISqlDriver

UIMSqlResult o-- ISqlRow
UIMSqlConnection --> ISqlDriver : delegates

@enduml
```

## Query Execution Sequence

```plantuml
@startuml SQL_Sequence

actor Application
participant Builder as "SqlSelectBuilder"
participant Connection as "UIMSqlConnection"
participant Driver as "ISqlDriver"
participant Result as "UIMSqlResult"

Application -> Builder: sqlSelect("users").where_("active = ?", sqlBool(true)).limit_(10).build()
Builder --> Application: SqlQuery(sql, params)

Application -> Connection: open("loopback://")
Connection -> Driver: driver.open(connectionString)
Driver --> Connection: true
Connection --> Application: true

Application -> Connection: query(q.sql, q.params)
Connection -> Driver: query(sql, params)
Driver --> Connection: ISqlResult
Connection --> Application: ISqlResult

Application -> Result: front() / popFront() / empty()
Application -> Connection: close()

@enduml
```
