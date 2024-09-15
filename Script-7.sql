ALTER USER CLASE QUOTA UNLIMITED on USERS;

CREATE TABLE CLASE.EMPLEADOS (
	NOMBRE VARCHAR2(100) NULL,
	IDENTIFICACION VARCHAR2(100) NOT NULL,
	SALARIO NUMBER(38,0) NULL,
	CONSTRAINT EMPLEADOS_PK PRIMARY KEY (IDENTIFICACION)
);


CREATE OR REPLACE PROCEDURE aumentar_salario(
	p_identificacion IN VARCHAR,
	p_aumento IN NUMBER
)
IS
BEGIN
	UPDATE empleados
	SET salario = salario + p_aumento
	WHERE identificacion = p_identificacion;
	DBMS_OUTPUT.PUT_LINE('SE ACTUALIZÓ EL AUMENTO AL EMPLEADO');
END;

INSERT INTO CLASE.EMPLEADOS (NOMBRE, IDENTIFICACION, SALARIO) VALUES ('Martín', '123', 15000);


SELECT * FROM EMPLEADOS;

CALL aumentar_salario('123', 10000);




CREATE TABLE clientes (
	nombre varchar2(100) NULL,
	identificacion varchar2(100) NOT NULL,
	edad int NULL,
	correo varchar2(100) NOT NULL,
	CONSTRAINT clientes_pk PRIMARY KEY (identificacion)
);

CREATE TABLE productos (
	codigo varchar2(100) NOT NULL,
	nombre varchar2(100) NULL,
	stock int NULL,
	valor_unitario float NULL,
	CONSTRAINT productos_pk PRIMARY KEY (codigo)
);

CREATE TABLE CLASE.FACTURAS (
	ID VARCHAR2(100) NOT NULL,
	FECHA DATE NULL,
	CANTIDAD INTEGER NULL,
	VALOR_TOTAL FLOAT NULL,
	PRODUCTO_ID VARCHAR2(100) NULL,
	CLIENTE_ID VARCHAR2(100) NULL,
	PEDIDO_ESTADO VARCHAR2(20) NULL,
	CONSTRAINT FACTURAS_PK PRIMARY KEY (ID),
	CONSTRAINT FACTURAS_CLIENTES_FK FOREIGN KEY (CLIENTE_ID) REFERENCES CLASE.CLIENTES(IDENTIFICACION) ON DELETE CASCADE,
	CONSTRAINT FACTURAS_PRODUCTOS_FK FOREIGN KEY (PRODUCTO_ID) REFERENCES CLASE.PRODUCTOS(CODIGO) ON DELETE CASCADE
);

INSERT INTO clientes (nombre, identificacion,edad,correo) VALUES ('Majho','1056121086',20,'Majho1456@gmail.com');
INSERT INTO productos (codigo, nombre, stock, valor_unitario) VALUES ('0001', 'Camisa', 120, 32000);
INSERT INTO facturas (id, fecha, cantidad, valor_total, producto_id, cliente_id, pedido_estado) values ('1','2024/08/04', 2, 2000, '0001', '1056121086', 'PENDIENTE');

INSERT INTO CLASE.FACTURAS
(ID, FECHA, CANTIDAD, VALOR_TOTAL, PRODUCTO_ID, CLIENTE_ID, PEDIDO_ESTADO)
VALUES('2', '4-AUG-2024', 2, 2000, '0001', '1056121086', 'PENDIENTE')


CREATE OR REPLACE PROCEDURE verificar_stock(p_producto_id IN VARCHAR, p_cantidad IN INTEGER)
IS
	stock_producto int;
BEGIN 
	SELECT stock INTO stock_producto FROM productos WHERE codigo = p_producto_id;
	IF stock_producto >= p_cantidad THEN
		DBMS_OUTPUT.PUT_LINE('Si existe suficiente stock del producto ' || stock_producto);
	ELSE
		DBMS_OUTPUT.PUT_LINE('No existe suficiente stock del producto ' || stock_producto);
	END IF;
END;

CALL verificar_stock('0001', 140);
CALL verificar_stock('0001', 10);


