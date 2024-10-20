CREATE TABLE "tallerjson".factura (
    codigo_punto_venta VARCHAR(50) PRIMARY KEY,
    descripcion JSONB
);


INSERT INTO "tallerjson".factura (codigo_punto_venta, descripcion) 
VALUES (
    'Punto de Venta 01',
    '{
        "cliente": "Nombre del cliente",
        "identificación": "123456789",
        "dirección": "Dirección del cliente",
        "código": "FAC001",
        "total_descuento": 0,
        "total_factura": 100000,
        "items": [
            {
                "cantidad": 2,
                "valor": 50000,
                "producto": {
                    "nombre": "Producto A",
                    "descripción": "Descripción del producto A",
                    "precio": 50000,
                    "categorías": ["Categoría1", "Categoría2"]
                }
            }
        ]
    }'
);

CREATE OR REPLACE PROCEDURE "tallerjson".insertar_factura( codigo_punto_venta VARCHAR(50),  descripcion JSONB)
LANGUAGE plpgsql
AS $$
BEGIN
    IF (descripcion->>'total_factura')::NUMERIC > 10000 THEN
        RAISE EXCEPTION 'El valor total de la factura no puede superar los 10.000 dólares';
    END IF;

    IF (descripcion->>'total_descuento')::NUMERIC > 50 THEN
        RAISE EXCEPTION 'El descuento máximo para una factura debe ser de 50 dólares';
    END IF;

    INSERT INTO factura (codigo_punto_venta, descripcion)
    VALUES (codigo_punto_venta, descripcion);

END;
$$ 

CALL "tallerjson".insertar_factura(
    'Punto de Venta 02',
    '{
        "cliente": "Juan Pérez",
        "identificación": "123456789",
        "dirección": "Calle 123",
        "código": "FAC002",
        "total_descuento": 30,
        "total_factura": 9500,
        "items": [
            {
                "cantidad": 1,
                "valor": 9500,
                "producto": {
                    "nombre": "Laptop",
                    "descripción": "Laptop de alta gama",
                    "precio": 9500,
                    "categorías": ["Electrónica", "Computación"]
                }
            }
        ]
    }'
);

CALL "tallerjson".insertar_factura(
    'Punto de Venta 02',
    '{
        "cliente": "Ana Gómez",
        "identificación": "987654321",
        "dirección": "Avenida Siempre Viva",
        "código": "FAC003",
        "total_descuento": 40,
        "total_factura": 10500,
        "items": [
            {
                "cantidad": 1,
                "valor": 10500,
                "producto": {
                    "nombre": "Televisor",
                    "descripción": "Televisor 4K UHD",
                    "precio": 10500,
                    "categorías": ["Electrónica", "Televisión"]
                }
            }
        ]
    }'
);

CALL "tallerjson".insertar_factura(
    'Punto de Venta 05',
    '{
        "cliente": "Carlos López",
        "identificación": "987654321",
        "dirección": "Avenida Principal 456",
        "código": "FAC005",
        "total_descuento": 15,
        "total_factura": 1200,
        "items": [
            {
                "cantidad": 1,
                "valor": 500,
                "producto": {
                    "nombre": "Laptop X",
                    "descripción": "Laptop de alta gama",
                    "precio": 500,
                    "categorías": ["Electrónica", "Computación"]
                }
            },
            {
                "cantidad": 2,
                "valor": 300,
                "producto": {
                    "nombre": "Monitor Y",
                    "descripción": "Monitor Full HD",
                    "precio": 150,
                    "categorías": ["Electrónica", "Periféricos"]
                }
            },
            {
                "cantidad": 1,
                "valor": 400,
                "producto": {
                    "nombre": "Teclado Z",
                    "descripción": "Teclado mecánico RGB",
                    "precio": 400,
                    "categorías": ["Electrónica", "Periféricos"]
                }
            }
        ]
    }'
);



CREATE OR REPLACE PROCEDURE "tallerjson".actualizar_factura(codigo_factura VARCHAR(50), nueva_descripcion JSONB)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE factura
    SET descripcion = nueva_descripcion
    WHERE descripcion->>'código' = codigo_factura;
END;
$$

CALL "tallerjson".actualizar_factura(
    'FAC002',
    '{
        "cliente": "Ana García",
        "identificación": "12345678912",
        "dirección": "Calle Falsa 123",
        "código": "FAC002",
        "total_descuento": 20,
        "total_factura": 600,
        "items": [
            {
                "cantidad": 2,
                "valor": 300,
                "producto": {
                    "nombre": "Producto B",
                    "descripción": "Descripción B",
                    "precio": 300,
                    "categorías": ["Categoría1", "Categoría3"]
                }
            }
        ]
    }'
);


CREATE OR REPLACE FUNCTION "tallerjson".obtener_nombre_cliente( identificacion_cliente VARCHAR(50))
RETURNS VARCHAR AS $$
DECLARE
    nombre_cliente VARCHAR;
BEGIN
    SELECT descripcion->>'cliente' INTO nombre_cliente FROM factura  WHERE descripcion->>'identificación' = identificacion_cliente;
    RETURN nombre_cliente;
END;
$$ LANGUAGE plpgsql;

SELECT "tallerjson".obtener_nombre_cliente('12345678912')


CREATE FUNCTION "tallerjson".obtener_facturas()
RETURNS TABLE (
    cliente TEXT, 
    identificacion TEXT, 
    codigo_factura TEXT, 
    total_descuento TEXT, 
    total_factura TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        descripcion->>'cliente' AS cliente,
        descripcion->>'identificación' AS identificacion,
        descripcion->>'código' AS codigo_factura,
        descripcion->>'total_descuento' AS total_descuento,
        descripcion->>'total_factura' AS total_factura
    FROM factura;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION "tallerjson".obtener_facturas()

SELECT  "tallerjson".obtener_facturas();

CREATE OR REPLACE FUNCTION "tallerjson".obtener_productos_por_factura(codigo_factura VARCHAR(50))
RETURNS TABLE (
    nombre_producto TEXT, 
    descripcion_producto TEXT, 
    precio_producto NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        item->'producto'->>'nombre' AS nombre_producto,
        item->'producto'->>'descripción' AS descripcion_producto,
        (item->'producto'->>'precio')::NUMERIC AS precio_producto
    FROM factura,
    jsonb_array_elements(descripcion->'items') AS item
    WHERE descripcion->>'código' = codigo_factura;
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION "tallerjson".obtener_productos_por_factura(codigo_factura VARCHAR(50))

SELECT  "tallerjson".obtener_productos_por_factura('FAC005')
