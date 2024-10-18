 CREATE TABLE "tallerxml".libros (
    isbn VARCHAR(13) PRIMARY KEY,
    descripcion XML
);

CREATE OR REPLACE PROCEDURE "tallerxml".guardar_libro(p_isbn VARCHAR, p_titulo VARCHAR,  p_autor VARCHAR, p_anio VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM libros WHERE isbn = p_isbn OR descripcion::TEXT LIKE '%' || p_titulo || '%') THEN
        INSERT INTO libros (isbn, descripcion) VALUES (p_isbn, XMLPARSE(CONTENT '<libro><titulo>' || p_titulo || '</titulo><autor>' || p_autor || '</autor><anio>'|| p_anio ||'</anio></libro>'));
    ELSE
        RAISE NOTICE 'El ISBN o el título del libro ya existe en la tabla.';
    END IF;
END;
$$;

CALL "tallerxml".guardar_libro('123','100 Anios de soledad','Gabriel Garcia Marquez','1978')
CALL "tallerxml".guardar_libro('456','La odisea','Dante A','1500')
CALL "tallerxml".guardar_libro('789','El coronel no tiene quien le escriba','Gabriel Garcia Marquez','1500')

CREATE OR REPLACE PROCEDURE "tallerxml".actualizar_libro(p_isbn VARCHAR, p_titulo VARCHAR,  p_autor VARCHAR, p_anio VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE libros SET descripcion = XMLPARSE(CONTENT '<libro><titulo>' || p_titulo || '</titulo><autor>' || p_autor || '</autor><anio>'|| p_anio ||'</anio></libro>')  WHERE isbn = p_isbn;
END;
$$ 

CALL "tallerxml".actualizar_libro('123','1000 Anios de soledad','Gabriel Garcia Marquez','1978')


CREATE OR REPLACE FUNCTION "tallerxml".obtener_autor_libro_por_isbn(p_isbn VARCHAR)
RETURNS TEXT AS $$
DECLARE
    autor TEXT;
BEGIN
    SELECT xpath('//autor/text()', descripcion) INTO autor FROM libros WHERE isbn = p_isbn;
    RETURN autor;
END;
$$ LANGUAGE plpgsql;

SELECT  "tallerxml".obtener_autor_libro_por_isbn('123')

CREATE OR REPLACE FUNCTION "tallerxml".obtener_autor_libro_por_titulo(p_titulo VARCHAR)
RETURNS TEXT AS $$
DECLARE
    autor TEXT;
BEGIN
    SELECT xpath('//autor/text()', descripcion) INTO autor FROM libros  WHERE descripcion::TEXT LIKE '%' || p_titulo || '%';
    RETURN autor;
END;
$$ LANGUAGE plpgsql;

SELECT  "tallerxml".obtener_autor_libro_por_titulo('1000 Anios de soledad')

CREATE OR REPLACE FUNCTION "tallerxml".obtener_libros_por_anio(p_anio VARCHAR)
RETURNS TABLE(isbn VARCHAR, titulo VARCHAR, autor VARCHAR, anio VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT l.isbn AS isbn, xt.titulo AS titulo, xt.autor AS autor, xt.anio AS anio
    FROM libros l,
    XMLTABLE(
        '//libro' 
        PASSING l.descripcion
        COLUMNS 
            titulo VARCHAR PATH '//titulo',
            autor  VARCHAR PATH '//autor',
            anio   VARCHAR PATH '//anio'
    ) AS xt
    WHERE xt.anio = p_anio;
END;
$$ LANGUAGE plpgsql;

SELECT  "tallerxml".obtener_libros_por_anio('1500')

