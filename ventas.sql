-- Desafío - Entendiendo cómo se comportan nuestros clientes

--1. Cargar el respaldo de la base de datos unidad2.sql.
-- Comandos en la terminal:
psql
CREATE DATABASE unidad2;
\q
psql -U rodrigo unidad2 < unidad2.sql

-- Conectarse a la base unidad2
\c unidad2

--2. El cliente usuario01 ha realizado la siguiente compra:
-- producto: producto9
-- cantidad: 5
-- fecha: fecha del sistema

BEGIN;

INSERT INTO compra (cliente_id, fecha)
VALUES ((SELECT id FROM cliente WHERE nombre = 'usuario01'), now());

INSERT INTO detalle_compra (producto_id, compra_id, cantidad)
VALUES ((SELECT id FROM producto WHERE descripcion = 'producto9'), (SELECT MAX(id) FROM compra), 5);

UPDATE producto SET stock = stock - 5 WHERE id = (SELECT id FROM producto WHERE descripcion = 'producto9');

COMMIT;

SELECT stock FROM producto WHERE id = (SELECT id FROM producto WHERE descripcion = 'producto9');

--3.  El cliente usuario02 ha realizado la siguiente compra:
-- producto: producto1, producto 2, producto 8
-- cantidad: 3 de cada producto
-- fecha: fecha del sistema

BEGIN;

INSERT INTO compra (cliente_id, fecha)
VALUES ((SELECT id FROM cliente WHERE nombre = 'usuario02'), now());

INSERT INTO detalle_compra (producto_id, compra_id, cantidad)
VALUES ((SELECT id FROM producto WHERE descripcion = 'producto1'), 
(SELECT MAX(id) FROM compra), 3);   

UPDATE producto SET stock = stock - 3 WHERE descripcion = 'producto1';


INSERT INTO detalle_compra (producto_id, compra_id, cantidad)
VALUES ((SELECT id FROM producto WHERE descripcion = 'producto2'), 
(SELECT MAX(id) FROM compra), 3);   

UPDATE producto SET stock = stock - 3 WHERE descripcion = 'producto2';


INSERT INTO detalle_compra (producto_id, compra_id, cantidad)
VALUES ((SELECT id FROM producto WHERE descripcion = 'producto8'), 
(SELECT MAX(id) FROM compra), 3);   

UPDATE producto SET stock = stock - 3 WHERE descripcion = 'producto8';

COMMIT;


--4. Realizar las siguientes consultas:

--a. Deshabilitar el AUTOCOMMIT
psql
\set AUTOCOMMIT off
\echo :AUTOCOMMIT

--b. Insertar un nuevo cliente
BEGIN;
SAVEPOINT users;
INSERT INTO cliente (nombre, email)
VALUES('usuario11', 'usuario11@gmail.com');
COMMIT;

--c. Confirmar que fue agregado en la tabla cliente
SELECT * FROM cliente WHERE nombre = 'usuario11';

--d. Realizar un ROLLBACK
ROLLBACK TO users;

--e. Confirmar que se restauró la información, sin considerar la inserción del punto b
SELECT * FROM cliente WHERE nombre = 'usuario11';

--f. Habilitar de nuevo el AUTOCOMMIT
psql
\set AUTOCOMMIT on
\echo :AUTOCOMMIT           







