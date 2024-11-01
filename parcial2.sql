CREATE TYPE estados_us AS ENUM ('ACTIVO', 'INACTIVO');


CREATE TABLE "pagaYa".usuarios (
	id varchar NOT NULL,
	nombre varchar NULL,
	direccion varchar NULL,
	email varchar NULL,
	fecha_registro date NULL,
	estadoU estados_us NULL,
	tarjeta_id varchar NULL,
	CONSTRAINT usuarios_pk PRIMARY KEY (id)
);

CREATE TYPE tipo_tar AS ENUM ('VISA', 'MASTERCARD');


CREATE TABLE "pagaYa".tarjetas (
	numero_tarjeta int NULL,
	id varchar NOT NULL,
	fecha_expiracion date NULL,
	cvv int NULL,
	tipo_tarjeta tipo_tar NULL,
	CONSTRAINT tarjetas_pk PRIMARY KEY (id)
);

CREATE TYPE categoriaP AS ENUM ('CELULAR', 'PC','TELEVISOR');


CREATE TABLE "pagaYa".productos (
	nombre varchar NULL,
	categoria categoriaP NULL,
	codigo_producto varchar NOT NULL,
	porcentaje_impuesto double precision NULL,
	precio double precision NULL,
	CONSTRAINT productos_pk PRIMARY KEY (codigo_producto)
);

CREATE TYPE estados_pa AS ENUM ('EXITOSO', 'FALLIDO');


CREATE TABLE "pagaYa".pagos (
	codigo_pago varchar NOT NULL,
	fecha date NULL,
	estadoP estados_pa NULL,
	monto double precision NULL,
	producto_id varchar NULL,
	tarjeta_id varchar NULL,
	usuario_id varchar NULL,
	CONSTRAINT pagos_pk PRIMARY KEY (codigo_pago)
);


CREATE TABLE "pagaYa".comprobantes_pago (
	id varchar NOT NULL,
	detalle_xml xml NULL,
	detalle_json jsonb NULL,
	CONSTRAINT comprobantes_pago_pk PRIMARY KEY (id)
);



--PARTE UNO: Funciones RETURN QUERY---------------

CREATE OR REPLACE FUNCTION "pagaYa".obtener_pagos_de_un_usuario (p_usuario_id VARCHAR, p_fecha DATE)
RETURNS TABLE (
	v_codigo_pago VARCHAR,
	v_nombre_producto VARCHAR,
	v_monto double PRECISION,
	v_estadoP estados_pa
)
AS $$
BEGIN
	RETURN QUERY
	SELECT 
	    pagos.codigo_pago,
		productos.nombre,
		pagos.monto,
		pagos.estadoP
	FROM 
	    pagos
	JOIN 
	    productos
	ON 
	    productos.codigo_producto = pagos.producto_id
	WHERE
		pagos.usuario_id = p_usuario_id
		AND pagos.fecha = p_fecha;
END;
$$ LANGUAGE plpgsql;

--Funcion Obtener Tarjetas Usuario

CREATE OR REPLACE FUNCTION "pagaYa".obtener_tarjetas_usuario (p_usuario_id VARCHAR)
RETURNS TABLE (
	v_nombre_usuario VARCHAR,
	v_email VARCHAR,
	v_numero_tarjeta int,
	v_cvv int,
	v_tipo_tarjeta tipo_tar
)
AS $$
BEGIN
	RETURN QUERY
	SELECT 
	    usuarios.nombre,
		usuarios.email,
		tarjeta.numero_tarjeta,
		tarjeta.cvv,
		tarjeta.tipo_tarjeta
	FROM 
	    usuarios
	JOIN 
	    tarjeta
	ON 
	    tarjeta.id = usuarios.tarjeta_id
	WHERE
		usuarios.id = p_usuario_id;
END;
$$ LANGUAGE plpgsql;




--PARTE DOS: CURSORES---------------

CREATE OR REPLACE FUNCTION "pagaYa".obtener_tarjetas_con_detalle_usuario(usuario_param_id varchar)
RETURNS varchar
AS $$
DECLARE
    v_cursor CURSOR FOR   SELECT tarjetas.numero_tarjeta, tarjetas.fecha_expiracion, usuarios.nombre, usuarios.email 
			FROM 								
				tarjetas 
        	JOIN 	
				usuarios 
			ON 	
				usuarios.id = tarjetas.id
       	 	WHERE 
				u.id = usuario_param_id;
    v_numero_tarjeta int;
    v_fecha_expiracion date;
    v_nombre varchar;
    v_email varchar;
    resultado varchar := '';
BEGIN
    OPEN v_cursor;
    LOOP
        FETCH v_cursor INTO v_numero_tarjeta, v_fecha_expiracion, v_nombre, v_email;
        EXIT WHEN NOT FOUND;
        resultado := resultado || 'Numero de Tarjeta: ' || v_numero_tarjeta || ', Fecha Expiracion: ' || v_fecha_expiracion || ', Nombre: ' || v_nombre || ', Email: ' || v_email || '; ';
    END LOOP;
    CLOSE v_cursor;
    RETURN resultado;
END;
$$ LANGUAGE plpgsql ;

CREATE OR REPLACE FUNCTION obtener_pagos_menores_a_1000(p_fecha date)
RETURNS varchar
AS $$
DECLARE
    v_cursor CURSOR FOR
        SELECT pagos.monto, pagos.estadoP AS estado, productos.nombre AS nombre_producto, productos.porcentaje_impuesto, usuarios.nombre AS usuario, usuarios.direccion, usuarios.email
        FROM 
			pagos 
        JOIN 	
			productos 
		ON 
			productos.codigo_producto = pagos.producto_id
        JOIN 
			usuarios ON usuarios.id = pagos.usuario_id
        WHERE 
			pagos.fecha = p_fecha AND pagos.monto < 1000;
    v_monto double precision;
    v_estado varchar;
    v_nombre_producto varchar;
    v_porcentaje_impuesto double precision;
    v_usuario varchar;
    v_direccion varchar;
    v_email varchar;
    resultado varchar := '';
BEGIN
    OPEN v_cursor;
    LOOP
        FETCH v_cursor INTO v_monto, v_estado, v_nombre_producto, v_porcentaje_impuesto, v_usuario, v_direccion, v_email;
        EXIT WHEN NOT FOUND;
        resultado := resultado || 'Monto: ' || v_monto || ', Estado: ' || v_estado || ', Producto: ' || v_nombre_producto || ', Impuesto: ' || v_porcentaje_impuesto || ', Usuario: ' || v_usuario || ', Dirección: ' || v_direccion || ', Email: ' || v_email || '; ';
    END LOOP;
    CLOSE v_cursor;
    
    IF resultado = '' THEN
        resultado := 'No se encontraron pagos menores a 1000 en la fecha indicada.';
    END IF;

    RETURN resultado;
END;
$$ LANGUAGE plpgsql ;


CREATE OR REPLACE PROCEDURE guardar_xml(p_id varchar, codigoPago varchar, nombreUsuario varchar, numeroTarjeta int, nombreProducto varchar, montoPago double precision)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO "pagaYa".comprobantes_pago (id, detalle_xml)
    VALUES (p_id, 
        XMLPARSE(CONTENT '<pago><codigoPago>' || codigoPago || '</codigoPago><nombreUsuario>' || nombreUsuario || '</nombreUsuario><numeroTarjeta>' || numeroTarjeta || '</numeroTarjeta><nombreProducto>' || nombreProducto || '</nombreProducto><montoPago>' || montoPago || '</montoPago></pago>')
    );
END;
$$;


CREATE OR REPLACE PROCEDURE guardar_json(p_id varchar, emailUsuario varchar, numeroTarjeta int, tipoTarjeta varchar, codigoProducto varchar, codigoPago varchar, montoPago double precision)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO "pagaYa".comprobantes_pago (id, detalle_json)
    VALUES (p_id, '{
   
            'emailUsuario', emailUsuario,
            'numeroTarjeta', numeroTarjeta,
            'tipoTarjeta', tipoTarjeta,
            'codigoProducto', codigoProducto,
            'codigoPago', codigoPago,
            'montoPago', montoPago
        }'
    );
END;
$$;


--Parte 3: TRIGGER
CREATE OR REPLACE TRIGGER validaciones_productos_trigger
BEFORE INSERT ON "pagaYa".productos
FOR EACH ROW
EXECUTE FUNCTION "pagaYa".validaciones_productos;

CREATE OR REPLACE TRIGGER trigger_xml
AFTER INSERT ON "pagaYa".productos
FOR EACH ROW
EXECUTE FUNCTION "pagaYa".almacenar_xml_json;


CREATE OR REPLACE FUNCTION "pagaYa".validaciones_productos()
RETURNS TRIGGER 
AS $$
BEGIN
    IF NEW.precio <= 0 OR NEW.precio >= 20000 THEN
        RAISE EXCEPTION 'El precio debe ser mayor a 0 y menor a 20000. Valor recibido: %', NEW.precio;
    END IF;

    IF NEW.porcentaje_impuesto <= 1 OR NEW.porcentaje_impuesto >= 20 THEN
        RAISE EXCEPTION 'El porcentaje de impuesto debe ser mayor a 1 y menor a 20. Valor recibido: %', NEW.porcentaje_impuesto;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION "pagaYa".almacenar_xml_json()
RETURNS TRIGGER AS $$
DECLARE
    v_id varchar := NEW.codigo_producto;
BEGIN
    INSERT INTO "pagaYa".comprobantes_pago (id, detalle_xml)
    VALUES (v_id, 
        XMLPARSE(CONTENT '<producto><codigoProducto>' || NEW.codigo_producto || '</codigoProducto><nombre>' || NEW.nombre || '</nombre><categoria>' || NEW.categoria || '</categoria><precio>' || NEW.precio || '</precio><porcentajeImpuesto>' || NEW.porcentaje_impuesto || '</porcentajeImpuesto></producto>')
    );

    INSERT INTO "pagaYa".comprobantes_pago (id, detalle_json)
    VALUES (v_id, 
        '{
            'codigoProducto', NEW.codigo_producto,
            'nombre', NEW.nombre,
            'categoria', NEW.categoria,
            'precio', NEW.precio,
            'porcentajeImpuesto', NEW.porcentaje_impuesto
        }'
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


--Parte 4: SECUENCIAS
CREATE SEQUENCE "pagaYa".codigo_producto_seq
	START WITH 5
	INCREMENT BY 5;

CREATE SEQUENCE "pagaYa".codigo_pago_seq
	START WITH 1
	INCREMENT BY 100;	


CREATE OR REPLACE FUNCTION "pagaYa".obtener_info_xml(p_id varchar)
RETURNS TABLE(nombre_producto VARCHAR, nombre_usuario VARCHAR, monto_pago DOUBLE PRECISION) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        xt.nombre_producto, 
        xt.nombre_usuario, 
        xt.monto_pago::double precision
    FROM "pagaYa".comprobantes_pago cp,
    XMLTABLE(
        '//pago' 
        PASSING cp.detalle_xml
        COLUMNS 
            nombre_producto VARCHAR PATH '//nombreProducto',
            nombre_usuario  VARCHAR PATH '//nombreUsuario',
            monto_pago      VARCHAR PATH '//montoPago'
    ) AS xt
    WHERE cp.id = p_id;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION "pagaYa".obtener_info_json(p_id varchar)
RETURNS varchar AS $$
DECLARE
    v_mail_usuario varchar;
    v_codigo_producto varchar;
    v_monto_pago double precision;
BEGIN
    
    SELECT 
        detalle_json->>'emailUsuario',
        detalle_json->>'codigoProducto',
        (detalle_json->>'montoPago')::double precision
    INTO v_mail_usuario, v_codigo_producto, v_monto_pago
    FROM "pagaYa".comprobantes_pago
    WHERE id = p_id;

    RETURN 'Email Usuario: ' || v_mail_usuario || ', Código Producto: ' || v_codigo_producto || ', Monto Pago: ' || v_monto_pago;
END;
$$ LANGUAGE plpgsql;














































