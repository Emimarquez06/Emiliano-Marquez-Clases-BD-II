CREATE DATABASE IF NOT EXISTS sakila;
USE sakila;

CREATE TABLE contacts (
  contact_id INT(11) NOT NULL AUTO_INCREMENT,
  last_name VARCHAR(30) NOT NULL,
  first_name VARCHAR(25),
  birthday DATE,
  CONSTRAINT contacts_pk PRIMARY KEY (contact_id)
);

CREATE TABLE products (
  product_name VARCHAR(50) NOT NULL,
  location VARCHAR(50) NOT NULL,
  category VARCHAR(25),
  CONSTRAINT products_pk PRIMARY KEY (product_name, location)
);

CREATE TABLE inventory (
  inventory_id INT PRIMARY KEY,
  product_name VARCHAR(50) NOT NULL,
  location VARCHAR(50) NOT NULL,
  quantity INT,
  min_level INT,
  max_level INT
);

ALTER TABLE inventory 
  ADD CONSTRAINT fk_inventory_products 
  FOREIGN KEY (product_name, location)
  REFERENCES products (product_name, location)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;


ALTER TABLE contacts
  ADD last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP 
  ON UPDATE CURRENT_TIMESTAMP;

ALTER TABLE contacts
  MODIFY last_name VARCHAR(50) NULL;

ALTER TABLE contacts
  CHANGE COLUMN contact_type ctype VARCHAR(20) NOT NULL;

ALTER TABLE contacts
  RENAME TO people;

INSERT INTO products (product_name, location, category) VALUES
('Laptop', 'Warehouse 1', 'Electronics'),
('Phone', 'Warehouse 2', 'Electronics');

INSERT INTO inventory (inventory_id, product_name, location, quantity, min_level, max_level) VALUES
(1, 'Laptop', 'Warehouse 1', 50, 10, 100),
(2, 'Phone', 'Warehouse 2', 30, 5, 50);
