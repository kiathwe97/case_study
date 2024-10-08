CREATE SCHEMA IF NOT EXISTS q2schema;

CREATE TABLE IF NOT EXISTS q2schema.manufacturer(
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL
);


CREATE TABLE IF NOT EXISTS q2schema.car_model(
	id SERIAL PRIMARY KEY,
	model_name VARCHAR(50) NOT NULL,
	manufacturer_id INTEGER NOT NULL,
	weight DECIMAL(7,2),
	CONSTRAINT fk_mfg FOREIGN KEY (manufacturer_id) REFERENCES q2schema.manufacturer(id)
		ON DELETE SET NULL
		ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS q2schema.car(
	serial_number VARCHAR(20) PRIMARY KEY,
	car_model_id INTEGER NOT NULL,
    price DECIMAL(10,2) NOT NULL,
	CONSTRAINT fk_car_model FOREIGN KEY (car_model_id) REFERENCES q2schema.car_model(id)
		ON DELETE SET NULL
		ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS q2schema.salesperson(
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL
);


CREATE TABLE IF NOT EXISTS q2schema.customer(
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	phone_number CHAR(8) NOT NULL CHECK (phone_number ~ '^[0-9]{8}$')
);


CREATE TABLE IF NOT EXISTS q2schema.transaction(
	car_serial_number VARCHAR(20) PRIMARY KEY,
	salesperson_id INTEGER NOT NULL,
	customer_id INTEGER NOT NULL,
    date_txn TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (car_serial_number) REFERENCES q2schema.car(serial_number)
		ON DELETE SET NULL
		ON UPDATE CASCADE,
	FOREIGN KEY (salesperson_id) REFERENCES q2schema.salesperson(id)
		ON DELETE SET NULL
		ON UPDATE CASCADE,
	FOREIGN KEY (customer_id) REFERENCES q2schema.customer(id)
		ON DELETE SET NULL
		ON UPDATE CASCADE

);