CREATE TABLE "Taller5".clientes (
	nombre varchar NULL,
	identificacion varchar NOT NULL,
	edad int NULL,
	correo varchar NOT NULL,
	CONSTRAINT clientes_pk PRIMARY KEY (identificacion)
);

CREATE TABLE "Taller5".productos (
	codigo varchar NOT NULL,
	nombre varchar NULL,
	stock int NULL,
	valor_unitario float8 NULL,
	CONSTRAINT productos_pk PRIMARY KEY (codigo)
);

CREATE TYPE estados_p AS ENUM ('PENDIENTE', 'ENTREGADO', 'BLOQUEADO');

CREATE TABLE "Taller5".facturas (
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
	CONSTRAINT pedidos_clientes_fk FOREIGN KEY (cliente_id) REFERENCES "Taller5".clientes(identificacion) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT pedidos_productos_fk FOREIGN KEY (producto_id) REFERENCES "Taller5".productos(codigo) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO "Taller5".clientes (nombre, identificacion,edad,correo) VALUES ('Majho','1056121086',20,'Majho1456@gmail.com');
INSERT INTO "Taller5".productos (codigo, nombre, stock, valor_unitario) VALUES ('0001', 'Camisa', 120, 32000);
INSERT INTO "Taller5".productos (codigo, nombre, stock, valor_unitario) VALUES ('0002', 'Pantalon', 30, 10000);
INSERT INTO "Taller5".facturas (id, fecha, cantidad, valor_total, producto_id, cliente_id, pedido_estado) values ('1','2024/08/04', 2, 2000, '0001', '1056121086', 'PENDIENTE');

-----------------------------PARTE 1----------------------------------------------------

CREATE OR REPLACE PROCEDURE calcular_stock_actual()
LANGUAGE plpgsql
AS $$
DECLARE
	v_total_stock INTEGER :=0;
	v_nombre_producto VARCHAR;
	v_stock_actual INTEGER;
BEGIN 
	FOR v_nombre_producto, v_stock_Actual IN SELECT nombre ,stock FROM "Taller5".productos
	LOOP
		RAISE NOTICE 'El nombre del proucto es : %',v_nombre_producto;
		RAISE NOTICE 'El stock actual del producto es de: %',v_stock_actual;
		v_total_stock := v_total_stock + v_stock_actual;
	END LOOP;
	RAISE NOTICE  'El stock total es de : %',v_total_stock;	
END
$$;

CALL "Taller5".calcular_stock_actual();

