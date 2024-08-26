

CREATE TABLE "Taller1".clientes (
	nombre varchar NULL,
	edad int4 NULL,
	correo varchar NULL,
	identificacion varchar NOT NULL,
	CONSTRAINT clientes_pk PRIMARY KEY (identificacion)
);


CREATE TABLE "Taller1".productos (
	codigo varchar NOT NULL,
	nombre varchar NULL,
	stock int NULL,
	valor_unitario float8 NULL,
	CONSTRAINT productos_pk PRIMARY KEY (codigo)
);

CREATE TABLE "Taller1".pedidos (
	fecha date NULL,
	cantidad int NULL,
	valor_total float8 NULL,
	producto_id varchar NOT NULL,
	cliente_id varchar NOT NULL,
	id serial NOT NULL,
	CONSTRAINT pedidos_unique UNIQUE (producto_id),
	CONSTRAINT pedidos_unique_1 UNIQUE (cliente_id),
	CONSTRAINT pedidos_pk PRIMARY KEY (id),
	CONSTRAINT pedidos_clientes_fk FOREIGN KEY (cliente_id) REFERENCES "Taller1".clientes(identificacion) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT pedidos_productos_fk FOREIGN KEY (producto_id) REFERENCES "Taller1".productos(codigo) ON DELETE CASCADE ON UPDATE CASCADE
);


INSERT INTO "Taller1".clientes (nombre, edad, correo, identificacion) VALUES('Maria', 20, 'maraj.munozp@autonoma.edu.co', '1056121086');
INSERT INTO "Taller1".clientes (nombre, edad, correo, identificacion) VALUES('Martin', 20, 'martis.ostiosa@autonoma.edu.co', '1055751017');


INSERT INTO "Taller1".productos (codigo, nombre, stock, valor_unitario) VALUES('012', 'Camisas', 120, 30000);
INSERT INTO "Taller1".productos (codigo, nombre, stock, valor_unitario) VALUES('045', 'Tenis', 246, 170000);

INSERT INTO "Taller1".pedidos (fecha, cantidad, valor_total, producto_id, cliente_id) VALUES('20/08/2024', 2, 340000, '012', '1056121086' );
INSERT INTO "Taller1".pedidos (fecha, cantidad, valor_total, producto_id, cliente_id) VALUES('23/08/2024', 3, 90000, '045', '1055751017' );



SELECT  * FROM clientes;
----------TALLER 3 PARTE UNO : TRANSACCIONES CON ROLLBACK
BEGIN;
	INSERT INTO "Taller1".clientes (nombre, edad, correo, identificacion) VALUES('Julian', 20, 'juliana.velozac@autonoma.edu.co', '1052631425');
	INSERT INTO "Taller1".clientes (nombre, edad, correo, identificacion) VALUES('Andres', 21, 'asdrubala.pereza@autonoma.edu.co', '105789641');
	INSERT INTO "Taller1".clientes (nombre, edad, correo, identificacion) VALUES('Lesmes', 20, 'santiago.lesmesm@autonoma.edu.co', '1057896456');
	
	------PRODUCTOS INSERT
	INSERT INTO "Taller1".productos (codigo, nombre, stock, valor_unitario) VALUES('123', 'Pantalones', 19, 80000);
	INSERT INTO "Taller1".productos (codigo, nombre, stock, valor_unitario) VALUES('124', 'Gorras', 10, 50000);
	INSERT INTO "Taller1".productos (codigo, nombre, stock, valor_unitario) VALUES('125', 'Sacos', 8, 55000);
	
	------PEDIDO INSERT
	INSERT INTO "Taller1".pedidos (fecha, cantidad, valor_total, producto_id, cliente_id) VALUES('21/08/2024', 4, 320000, '123', '1052631425' );
	INSERT INTO "Taller1".pedidos (fecha, cantidad, valor_total, producto_id, cliente_id) VALUES('15/08/2024', 1, 50000, '124', '1057896456' );
	INSERT INTO "Taller1".pedidos (fecha, cantidad, valor_total, producto_id, cliente_id) VALUES('18/08/2024', 9, 495000, '125', '105789641' );
	
	------CLIENTES UPDATE
	UPDATE "Taller1".clientes SET nombre='Juanes', edad=24, correo='juane.bricenom@autonoma.edu.co' WHERE identificacion='105789641';
	UPDATE "Taller1".clientes SET nombre='Juliana', edad=40, correo='lovegatos@gmail.com' WHERE identificacion='1052631425';
	
	------PRODUCTO UPDATE
	UPDATE "Taller1".productos SET nombre='Aretes', stock=20, valor_unitario=12000 WHERE codigo='124';
	UPDATE "Taller1".productos SET valor_unitario=40000 WHERE codigo='125';
	
	------PEDIDO UPDATE
	UPDATE "Taller1".pedidos SET cantidad=3  WHERE producto_id ='123';
	UPDATE "Taller1".pedidos SET fecha='12/07/2024' WHERE producto_id ='125';
	
	------PEDIDIO DELETE
	DELETE FROM "Taller1".pedidos WHERE producto_id='045';
	
	------CLIENTE DELETE
	DELETE FROM "Taller1".clientes WHERE identificacion='1055751017';
	
	------PRODUCTO DELETE
	DELETE FROM "Taller1".productos WHERE codigo='124';
	
ROLLBACK;
SELECT  * FROM clientes;

----------TALLER 3 PARTE 2:TRANSACCIONES CON SAVEPOINT
SELECT  * FROM clientes;
BEGIN;
	INSERT INTO "Taller1".clientes (nombre, edad, correo, identificacion) VALUES('Julian', 20, 'juliana.velozac@autonoma.edu.co', '1052631425');
	INSERT INTO "Taller1".clientes (nombre, edad, correo, identificacion) VALUES('Andres', 21, 'asdrubala.pereza@autonoma.edu.co', '105789641');
	INSERT INTO "Taller1".clientes (nombre, edad, correo, identificacion) VALUES('Lesmes', 20, 'santiago.lesmesm@autonoma.edu.co', '1057896456');
	
	------PRODUCTOS INSERT
	INSERT INTO "Taller1".productos (codigo, nombre, stock, valor_unitario) VALUES('123', 'Pantalones', 19, 80000);
	INSERT INTO "Taller1".productos (codigo, nombre, stock, valor_unitario) VALUES('124', 'Gorras', 10, 50000);
	INSERT INTO "Taller1".productos (codigo, nombre, stock, valor_unitario) VALUES('125', 'Sacos', 8, 55000);
	
	------PEDIDO INSERT
	INSERT INTO "Taller1".pedidos (fecha, cantidad, valor_total, producto_id, cliente_id) VALUES('21/08/2024', 4, 320000, '123', '1052631425' );
	INSERT INTO "Taller1".pedidos (fecha, cantidad, valor_total, producto_id, cliente_id) VALUES('15/08/2024', 1, 50000, '124', '1057896456' );
	INSERT INTO "Taller1".pedidos (fecha, cantidad, valor_total, producto_id, cliente_id) VALUES('18/08/2024', 9, 495000, '125', '105789641' );
	
	SAVEPOINT punto_de_restauracion;

	------CLIENTES UPDATE
	UPDATE "Taller1".clientes SET nombre='Juanes', edad=24, correo='juane.bricenom@autonoma.edu.co' WHERE identificacion='105789641';
	UPDATE "Taller1".clientes SET nombre='Juliana', edad=40, correo='lovegatos@gmail.com' WHERE identificacion='1052631425';
	
	------PRODUCTO UPDATE
	UPDATE "Taller1".productos SET nombre='Aretes', stock=20, valor_unitario=12000 WHERE codigo='124';
	UPDATE "Taller1".productos SET valor_unitario=40000 WHERE codigo='125';
	
	------PEDIDO UPDATE
	UPDATE "Taller1".pedidos SET cantidad=3  WHERE producto_id ='123';
	UPDATE "Taller1".pedidos SET fecha='12/07/2024' WHERE producto_id ='125';
	
	------PEDIDIO DELETE
	DELETE FROM "Taller1".pedidos WHERE producto_id='045';
	
	------CLIENTE DELETE
	DELETE FROM "Taller1".clientes WHERE identificacion='1055751017';
	
	------PRODUCTO DELETE
	DELETE FROM "Taller1".productos WHERE codigo='124';
	
ROLLBACK TO SAVEPOINT punto_de_restauracion;
COMMIT;
SELECT  * FROM clientes;




