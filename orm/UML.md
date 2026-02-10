/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/

# UIM-ORM UML Description

## Overview
The UIM-ORM framework provides a comprehensive, type-safe Object-Relational Mapping solution for D language applications. It integrates seamlessly with vibe.d for asynchronous, non-blocking database operations and provides a fluent query builder, model mapping, relationship management, and migration support.

## Architecture Layers

### 1. Interface Layer (uim.orm.interfaces)
Defines contracts for all ORM components:

```plantuml
@startuml ORM_Interfaces

interface IDatabase {
  + driver(): string
  + isConnected(): bool
  + connect(): void
  + disconnect(): void
  + query(sql: string, callback: delegate): void
  + query(sql: string, params: Json[string], callback: delegate): void
  + beginTransaction(): void
  + commit(): void
  + rollback(): void
  + lastInsertId(): long
  + affectedRows(): long
}

interface IQuery {
  + select(columns: string[]): IQuery
  + from(table: string): IQuery
  + where(condition: string): IQuery
  + where(condition: string, params: Json[string]): IQuery
  + and(condition: string): IQuery
  + or(condition: string): IQuery
  + orderBy(column: string, direction: string): IQuery
  + limit(count: size_t): IQuery
  + offset(count: size_t): IQuery
  + groupBy(columns: string[]): IQuery
  + having(condition: string): IQuery
  + join(table: string, condition: string, type: string): IQuery
  + toSql(): string
  + params(): Json[string]
  + execute(callback: delegate): void
  + first(callback: delegate): void
  + get(callback: delegate): void
  + count(callback: delegate): void
}

interface IORMModel {
  + tableName(): string
  + primaryKey(): string
  + columnMappings(): string[string]
  + hasTimestamps(): bool
  + find(id: long, callback: delegate): void
  + all(callback: delegate): void
  + create(entity: IEntity, callback: delegate): void
  + update(entity: IEntity, callback: delegate): void
  + delete(entity: IEntity, callback: delegate): void
  + query(): IQuery
  + database(): IDatabase
}

interface IMigration {
  + up(): void
  + down(): void
}

IDatabase --> IQuery : creates
IORMModel --> IDatabase : uses
IORMModel --> IQuery : uses

@enduml
```

### 2. Implementation Layer (uim.orm.connections)

```plantuml
@startuml ORM_Connections

abstract class BaseDatabase {
  # _host: string
  # _port: ushort
  # _database: string
  # _username: string
  # _password: string
  # _isConnected: bool
  # _lastInsertId: long
  # _affectedRows: long
  
  + driver(): string
  + isConnected(): bool
  + connect(): void
  + disconnect(): void
  + query(sql: string, callback: delegate): void
  # executeAsync(sql: string, callback: delegate): void
}

class MySQLDatabase {
  - _connection: MySQLConnection
  - _prepared: Statement[string]
  
  + driver(): string
  + connect(): void
  + disconnect(): void
}

class SQLiteDatabase {
  - _connection: Database
  
  + driver(): string
  + connect(): void
  + disconnect(): void
}

class DatabaseConnectionPool {
  - _connections: IDatabase[string]
  - _activeConnections: size_t
  - _maxConnections: size_t
  - _queue: IDatabase[]
  
  + getConnection(name: string): IDatabase
  + releaseConnection(conn: IDatabase): void
  + closeAll(): void
  + getActiveCount(): size_t
}

BaseDatabase ..|> IDatabase
MySQLDatabase --|> BaseDatabase
SQLiteDatabase --|> BaseDatabase

@enduml
```

### 3. Query Builder Layer (uim.orm.builders)

```plantuml
@startuml ORM_QueryBuilder

class SQLQueryBuilder {
  - _database: IDatabase
  - _select: string[]
  - _from: string
  - _where: string[]
  - _params: Json[string]
  - _orderBy: string[]
  - _limit: size_t
  - _offset: size_t
  - _joins: string[]
  - _groupBy: string[]
  - _having: string
  
  + this(database: IDatabase)
  + select(columns: string[]): IQuery
  + from(table: string): IQuery
  + where(condition: string): IQuery
  + and(condition: string): IQuery
  + or(condition: string): IQuery
  + orderBy(column: string, direction: string): IQuery
  + limit(count: size_t): IQuery
  + offset(count: size_t): IQuery
  + join(table: string, condition: string, type: string): IQuery
  + toSql(): string
  + execute(callback: delegate): void
  + first(callback: delegate): void
  + get(callback: delegate): void
  + count(callback: delegate): void
  # buildSql(): string
  # bindParams(sql: string): string
}

SQLQueryBuilder ..|> IQuery
SQLQueryBuilder --> IDatabase : uses

@enduml
```

### 4. Model Mapping Layer (uim.orm.mappers)

```plantuml
@startuml ORM_ModelMapping

abstract class ORMModel {
  # _database: IDatabase
  # _data: Json[string]
  # _isDirty: bool
  # _originalData: Json[string]
  
  + this()
  + tableName(): string
  + primaryKey(): string
  + columnMappings(): string[string]
  + hasTimestamps(): bool
  + find(id: long, callback: delegate): void
  + all(callback: delegate): void
  + create(entity: IEntity, callback: delegate): void
  + update(entity: IEntity, callback: delegate): void
  + delete(entity: IEntity, callback: delegate): void
  + query(): IQuery
  + database(): IDatabase
  + database(db: IDatabase): void
  + save(callback: delegate): void
  + fill(data: Json[string]): void
  + toJson(): Json
  + isDirty(): bool
}

class EntityMapper {
  - _modelClass: TypeInfo
  - _mappings: string[string]
  
  + this(modelClass: TypeInfo)
  + mapToEntity(data: Json[string]): IEntity
  + mapFromEntity(entity: IEntity): Json[string]
  + applyTimestamps(data: Json[string]): Json[string]
  # getCurrentTimestamp(): string
}

ORMModel ..|> IORMModel
ORMModel ..|> IEntity
ORMModel --> IDatabase : uses
ORMModel --> IQuery : uses
EntityMapper --> ORMModel : converts

@enduml
```

### 5. Relationships Layer (uim.orm.relationships)

```plantuml
@startuml ORM_Relationships

enum RelationType {
  HasOne
  HasMany
  BelongsTo
  BelongsToMany
}

class Relationship {
  - _type: RelationType
  - _parentModel: IORMModel
  - _relatedModel: IORMModel
  - _foreignKey: string
  - _localKey: string
  - _pivotTable: string
  
  + this(type: RelationType, parent: IORMModel, related: IORMModel)
  + foreignKey(key: string): Relationship
  + localKey(key: string): Relationship
  + pivotTable(table: string): Relationship
  + load(callback: delegate): void
  + get(callback: delegate): void
}

class RelationshipLoader {
  - _relationships: Relationship[string]
  - _eagerLoading: string[]
  
  + register(name: string, relation: Relationship): void
  + addEagerLoad(name: string): void
  + loadAll(model: IORMModel, callback: delegate): void
  - loadHasOne(relation: Relationship, callback: delegate): void
  - loadHasMany(relation: Relationship, callback: delegate): void
  - loadBelongsTo(relation: Relationship, callback: delegate): void
  - loadBelongsToMany(relation: Relationship, callback: delegate): void
}

Relationship --> RelationType
RelationshipLoader o-- Relationship : manages

@enduml
```

### 6. Migrations Layer (uim.orm.migrations)

```plantuml
@startuml ORM_Migrations

interface IMigration {
  + up(): void
  + down(): void
}

abstract class Migration {
  # _database: IDatabase
  # _tableName: string
  
  + this(database: IDatabase)
  + up(): void
  + down(): void
  # createTable(name: string, columns: Column[]): void
  # dropTable(name: string): void
  # addColumn(table: string, column: Column): void
  # dropColumn(table: string, name: string): void
  # modifyColumn(table: string, column: Column): void
}

class MigrationRunner {
  - _migrations: IMigration[]
  - _database: IDatabase
  - _migrationsTable: string
  
  + this(database: IDatabase)
  + registerMigration(migration: IMigration): void
  + runPending(callback: delegate): void
  + rollback(steps: int, callback: delegate): void
  - recordMigration(name: string, callback: delegate): void
  - forgetMigration(name: string, callback: delegate): void
}

struct Column {
  + name: string
  + type: string
  + length: size_t
  + nullable: bool
  + default_: string
  + autoIncrement: bool
}

Migration ..|> IMigration
MigrationRunner --> IMigration : runs
MigrationRunner --> Column : uses

@enduml
```

### 7. Complete System Overview

```plantuml
@startuml ORM_System_Overview

package "uim.orm.interfaces" {
  interface IDatabase
  interface IQuery
  interface IORMModel
  interface IMigration
}

package "uim.orm.connections" {
  abstract class BaseDatabase
  class MySQLDatabase
  class SQLiteDatabase
  class DatabaseConnectionPool
}

package "uim.orm.builders" {
  class SQLQueryBuilder
}

package "uim.orm.mappers" {
  abstract class ORMModel
  class EntityMapper
}

package "uim.orm.relationships" {
  class Relationship
  class RelationshipLoader
}

package "uim.orm.migrations" {
  abstract class Migration
  class MigrationRunner
}

BaseDatabase ..|> IDatabase
MySQLDatabase --|> BaseDatabase
SQLiteDatabase --|> BaseDatabase
DatabaseConnectionPool --> IDatabase

SQLQueryBuilder ..|> IQuery
SQLQueryBuilder --> IDatabase

ORMModel ..|> IORMModel
ORMModel --> IDatabase
ORMModel --> IQuery
EntityMapper --> ORMModel

Relationship --> IORMModel
RelationshipLoader o-- Relationship

Migration ..|> IMigration
MigrationRunner --> IMigration

@enduml
```

### 8. Data Flow: Query Execution Pipeline

```plantuml
@startuml ORM_Query_Execution

actor Application
participant QueryBuilder
participant Database
participant Connection
database ResultSet

Application -> QueryBuilder: select().from().where()
activate QueryBuilder

QueryBuilder -> QueryBuilder: buildSql()
note over QueryBuilder: SELECT * FROM users WHERE active = 1

QueryBuilder -> Database: execute(sql, params)
activate Database

Database -> Database: bindParams()
Database -> Connection: executeQuery()
activate Connection

Connection -> Connection: preparStatement()
Connection -> Connection: executeAsync()
note over Connection: Non-blocking I/O via vibe.d

Connection -> ResultSet: fetchResults()
activate ResultSet
ResultSet --> Connection: Json[]
deactivate ResultSet

Connection --> Database: Json[]
deactivate Connection

Database --> Application: callback(success, results)
deactivate Database
deactivate QueryBuilder

@enduml
```

### 9. Model Lifecycle

```plantuml
@startuml ORM_Model_Lifecycle

actor Developer
participant Model
participant Database
participant Mapper

Developer -> Model: create()
activate Model
Model -> Model: new instance
Model --> Developer: model
deactivate Model

Developer -> Model: fill(data)
activate Model
Model -> Model: _data = data
Model --> Developer: model
deactivate Model

Developer -> Model: save()
activate Model
Model -> Database: create()
activate Database
Database --> Model: inserted ID
deactivate Database
Model -> Mapper: applyTimestamps()
Mapper --> Model: updated data
Model --> Developer: model
deactivate Model

Developer -> Model: find(id)
activate Model
Model -> Database: query()
activate Database
Database --> Model: Json result
deactivate Database
Model -> Mapper: mapToEntity()
Mapper --> Model: entity
Model --> Developer: entity
deactivate Model

Developer -> Model: attribute changes
activate Model
Model -> Model: _isDirty = true
Model --> Developer: model
deactivate Model

Developer -> Model: save()
activate Model
Model -> Database: update()
activate Database
Database --> Model: success
deactivate Database
Model --> Developer: model
deactivate Model

@enduml
```

## Component Descriptions

### IDatabase / BaseDatabase
**Purpose**: Manage database connections and execute raw queries
**Responsibilities**:
- Maintain connection state (open/closed)
- Execute async queries with callbacks
- Handle transactions (begin, commit, rollback)
- Track inserted IDs and affected rows
- Support parameterized queries to prevent SQL injection

### IQuery / SQLQueryBuilder
**Purpose**: Build SQL queries with fluent interface
**Responsibilities**:
- Build SELECT, INSERT, UPDATE, DELETE queries
- Support WHERE, JOIN, ORDER BY, LIMIT, OFFSET, GROUP BY, HAVING
- Bind parameters safely
- Execute and return results asynchronously
- Track selected columns, tables, and conditions

### IORMModel / ORMModel
**Purpose**: Map objects to database rows
**Responsibilities**:
- Define table and column mappings
- Load and save entity data
- Track dirty state for updates
- Support timestamps (created_at, updated_at)
- Provide query builder interface

### EntityMapper
**Purpose**: Convert between entities and database rows
**Responsibilities**:
- Map database columns to entity properties
- Apply automatic timestamps
- Serialize entities to Json
- Deserialize Json to entities

### Relationship
**Purpose**: Define relationships between models
**Responsibilities**:
- Support HasOne, HasMany, BelongsTo, BelongsToMany relationships
- Configure foreign and local keys
- Load related models
- Support eager loading optimization

### RelationshipLoader
**Purpose**: Load relationships efficiently
**Responsibilities**:
- Manage relationship definitions
- Perform eager loading to reduce queries
- Execute relationship queries asynchronously

### IMigration / Migration / MigrationRunner
**Purpose**: Version-control database schema
**Responsibilities**:
- Define up/down migrations
- Track executed migrations
- Run pending migrations
- Rollback previous migrations
- Support table and column operations

## Design Patterns Used

1. **Repository Pattern**: Models act as repositories for their data
2. **Query Builder Pattern**: Fluent interface for SQL construction
3. **Factory Pattern**: Query builders create queries
4. **Active Record Pattern**: Models include persistence logic
5. **Observer Pattern**: Relationship lazy loading
6. **Template Method**: Migration base class
7. **Async/Await Pattern**: All DB operations are non-blocking via vibe.d

## Key Features

- **Async-First Design**: All database operations are non-blocking via vibe.d task system
- **Type-Safe**: Compile-time type checking with D's strong type system
- **Fluent Query Builder**: Chainable interface for building complex queries
- **Automatic Timestamps**: Optionally manage created_at and updated_at automatically
- **Relationship Management**: HasOne, HasMany, BelongsTo, BelongsToMany support
- **Eager Loading**: Optimize queries by pre-loading relationships
- **Connection Pooling**: Manage multiple connections efficiently
- **Migration Support**: Version-controlled schema management
- **Transaction Support**: Begin, commit, and rollback transactions
- **Parameterized Queries**: SQL injection protection via parameter binding

## Async Compilation Pipeline Example

```d
// Query execution with async callbacks
auto query = new SQLQueryBuilder(db)
    .select("id", "name", "email")
    .from("users")
    .where("age > ?", ["age": Json(18)])
    .orderBy("name", "ASC");

query.get((bool success, Json[] results) {
    if (success) {
        foreach (row; results) {
            writeln("User: ", row["name"]);
        }
    } else {
        writeln("Query failed");
    }
});

// Model operations with async callbacks
auto user = new User();
user.database(db);

user.find(1, (bool success, IEntity entity) {
    if (success) {
        User u = cast(User) entity;
        u.email = "newemail@example.com";
        u.save((bool saved) {
            if (saved) {
                writeln("User updated");
            }
        });
    }
});
```

This UML description provides a comprehensive view of the uim-orm framework architecture,
showing the relationships between components, async patterns, and design patterns employed.
