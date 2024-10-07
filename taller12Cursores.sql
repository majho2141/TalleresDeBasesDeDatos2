CREATE TYPE estado AS ENUM ('PENDIENTE', 'EN RUTA', 'ENTREGADO');

-- "tallerCursores".envios definition

CREATE TABLE "tallerCursores".envios (
	id varchar NOT NULL,
	fecha_envio date NULL,
	destino varchar NULL,
	observacion varchar NULL,
	estadoP estado NULL, 	
	CONSTRAINT envios_pk PRIMARY KEY (id)
);

CREATE OR REPLACE PROCEDURE "tallerCursores".poblar()
LANGUAGE plpgsql
AS $$
DECLARE
    i INTEGER;
    estado_arr estado[] := ARRAY['PENDIENTE', 'EN RUTA', 'ENTREGADO'];
BEGIN
    FOR i IN 1..50 LOOP
        INSERT INTO "tallerCursores".envios (id, fecha_envio, destino, observacion, estadoP)
        VALUES (
            'envio_' || i,                       
            CURRENT_DATE + (i % 10),              
            'Destino_' || i,                      
            'Observacion_' || i,                  
            estado_arr[i % 3 + 1]                 
        );
    END LOOP;
END $$;

CALL "tallerCursores".poblar();

CREATE OR REPLACE PROCEDURE "tallerCursores".primera_fase_envio()
LANGUAGE plpgsql
AS $$
DECLARE
	v_cursor CURSOR FOR SELECT id FROM "tallerCursores".envios WHERE estadoP = 'PENDIENTE';
	v_id varchar;
BEGIN
	OPEN v_cursor;
	LOOP
		FETCH v_cursor INTO v_id;
		EXIT WHEN NOT FOUND;
		UPDATE "tallerCursores".envios SET observacion='Primera etapa del envio',estadoP='EN RUTA' WHERE  id = v_id;		
	END LOOP;
	CLOSE v_cursor;
	RAISE NOTICE 'Actualización envio exitosa.';
END;
$$;

CALL "tallerCursores".primera_fase_envio();

CREATE OR REPLACE PROCEDURE "tallerCursores".ultima_fase_envio(p_fecha_actual date)
LANGUAGE plpgsql
AS $$
DECLARE
	v_cursor CURSOR FOR SELECT id, fecha_envio FROM "tallerCursores".envios WHERE estadoP = 'EN RUTA';
	v_id varchar;
	v_fecha date;
BEGIN
	OPEN v_cursor;
	LOOP
		FETCH v_cursor INTO v_id, v_fecha;
		EXIT WHEN NOT FOUND;
		IF p_fecha_actual - v_fecha > 5 THEN
			UPDATE "tallerCursores".envios SET observacion='Envio realizado satisfactoriamente',estadoP='ENTREGADO' WHERE  id = v_id;		
		END IF;
	END LOOP;
	CLOSE v_cursor;
	RAISE NOTICE 'Actualización envio exitosa.';
END;
$$;

CALL "tallerCursores".ultima_fase_envio('2024/10/15');
