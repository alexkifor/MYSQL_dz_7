-- Составить список пользователей users, которые осуществили хотя бы
-- один заказ orders в интернет-магазине
CREATE TABLE IF NOT EXISTS orders (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  );
CREATE TABLE IF NOT EXISTS products (
  id SERIAL PRIMARY KEY,
  name VARCHAR (255)
  );
  
  INSERT INTO products(name) VALUES
    ('Intel Core i5-7400'),
    ('Gigabyte H430 M'),
    ('AMD FX-8320'),
    ('ASUS RTX 3080TI');
  
CREATE TABLE IF NOT EXISTS orders_products (
  id SERIAL PRIMARY KEY,
  order_id BIGINT UNSIGNED NOT NULL,
  product_id BIGINT UNSIGNED NOT NULL,
  total INT NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(id),
  FOREIGN KEY (product_id) REFERENCES products(id)
  );
SELECT * FROM users;
SELECT * FROM orders;
SELECT * FROM orders_products;

INSERT INTO orders(user_id)
  SELECT id FROM users WHERE first_name = 'Игорь';
  
INSERT INTO orders_products(order_id, product_id, total)
  SELECT LAST_INSERT_ID(), id, 2 FROM products
  WHERE name = 'Intel Core i5-7400';
  
INSERT INTO orders(user_id)
  SELECT id FROM users WHERE first_name = 'Дарья';
  
INSERT INTO orders_products(order_id, product_id, total)
  SELECT LAST_INSERT_ID(), id, 2 FROM products
  WHERE name IN ('AMD FX-8320', 'ASUS RTX 3080TI');
  
INSERT INTO orders(user_id)
  SELECT id FROM users WHERE first_name = 'Александр';
  
INSERT INTO orders_products(order_id, product_id, total)
  SELECT LAST_INSERT_ID(), id, 1 FROM products
  WHERE name = 'Gigabyte H430 M';  
  
SELECT u.id, u.first_name, u.last_name
  FROM users AS u
  JOIN orders AS o ON u.id = o.user_id;
  
-- Выведите список товаров products и разделов catalogs, который соответствует товару
ALTER TABLE products ADD COLUMN price INT;
UPDATE products SET price = 15800 WHERE id = 1;
UPDATE products SET price = 8900 WHERE id = 2;
UPDATE products SET price = 45200 WHERE id = 3;
UPDATE products SET price = 85700 WHERE id = 4;

CREATE TABLE IF NOT EXISTS catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR (255)
  );
INSERT INTO catalogs (name) VALUES
  ('Процессоры'),
  ('Материнские платы'),
  ('Видеокарты');
ALTER TABLE products ADD COLUMN catalog_id BIGINT UNSIGNED NOT NULL;
UPDATE products SET catalog_id = 1 WHERE id = 1;
UPDATE products SET catalog_id = 2 WHERE id = 2;
UPDATE products SET catalog_id = 3 WHERE id = 3;
UPDATE products SET catalog_id = 3 WHERE id = 4;
ALTER TABLE products
  ADD CONSTRAINT products_catalog_id_fk
    FOREIGN KEY (catalog_id) REFERENCES catalogs(id);
SELECT 
  p.id,
  p.name,
  p.price,
  c.name aS catalog
  FROM products AS p
  LEFT JOIN catalogs AS c ON p.catalog_id = c.id;

-- Пусть имеется таблица рейсов flights(id, from, to) и таблица городов cities(
-- label, name). Поля from_fly, to_fly и label содержат английские названия городов,
-- поле name - русское. Выведите список рейсов flights с русскими названиями городов.

DROP TABLE IF EXISTS flights;
CREATE TABLE flights (
  id SERIAL PRIMARY KEY,
  from_fly VARCHAR (200) COMMENT 'Город отправления',
  to_fly VARCHAR (200) COMMENT 'Город прибытия'
  ) COMMENT 'Рейсы';
  
INSERT INTO flights(from_fly, to_fly) VALUES
  ('Moscow', 'Omsk'),
  ('Novgorod', 'Kazan'),
  ('Irkutsk', 'Moscow'),
  ('Omsk', 'Sochi'),
  ('Moscow', 'Kazan');
  
 DROP TABLE IF EXISTS cities;
 CREATE TABLE cities (
   id SERIAL PRIMARY KEY,
   label VARCHAR (200) COMMENT 'Код города',
   name VARCHAR (200) COMMENT 'Название города'
   );
   
 INSERT INTO cities (label, name) VALUES
   ('Moscow', 'Москва'),
   ('Kazan', 'Казань'),
   ('Sochi', 'Сочи'),
   ('Novgorod', 'Новгород'),
   ('Irkutsk', 'Иркутск'),
   ('Omsk', 'Омск');
   
SELECT 
  f.id,
  cities_from.name AS 'from',
  cities_to.name AS 'to'
FROM flights AS f
  JOIN cities AS cities_from
    ON f.from_fly = cities_from.label
  JOIN cities AS cities_to
    ON f.to_fly = cities_to.label;
  
