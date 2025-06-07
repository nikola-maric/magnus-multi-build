use magnus::{function, prelude::*, Error, Ruby};
use duckdb::Connection;

fn reverse_string(input: String) -> String {
    input.chars().rev().collect()
}

fn duckdb_query(query: String) -> Result<String, Error> {
    let conn = Connection::open_in_memory()
        .map_err(|e| Error::new(magnus::exception::runtime_error(), format!("DuckDB connection failed: {}", e)))?;

    let sql = format!("SELECT {}", query);
    let mut stmt = conn.prepare(&sql)
        .map_err(|e| Error::new(magnus::exception::runtime_error(), format!("DuckDB prepare failed: {}", e)))?;

    let mut rows = stmt.query([])
        .map_err(|e| Error::new(magnus::exception::runtime_error(), format!("DuckDB query failed: {}", e)))?;

    if let Some(row) = rows.next()
        .map_err(|e| Error::new(magnus::exception::runtime_error(), format!("DuckDB row fetch failed: {}", e)))? {
        let result: String = row.get(0)
            .map_err(|e| Error::new(magnus::exception::runtime_error(), format!("DuckDB value extraction failed: {}", e)))?;
        Ok(result)
    } else {
        Ok("No results".to_string())
    }
}

#[magnus::init]
fn init(ruby: &Ruby) -> Result<(), Error> {
    let class = ruby.define_class("RustStringUtils", ruby.class_object())?;
    class.define_singleton_method("reverse", function!(reverse_string, 1))?;
    class.define_singleton_method("duckdb_query", function!(duckdb_query, 1))?;
    Ok(())
}