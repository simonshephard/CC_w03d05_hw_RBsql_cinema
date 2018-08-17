DROP TABLE tickets;
DROP TABLE screenings;
DROP TABLE films;
DROP TABLE customers;

CREATE TABLE customers (
  id SERIAL8 PRIMARY KEY,
  name VARCHAR(255),
  funds INT8
);

CREATE TABLE films (
  id SERIAL8 PRIMARY KEY,
  title VARCHAR(255),
  price INT8
);

CREATE TABLE screenings (
  id SERIAL8 PRIMARY KEY,
  screen INT8,
  start_time VARCHAR(255),
  capacity INT8,
  film_id INT8 REFERENCES films(id) ON DELETE CASCADE
);

CREATE TABLE tickets (
  id SERIAL8 PRIMARY KEY,
  customer_id INT8 REFERENCES customers(id) ON DELETE CASCADE,
  screening_id INT8 REFERENCES screenings(id) ON DELETE CASCADE
);
