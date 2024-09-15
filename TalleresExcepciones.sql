CREATE TABLE "Taller1Excepciones".usuarios (
	identificacion varchar NOT NULL,
	nombre varchar NULL,
	edad integer NULL,
	CONSTRAINT usuarios_pk PRIMARY KEY (identificacion)
);


CREATE TABLE "Taller1Excepciones".facturas (
	producto varchar NOT NULL,
	fecha date NULL,
	cantidad integer NULL,
	id varchar NOT NULL,
	valor_unitario integer NULL,
	valor_total integer NULL,
	usuario_id varchar NULL,
	CONSTRAINT facturas_pk PRIMARY KEY (id),
	CONSTRAINT facturas_usuarios_fk FOREIGN KEY (usuario_id) REFERENCES "Taller1Excepciones".usuarios(identificacion) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE OR REPLACE PROCEDURE "Taller1Excepciones".poblar()
LANGUAGE plpgsql

AS $$
BEGIN
	FOR i IN 1..50 LOOP
		INSERT INTO "Taller1Excepciones".usuarios (identificacion, nombre, edad) VALUES (i, 'Nombre ' || i, 20 + i);
	END LOOP;

	FOR i IN 1..25 LOOP
		INSERT INTO "Taller1Excepciones".facturas (producto, fecha, cantidad, id, valor_unitario, valor_total, usuario_id) VALUES ('Producto ' || i, '2024/08/20', i * 10, i, 100 * i, 100 * 20 * i, i);
	END LOOP;
END
$$;


CALL "Taller1Excepciones".POBLAR();

--------------------------TALLER 1 EXCEPCIONES :
CREATE OR REPLACE PROCEDURE "Taller1Excepciones".prueba_producto_vacio()
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO "Taller1Excepciones".facturas (producto, fecha, cantidad, id, valor_unitario, valor_total, usuario_id) VALUES ('Producto123 ', '2024/09/10', 10,  '51',1200, 102000, 10);
	INSERT INTO "Taller1Excepciones".facturas ( fecha, cantidad, id, valor_unitario, valor_total, usuario_id) VALUES ( '2024/08/10', 18,  '26',130, 125000, 11);
	EXCEPTION
		WHEN not_null_violation THEN
			RAISE NOTICE 'Falta agregar el producto en la factura este no puede ser vacio';
END
$$;

CALL "Taller1Excepciones".prueba_producto_vacio();

--------------------------TALLER 2 EXCEPCIONES :

CREATE OR REPLACE PROCEDURE "Taller1Excepciones".prueba_identificacion_unica()
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO "Taller1Excepciones".usuarios (identificacion, nombre, edad) VALUES (20, 'Majho ', 20);
	EXCEPTION
		WHEN unique_violation THEN
			RAISE NOTICE 'Ya existe un usuario con esta identificacion, se agregara el usuario con otro ID';
			INSERT INTO "Taller1Excepciones".usuarios (identificacion, nombre, edad) VALUES (68, 'Majho ', 20);
END
$$;
CALL "Taller1Excepciones".prueba_identificacion_unica();

--------------------------TALLER 3 EXCEPCIONES :

CREATE OR REPLACE PROCEDURE "Taller1Excepciones".prueba_cliente_debe_existir()
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO "Taller1Excepciones".facturas (producto, fecha, cantidad, id, valor_unitario, valor_total, usuario_id) VALUES ('Producto123 ', '2024/09/10', 10,  '51',1200, 102000, 1);
	INSERT INTO "Taller1Excepciones".facturas (producto, fecha, cantidad, id, valor_unitario, valor_total, usuario_id) VALUES ('Producto145 ', '2024/07/15', 15,  '56',1280, 10800, 100);
	EXCEPTION
		WHEN foreign_key_violation THEN
			RAISE NOTICE 'El ususario no existe';
END
$$;

CALL "Taller1Excepciones".prueba_cliente_debe_existir()