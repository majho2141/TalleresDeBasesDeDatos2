
CREATE TYPE nombres_conceptos AS ENUM ('SALARIO', 'HORAS EXTRAS', 'PRESTACIONES', 'IMPUESTOS');

CREATE TABLE "Taller9".conceptos (
	codigo varchar NOT NULL,
	nombre nombres_conceptos NULL,
	porcentaje float4 NULL,
	CONSTRAINT conceptos_pk PRIMARY KEY (codigo)
);


CREATE TABLE "Taller9".tipos_contratos (
	descripcion varchar NULL,
	cargo varchar NULL,
	salario_total double precision NULL,
	id varchar NOT NULL,
	CONSTRAINT tipos_contratos_pk PRIMARY KEY (id)
);

CREATE TABLE "Taller9".empleados (
	nombre varchar NULL,
	identificacion varchar NOT NULL,
	tipo_contrato_id varchar NULL,
	CONSTRAINT empleados_pk PRIMARY KEY (identificacion),
	CONSTRAINT empleados_tipos_contratos_fk FOREIGN KEY (tipo_contrato_id) REFERENCES "Taller9".tipos_contratos(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE "Taller9".nominas (
	mes int NULL,
	año int NULL,
	fecha_pago date NULL,
	total_devengado double precision NULL,
	total_deducciones double precision NULL,
	total double precision NULL,
	empleado_id varchar NULL,
	id varchar NOT NULL,
	CONSTRAINT nominas_pk PRIMARY KEY (id),
	CONSTRAINT nominas_empleados_fk FOREIGN KEY (id) REFERENCES "Taller9".empleados(identificacion) ON DELETE CASCADE ON UPDATE CASCADE
);



CREATE TABLE "Taller9".detalles_nomina (
	concepto_id varchar NULL,
	valor double precision NULL,
	nomina_id varchar NULL,
	id varchar NOT NULL,
	CONSTRAINT detalles_nomina_pk PRIMARY KEY (id),
	CONSTRAINT detalles_nomina_nominas_fk FOREIGN KEY (nomina_id) REFERENCES "Taller9".nominas(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT detalles_nomina_conceptos_fk FOREIGN KEY (concepto_id) REFERENCES "Taller9".conceptos(codigo) ON DELETE CASCADE ON UPDATE CASCADE
);



CREATE OR REPLACE PROCEDURE poblar()
LANGUAGE plpgsql
AS $$
BEGIN
	FOR i IN 1..10 LOOP
		INSERT INTO "Taller9".tipos_contratos (descripcion, cargo, salario_total, id) VALUES ('Descripción ' || i, 'Cargo ' || i, i*2, i);
		INSERT INTO "Taller9".empleados (nombre, identificacion, tipo_contrato_id) VALUES ('Empleado ' || i, i, i);
	END LOOP;
	
	
	FOR i IN 1..5 LOOP
		INSERT INTO "Taller9".nominas (mes, año, fecha_pago, total_devengado, total_deducciones, total, empleado_id, id) VALUES (10, 2024, '2024/06/15', i*10000, i*2000, i*10000 + i*2000, i, i);
	END LOOP;
	
	
	FOR i IN 1..15 LOOP
		INSERT INTO "Taller9".conceptos (codigo, nombre, porcentaje) VALUES (i, 'PRESTACIONES', i*0.05);
		INSERT INTO "Taller9".detalles_nomina (concepto_id, valor, nomina_id, id) VALUES (i, i*123, '1', i);
	END LOOP;
END;
$$;


CALL "Taller9".poblar();

CREATE OR REPLACE FUNCTION obtener_nomina_empleado (p_identificacion IN VARCHAR, p_mes IN INTEGER , p_año IN INTEGER)
RETURNS TABLE (
	v_nombre varchar,
	v_total_devengado double PRECISION,
	v_total_deducciones double PRECISION,
	v_total  double PRECISION
)
AS $$
BEGIN 
	RETURN QUERY
	SELECT 
	    empleados.nombre,
	    nominas.total_devengado,
	    nominas.total_deducciones,
	   	nominas.total
	FROM 
	    nominas
	JOIN 
	    empleados
	ON 
	    empleados.identificacion = nominas.empleado_id
	WHERE
		nominas.empleado_id = p_identificacion
		AND nominas.mes = p_mes
		AND nominas.año = p_año;
END;
$$ LANGUAGE plpgsql;

SELECT obtener_nomina_empleado ('1',10,2024);


DROP FUNCTION obtener_nomina_empleado(character varying,integer,integer);


CREATE OR REPLACE FUNCTION total_por_contrato(p_tipo_contrato VARCHAR)
RETURNS TABLE (
	v_nombre VARCHAR,
	v_fecha_pago DATE,
	v_año INTEGER,
	v_mes INTEGER,
	v_total_devengado DOUBLE PRECISION,
	v_total_deducciones DOUBLE PRECISION,
	v_total DOUBLE PRECISION
)
AS $$
BEGIN
	RETURN QUERY
	SELECT 
	    e.nombre,
	    n.fecha_pago,
	    n.año,
	    n.mes,
	    n.total_devengado,
	    n.total_deducciones,
	    n.total
	FROM 
	    "Taller9".empleados e
	JOIN 
	    "Taller9".nominas n ON e.identificacion = n.empleado_id
	JOIN 
	    "Taller9".tipos_contratos tc ON e.tipo_contrato_id = tc.id
	WHERE 
	    tc.id = p_tipo_contrato;
END;
$$ LANGUAGE plpgsql;

SELECT total_por_contrato('3');



