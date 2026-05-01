# uim-odbc

An object-oriented D wrapper of the ODBC C API, inspired by the
[SAP odbc-cpp-wrapper](https://github.com/SAP/odbc-cpp-wrapper).

## Features

- **OdbcEnvironment** – manages the ODBC environment handle; factory for connections
- **OdbcConnection** – connects to databases via DSN or driver connection string; supports auto-commit, transactions, read-only mode, and timeout configuration
- **OdbcStatement** – executes ad-hoc SQL queries (no parameters)
- **OdbcPreparedStatement** – executes pre-compiled SQL with typed parameter binding and batch support
- **OdbcResultSet** – iterates rows with type-safe `getXxx(columnIndex)` getters
- **OdbcResultSetMetaData** – describes column names, types, sizes and nullability
- **OdbcDecimal** – fixed-point decimal number with precision and scale
- **OdbcException** – captures ODBC diagnostic records as a D exception
- Type aliases (`OdbcInt`, `OdbcString`, …) wrapping `std.typecons.Nullable`
- Standard `std.datetime` types (`Date`, `TimeOfDay`, `DateTime`) used for date/time columns

## Requirements

- D compiler (DMD / LDC / GDC)
- **Linux/macOS**: unixODBC (`libodbc`) or iODBC
- **Windows**: the built-in `odbc32.dll`

### Install unixODBC on Linux (Debian/Ubuntu)

```sh
sudo apt install unixodbc unixodbc-dev
```

## Quick-start example

```d
import uim.odbc;
import std.stdio  : writeln;
import std.typecons : nullable;

void main()
{
    // 1. Create environment
    auto env  = OdbcEnvironment.create();

    // 2. Create and open a connection
    auto conn = env.createConnection();
    conn.connect("MyDSN", "user", "password");
    conn.setAutoCommit(false);

    // 3. Batch INSERT via PreparedStatement
    auto psInsert = conn.prepareStatement(
        "INSERT INTO products (id, name, price) VALUES (?, ?, ?)");

    psInsert.setInt(1,    nullable(101));
    psInsert.setString(2, nullable("Widget A"));
    psInsert.setDouble(3, nullable(9.99));
    psInsert.addBatch();

    psInsert.setInt(1,    nullable(102));
    psInsert.setString(2, nullable("Widget B"));
    psInsert.setDouble(3, nullable(14.50));
    psInsert.addBatch();

    psInsert.executeBatch();
    conn.commit();

    // 4. SELECT via PreparedStatement
    auto psSelect = conn.prepareStatement(
        "SELECT id, name, price FROM products WHERE id > ?");
    psSelect.setInt(1, nullable(100));

    auto rs = psSelect.executeQuery();
    while (rs.next()) {
        auto id    = rs.getInt(1);
        auto name  = rs.getString(2);
        auto price = rs.getDouble(3);
        writeln(id.get, ", ", name.get, ", ", price.get);
    }
    rs.close();

    conn.disconnect();
}
```

## Module layout

```
source/uim/odbc/
├── package.d                  Top-level re-export
├── bindings/
│   └── sql.d                  Raw ODBC C API (types, constants, functions)
├── types/
│   ├── package.d              Re-exports + OdbcXxx type aliases
│   └── decimal_.d             OdbcDecimal struct
├── enumerations/
│   ├── package.d
│   └── types.d                DSNType, TransactionIsolationLevel, SQLDataType, …
└── classes/
    ├── package.d
    ├── exception.d            OdbcException + checkOdbc helper
    ├── environment.d          OdbcEnvironment
    ├── connection.d           OdbcConnection
    ├── statement.d            OdbcStatement
    ├── preparedstatement.d    OdbcPreparedStatement (with batch support)
    ├── resultset.d            OdbcResultSet
    └── resultsetmetadata.d    OdbcResultSetMetaData
```

## License

Apache 2.0 – see [LICENSE](../LICENSE).
