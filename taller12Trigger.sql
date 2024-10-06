CREATE TABLE "tallerTrigger".empleados (
	identificacion varchar NOT NULL,
	nombre varchar NULL,
	edad int NULL,
	correo varchar NULL,
	salario double precision NULL,
	CONSTRAINT empleados_pk PRIMARY KEY (identificacion)
);

CREATE TABLE "tallerTrigger".nominas (
	id varchar NOT NULL,
	fecha date NULL,
	total_ingresos double precision NULL,
	total_deducciones double precision NULL,
	total_neto double precision NULL,
	usuario_id varchar NULL,
	CONSTRAINT nominas_pk PRIMARY KEY (id),
	CONSTRAINT nominas_empleados_fk FOREIGN KEY (usuario_id) REFERENCES "tallerTrigger".empleados(identificacion) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE "tallerTrigger".detalles_nomina (
	id varchar NOT NULL,
	concepto varchar NULL,
	tipo varchar NULL,
	valor double precision NULL,
	nomina_id varchar NULL,
	CONSTRAINT detalles_nomina_pk PRIMARY KEY (id),
	CONSTRAINT detalles_nomina_nominas_fk FOREIGN KEY (nomina_id) REFERENCES "tallerTrigger".nominas(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE OR REPLACE FUNCTION validar_presupuesto_nomina()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
	v_total_neto DOUBLE PRECISION;
    v_sumatoria DOUBLE PRECISION := 0;
BEGIN
    FOR v_total_neto IN 
	SELECT total_neto
    FROM "tallerTrigger".nominas
    WHERE date_trunc('month', fecha) = date_trunc('month', NEW.fecha)
	LOOP
		v_sumatoria := v_sumatoria + v_total_neto;
	END LOOP;    

	
    IF (v_sumatoria + NEW.total_neto) > 12000000 THEN
        RAISE EXCEPTION 'El total de las nóminas del mes supera el presupuesto de $12000000';
    END IF;
    
    RETURN NEW;
END $$;


CREATE OR REPLACE TRIGGER trigger_validar_presupuesto_nomina
BEFORE INSERT ON "tallerTrigger".nominas
FOR EACH ROW
EXECUTE FUNCTION "tallerTrigger".validar_presupuesto_nomina();


INSERT INTO "tallerTrigger".empleados (identificacion, nombre, edad, correo, salario) VALUES ('123', 'Pepito', 20, 'pepito@gmail.com', 8000000);
INSERT INTO "tallerTrigger".nominas (id, fecha, total_ingresos, total_deducciones, total_neto, usuario_id) VALUES ('1', '2024/10/5', 10000000, 2000000, 8000000, '123');
INSERT INTO "tallerTrigger".nominas (id, fecha, total_ingresos, total_deducciones, total_neto, usuario_id) VALUES ('2', '2024/10/2', 7000000, 1000000, 6000000, '123');



CREATE TABLE "tallerTrigger".auditorias_nomina (
	id varchar NOT NULL,
	fecha date NULL,
	nombre varchar NULL,
	total_neto double precision NULL,
	identificacion varchar NULL,
	CONSTRAINT auditorias_nomina_pk PRIMARY KEY (id),
	CONSTRAINT auditorias_nomina_empleados_fk FOREIGN KEY (identificacion) REFERENCES "tallerTrigger".empleados(identificacion) ON DELETE CASCADE ON UPDATE CASCADE
);




CREATE OR REPLACE FUNCTION agregar_auditoria()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
	v_nombre VARCHAR;

BEGIN
	SELECT nombre INTO v_nombre FROM "tallerTrigger".empleados WHERE identificacion = NEW.usuario_id;

	INSERT INTO "tallerTrigger".auditorias_nomina (id, fecha, nombre, total_neto, identificacion) VALUES (NEW.id, NEW.fecha, v_nombre, NEW.total_neto, NEW.usuario_id);
	
	RETURN NEW;
END;
$$;


CREATE OR REPLACE TRIGGER trigger_agregar_auditoria
AFTER INSERT ON "tallerTrigger".nominas 
FOR EACH ROW 
EXECUTE FUNCTION "tallerTrigger".agregar_auditoria();


INSERT INTO "tallerTrigger".nominas (id, fecha, total_ingresos, total_deducciones, total_neto, usuario_id) VALUES ('3', '2024/10/4', 1000000, 200000, 800000, '123');

CREATE OR REPLACE FUNCTION validar_suma_salarios()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_sumatoria DOUBLE PRECISION := 0;
	v_salario DOUBLE PRECISION;

BEGIN
	FOR v_salario IN 
	SELECT salario
    FROM "tallerTrigger".empleados
    WHERE identificacion <> NEW.identificacion
	LOOP
		v_sumatoria := v_sumatoria + v_salario;
	END LOOP;  

    IF v_sumatoria + NEW.salario > 12000000 THEN
        RAISE EXCEPTION 'La suma total de los salarios supera el presupuesto de $12,000,000';
    END IF;

    RETURN NEW;
END $$;

 	

UPDATE "tallerTrigger".empleados SET salario=12000001 WHERE identificacion = '123';


CREATE TYPE conceptos AS ENUM ('AUMENTO', 'DISMINUCION');

CREATE TABLE "tallerTrigger".auditorias_empleado (
	id serial NOT NULL,
	fecha date NULL,
	nombre varchar NULL,
	identificacion varchar NULL,
	concepto conceptos NULL,
	valor double precision NULL,
	CONSTRAINT auditorias_empleado_pk PRIMARY KEY (id)
);




CREATE OR REPLACE FUNCTION agregar_auditoria_empleado()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE

BEGIN
	IF OLD.salario < NEW.salario THEN
		INSERT INTO "tallerTrigger".auditorias_empleado (fecha, nombre,identificacion,concepto,valor) VALUES (now(), NEW.nombre,NEW.identificacion, 'AUMENTO',NEW.salario - OLD.salario);
	ELSIF OLD.salario > NEW.salario THEN
		INSERT INTO "tallerTrigger".auditorias_empleado (fecha, nombre,identificacion,concepto,valor) VALUES (now(), NEW.nombre,NEW.identificacion, 'DISMINUCION',OLD.salario - NEW.salario);
	END IF;
	
	
	RETURN NEW;
END;
$$;


CREATE OR REPLACE TRIGGER trigger_agregar_auditoria_empleado
AFTER UPDATE OF salario ON "tallerTrigger".empleados
FOR EACH ROW
EXECUTE FUNCTION agregar_auditoria_empleado();




UPDATE "tallerTrigger".empleados SET salario=3000000 WHERE identificacion = '123';




