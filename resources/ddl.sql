CREATE SCHEMA IF NOT EXISTS schema_dsad;

CREATE TABLE IF NOT EXISTS schema_dsad.price(
        first_name VARCHAR(50),
        last_name VARCHAR(50),
        price INTEGER,
        above_100 BOOLEAN,
        PRIMARY KEY (first_name, last_name, price)
);