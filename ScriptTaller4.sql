CREATE TABLE "Taller3".clientes (
	nombre varchar NULL,
	identificacion varchar NOT NULL,
	edad int NULL,
	correo varchar NOT NULL,
	CONSTRAINT clientes_pk PRIMARY KEY (identificacion)
);

CREATE TABLE "Taller3".productos (
	codigo varchar NOT NULL,
	nombre varchar NULL,
	stock int NULL,
	valor_unitario float8 NULL,
	CONSTRAINT productos_pk PRIMARY KEY (codigo)
);

CREATE TYPE estados_p AS ENUM ('PENDIENTE', 'ENTREGADO', 'BLOQUEADO');

CREATE TABLE "Taller3".facturas (
	id VARCHAR NOT NULL,
	fecha date NULL,
	cantidad int NULL,
	valor_total float8 NULL,
	producto_id varchar NOT NULL,
	cliente_id varchar NOT NULL,
	pedido_estado estados_p NULL,
	CONSTRAINT pedidos_pk PRIMARY KEY (id),
	CONSTRAINT pedidos_unique UNIQUE (producto_id),
	CONSTRAINT pedidos_unique_1 UNIQUE (cliente_id),
	CONSTRAINT pedidos_clientes_fk FOREIGN KEY (cliente_id) REFERENCES "Taller3".clientes(identificacion) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT pedidos_productos_fk FOREIGN KEY (producto_id) REFERENCES "Taller3".productos(codigo) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO "Taller3".clientes (nombre, identificacion,edad,correo) VALUES ('Majho','1056121086',20,'Majho1456@gmail.com');
INSERT INTO "Taller3".productos (codigo, nombre, stock, valor_unitario) VALUES ('0001', 'Camisa', 120, 32000);
INSERT INTO "Taller3".facturas (id, fecha, cantidad, valor_total, producto_id, cliente_id, pedido_estado) values ('1','2024/08/04', 2, 2000, '0001', '1056121086', 'PENDIENTE');



CREATE OR REPLACE PROCEDURE verificar_stock(p_producto_id VARCHAR, p_cantidad INTEGER)
LANGUAGE plpgsql
AS $$
DECLARE
	stock_producto int;
BEGIN 
	SELECT stock INTO stock_producto FROM "Taller3".productos WHERE codigo = p_producto_id;
	IF stock_producto >= p_cantidad THEN
		RAISE NOTICE 'Si existe suficiente stock del producto %', stock_producto;
	ELSE
		RAISE NOTICE 'No existe suficiente stock del producto %', stock_producto;
	END IF;
END;
$$;

CALL "Taller3".verificar_stock('0001', 140);
CALL "Taller3".verificar_stock('0001', 10);


CREATE OR REPLACE PROCEDURE actualizar_estado_pedido(p_factura_id VARCHAR, p_nuevo_estado estados_p)
LANGUAGE plpgsql
AS $$
DECLARE
	estado_producto estados_p;
	
BEGIN
	SELECT pedido_estado INTO estado_producto FROM "Taller3".facturas WHERE id = p_factura_id;
	
	IF estado_producto = 'ENTREGADO' THEN
		RAISE NOTICE 'El pedido ya fue entregado';
	ELSE
		UPDATE "Taller3".facturas SET pedido_estado = p_nuevo_estado WHERE id = p_factura_id;
		RAISE NOTICE 'El estado fue cambiado a %', p_nuevo_estado;  
	END IF;
END;
$$;


CALL "Taller3".actualizar_estado_pedido('1', 'PENDIENTE');