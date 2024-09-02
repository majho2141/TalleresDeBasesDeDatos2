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
	CONSTRAINT pedidos_clientes_fk FOREIGN KEY (cliente_id) REFERENCES "Taller5".clientes(identificacion) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT pedidos_productos_fk FOREIGN KEY (producto_id) REFERENCES "Taller5".productos(codigo) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE "Taller5".auditorias (
	fecha_inicio date NULL,
	fecha_final date NULL,
	factura_id varchar NULL,
	pedido_estado "Taller5"."estados_p" NULL,
	id serial NOT NULL,
	CONSTRAINT auditorias_pk PRIMARY KEY (id),
	CONSTRAINT auditorias_facturas_fk FOREIGN KEY (factura_id) REFERENCES "Taller5".facturas(id) ON DELETE CASCADE ON UPDATE CASCADE
);


INSERT INTO "Taller5".clientes (nombre, identificacion,edad,correo) VALUES ('Majho','1056121086',20,'Majho1456@gmail.com');
INSERT INTO "Taller5".productos (codigo, nombre, stock, valor_unitario) VALUES ('0001', 'Camisa', 120, 32000);
INSERT INTO "Taller5".productos (codigo, nombre, stock, valor_unitario) VALUES ('0002', 'Pantalon', 30, 10000);
INSERT INTO "Taller5".facturas (id, fecha, cantidad, valor_total, producto_id, cliente_id, pedido_estado) values ('1','2024/08/04', 2, 2000, '0001', '1056121086', 'PENDIENTE');
INSERT INTO "Taller5".facturas (id, fecha, cantidad, valor_total, producto_id, cliente_id, pedido_estado) values ('2','2024/06/10', 3, 300, '0002', '1056121086', 'PENDIENTE');
INSERT INTO "Taller5".facturas (id, fecha, cantidad, valor_total, producto_id, cliente_id, pedido_estado) values ('3','2024/07/12', 3, 300, '0002', '1056121086', 'PENDIENTE');
-----------------------------PARTE 1 FOR----------------------------------------------------

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


-----------------------PARTE2- FOR Y IF------------------------------
CREATE OR REPLACE PROCEDURE generar_auditoria(p_fecha_inicio DATE, p_fecha_final DATE)
LANGUAGE plpgsql
AS $$
DECLARE 
	v_factura_id VARCHAR;
	v_pedido_estado estados_p;
	v_fecha_factura DATE;
BEGIN
	FOR v_factura_id,v_pedido_estado, v_fecha_factura IN SELECT id , pedido_estado,fecha FROM "Taller5".facturas
	LOOP
		IF v_fecha_factura BETWEEN p_fecha_inicio AND p_fecha_final THEN 
			INSERT INTO "Taller5".auditorias (fecha_inicio, fecha_final, factura_id, pedido_estado) VALUES(p_fecha_inicio, p_fecha_final, v_factura_id, v_pedido_estado);
			RAISE NOTICE 'Se agrego la auditoria de forma exitosa %',v_factura_id;
		END IF;
	END LOOP;
	
END
$$;

CALL "Taller5".generar_auditoria('2024/08/01','2024/08/31');
CALL "Taller5".generar_auditoria('2024/07/01','2024/08/31');

---------------------------------PARTE 3 FOR Y WHILE-------------------------------------
CREATE OR REPLACE PROCEDURE simular_ventas_mes()
LANGUAGE plpgsql
AS $$
DECLARE 
	v_dia INTEGER := 1;
	v_identificacion VARCHAR;
	v_random INTEGER;
	v_random_id_factura VARCHAR;
BEGIN
	WHILE v_dia<=30 LOOP
		v_dia := v_dia + 1;
		FOR v_identificacion IN SELECT identificacion FROM "Taller5".clientes
		LOOP
			SELECT FLOOR(random()* (99999 -10000+1)+10000)::int  INTO v_random;
			SELECT FLOOR(random()* (1000 -10+ 1)+10)::varchar  INTO v_random_id_factura;
			RAISE NOTICE 'Cantidad %',v_random;
			RAISE NOTICE 'Id %',v_random_id_factura;
			INSERT INTO "Taller5".facturas (id, fecha, cantidad, valor_total, producto_id, cliente_id, pedido_estado) VALUES(v_random_id_factura, '2024/09/02', v_random, 240000, '0002', v_identificacion, 'PENDIENTE');
		END LOOP;
	END LOOP;
END
$$;

CALL "Taller5".simular_ventas_mes();
