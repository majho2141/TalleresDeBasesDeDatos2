CREATE TABLE "taller6".clientes (
	nombre varchar NULL,
	identificacion varchar NOT NULL,
	email varchar NULL,
	direccion varchar NULL,
	telefono varchar NULL,
	CONSTRAINT clientes_pk PRIMARY KEY (identificacion)
);

CREATE TYPE estados_s AS ENUM ('PAGO', 'NO_PAGO', 'PENDIENTE_PAGO');


CREATE TABLE "taller6".servicios (
	codigo varchar NOT NULL,
	monto double precision NULL,
	cuota int NULL,
	intereses double precision NULL,
	valor_total double precision NULL,
	cliente_id varchar NULL,
	tipo varchar NULL,
	estado_servicio estados_s NOT NULL,
	CONSTRAINT servicios_pk PRIMARY KEY (codigo),
	CONSTRAINT servicios_clientes_fk FOREIGN KEY (cliente_id) REFERENCES "taller6".clientes(identificacion)
);

CREATE TABLE "taller6".pagos (
	codigo_transaccion varchar NOT NULL,
	fecha_pago date NULL,
	total double precision NULL,
	servicio_id varchar NULL,
	CONSTRAINT pagos_pk PRIMARY KEY (codigo_transaccion),
	CONSTRAINT pagos_servicios_fk FOREIGN KEY (servicio_id) REFERENCES "taller6".servicios(codigo)
);

----Procedimiento
CREATE OR REPLACE PROCEDURE poblar ()
LANGUAGE plpgsql
AS $$
BEGIN
	FOR i IN 1..50 LOOP
		INSERT INTO "taller6".clientes (identificacion, nombre,email,direccion,telefono) VALUES (i,'Cliente ' || i, 'cliente' || i || '@gmail.com','Calle ' || i, '310-123-244' || i);
	END LOOP;
	FOR i IN 1..50 LOOP
		FOR j IN 1..3 LOOP
			INSERT INTO "taller6".servicios (codigo,monto,cuota,intereses,valor_total,cliente_id,tipo,estado_servicio) VALUES (i::varchar || j::varchar ,i*j,j,i*j+6*j,i*j+12*j,i,'gas','PENDIENTE_PAGO');
		END LOOP; 		
	END LOOP;
	FOR i IN 1..50 LOOP
		INSERT INTO "taller6".pagos (codigo_transaccion,fecha_pago,total,servicio_id) VALUES (i,'2024/08/20',i*120,i*10+1);
	END LOOP;
END
$$;

CALL "taller6".poblar();

---Funcion

CREATE OR REPLACE FUNCTION transacciones_total_mes (mes int, identificacion varchar )
RETURNS double precision AS 
$$
DECLARE 
	v_total_pago double precision := 0;
	v_total double precision :=0;
	v_id_servicio varchar; 	
BEGIN
	FOR v_id_servicio IN SELECT codigo FROM "taller6".servicios WHERE cliente_id = identificacion
	LOOP
		FOR v_total IN SELECT total FROM "taller6".pagos WHERE EXTRACT(MONTH FROM fecha_pago) = mes AND servicio_id = v_id_servicio
			LOOP
				v_total_pago := v_total_pago + v_total;
		END LOOP;
	END LOOP;	
	RETURN v_total_pago;
END;
$$
LANGUAGE plpgsql;

SELECT "taller6".transacciones_total_mes(8,'1');

-- DROP FUNCTION taller6.no_pagados_mes(int4);

CREATE OR REPLACE FUNCTION taller6.no_pagados_mes(mes integer)
 RETURNS double precision
 LANGUAGE plpgsql
AS $function$
DECLARE 
    v_monto_total double precision := 0;
    v_monto double precision := 0;
    v_id_servicio varchar;
BEGIN
    FOR v_id_servicio IN
        SELECT codigo 
        FROM "taller6".servicios 
        WHERE estado_servicio IN ('NO_PAGO', 'PENDIENTE_PAGO')
    LOOP
        SELECT COALESCE(SUM(total), 0) INTO v_monto
        FROM "taller6".pagos
        WHERE EXTRACT(MONTH FROM fecha_pago) = mes
        AND servicio_id = v_id_servicio;

        IF v_monto = 0 THEN
            SELECT valor_total INTO v_monto
            FROM "taller6".servicios
            WHERE codigo = v_id_servicio;

            v_monto_total := v_monto_total + v_monto;
        END IF;
    END LOOP;

    RETURN v_monto_total;
END;
$function$
;

SELECT "taller6".no_pagados_mes(8);
