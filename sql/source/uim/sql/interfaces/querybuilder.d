/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.sql.interfaces.querybuilder;

import uim.sql;

/**
 * Interface for fluent SQL query building
 */
interface IQueryBuilder {
    /**
     * Start SELECT query
     */
    IQueryBuilder select(string[] columns...);

    /**
     * Specify table
     */
    IQueryBuilder from(string table);

    /**
     * Add WHERE clause
     */
    IQueryBuilder where(string column, string op, SqlValue value);

    /**
     * Add WHERE clause with raw SQL
     */
    IQueryBuilder whereRaw(string condition, SqlValue[] params = null);

    /**
     * Add AND WHERE clause
     */
    IQueryBuilder andWhere(string column, string op, SqlValue value);

    /**
     * Add OR WHERE clause
     */
    IQueryBuilder orWhere(string column, string op, SqlValue value);

    /**
     * Add WHERE IN clause
     */
    IQueryBuilder whereIn(string column, SqlValue[] values);

    /**
     * Add WHERE NOT IN clause
     */
    IQueryBuilder whereNotIn(string column, SqlValue[] values);

    /**
     * Add WHERE NULL clause
     */
    IQueryBuilder whereNull(string column);

    /**
     * Add WHERE NOT NULL clause
     */
    IQueryBuilder whereNotNull(string column);

    /**
     * Add JOIN clause
     */
    IQueryBuilder join(string table, string condition, JoinType type = JoinType.INNER);

    /**
     * Add LEFT JOIN
     */
    IQueryBuilder leftJoin(string table, string condition);

    /**
     * Add RIGHT JOIN
     */
    IQueryBuilder rightJoin(string table, string condition);

    /**
     * Add GROUP BY clause
     */
    IQueryBuilder groupBy(string[] columns...);

    /**
     * Add HAVING clause
     */
    IQueryBuilder having(string condition);

    /**
     * Add ORDER BY clause
     */
    IQueryBuilder orderBy(string column, SortOrder order = SortOrder.ASC);

    /**
     * Add LIMIT clause
     */
    IQueryBuilder limit(size_t count);

    /**
     * Add OFFSET clause
     */
    IQueryBuilder offset(size_t count);

    /**
     * Start INSERT query
     */
    IQueryBuilder insert(string table);

    /**
     * Set values for INSERT
     */
    IQueryBuilder values(SqlValue[string] values);

    /**
     * Start UPDATE query
     */
    IQueryBuilder update(string table);

    /**
     * Set values for UPDATE
     */
    IQueryBuilder set(string column, SqlValue value);

    /**
     * Start DELETE query
     */
    IQueryBuilder delete_();

    /**
     * Build SQL string
     */
    string toSql() const;

    /**
     * Get parameters
     */
    SqlValue[] parameters() const;

    /**
     * Get query type
     */
    QueryType queryType() const;

    /**
     * Reset builder
     */
    void reset();
}
