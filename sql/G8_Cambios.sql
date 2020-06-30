--RESTRICCIONES
--La fecha del primer comentario tiene que ser anterior a la fecha del último comentario si este no es nulo.
ALTER TABLE GR8_COMENTA
ADD CONSTRAINT GR8_CHK_FECHAS_COMENTA
CHECK((fecha_primer_com < fecha_ultimo_com) OR (fecha_ultimo_com IS NULL));
--Sentencia que activa la restricción: INSERT INTO GR8_COMENTARIO VALUES (1,1,5,'1970-04-09 04:05:06','wUENARDO');

-- Cada usuario sólo puede comentar una vez al día cada juego.
CREATE OR REPLACE FUNCTION TRFN_GR8_COMENTARIO_X_DIA() RETURNS Trigger AS $$
BEGIN
  IF(EXISTS(
    SELECT 1
    FROM GR8_COMENTARIO
    WHERE id_usuario = NEW.id_usuario AND id_juego = NEW.id_juego
    AND date(fecha_comentario) = date(NEW.fecha_comentario)
  ))
  THEN RAISE EXCEPTION 'Ya existe un comentario para este juego en este día';
  END IF;
  RETURN NEW;
END $$
LANGUAGE 'plpgsql';

CREATE TRIGGER TR_GR8_COMENTARIO_X_DIA
BEFORE INSERT OR UPDATE OF id_usuario,id_juego
ON GR8_COMENTARIO
FOR EACH ROW
EXECUTE PROCEDURE TRFN_GR8_COMENTARIO_X_DIA();
--Sentencia que activa la restricción: insert into gr8_comentario values(1,1,3,'1999-01-15','gueNARDO');

-- Un usuario no puede recomendar un juego si no ha votado previamente dicho juego.
CREATE OR REPLACE FUNCTION TRFN_GR8_JUEGO_VOTADO() RETURNS Trigger AS $$
BEGIN
  IF(NOT EXISTS(
    SELECT 1
    FROM GR8_VOTO
    WHERE id_usuario = NEW.id_usuario AND id_juego = NEW.id_juego
  ))
  THEN RAISE EXCEPTION 'Debe haber votado el juego previamente antes de recomendarlo';
  END IF;
RETURN NEW;
END $$
LANGUAGE 'plpgsql';

CREATE TRIGGER TR_GR8_JUEGO_VOTADO
BEFORE INSERT OR UPDATE OF id_usuario,id_juego
ON GR8_RECOMENDACION
FOR EACH ROW
EXECUTE PROCEDURE TRFN_GR8_JUEGO_VOTADO();
--Sentencia que activa la restricción:INSERT INTO GR8_RECOMENDACION VALUES(2,'example@org.com',1,2);

-- Un usuario no puede comentar un juego que no ha jugado.
CREATE OR REPLACE FUNCTION TRFN_GR8_COMENTAR_JUEGO_JUGADO() RETURNS Trigger AS $$
BEGIN
  IF(EXISTS(
    SELECT 1
    FROM GR8_JUEGA
    WHERE id_usuario = NEW.id_usuario AND id_juego = NEW.id_juego
    AND finalizado IS NULL
  ))
  THEN RAISE EXCEPTION 'No puede comentar un juego que no ha jugado';
  END IF;
RETURN NEW;
END $$
LANGUAGE 'plpgsql';

CREATE TRIGGER TR_GR8_COMENTAR_JUEGO_JUGADO
BEFORE INSERT OR UPDATE OF id_usuario,id_juego
ON GR8_COMENTARIO
FOR EACH ROW
EXECUTE PROCEDURE TRFN_GR8_COMENTAR_JUEGO_JUGADO();
--Sentencia que activa la restricción:INSERT INTO GR8_COMENTARIO VALUES (2,1,9,'1999-01-08 04:05:06','wUENARDO');


--Restriccion personal
-- Solo los usuarios que han jugado tendrán la opción de votar y recomendar un juego en particular.
/* CREATE OR REPLACE FUNCTION TRFN_GR8_JUEGO_JUGADO() RETURNS Trigger AS $$
BEGIN
  IF(EXISTS(
    SELECT 1
    FROM GR8_JUEGA j
    WHERE (j.id_usuario = NEW.id_usuario AND j.id_juego = NEW.id_juego)
    AND finalizado IS NULL
  ))
  THEN RAISE EXCEPTION 'Para recomendar/votar un juego primero debe haberlo jugado';
  END IF;
  RETURN NEW;
END $$
LANGUAGE 'plpgsql';

CREATE TRIGGER TR_GR8_RECOMENDACION_VALIDA
BEFORE INSERT OR UPDATE OF id_usuario,id_juego
ON GR8_RECOMENDACION
FOR EACH ROW
EXECUTE PROCEDURE TRFN_GR8_JUEGO_JUGADO();

CREATE TRIGGER TR_GR8_VOTO_VALIDO
BEFORE INSERT OR UPDATE OF id_usuario,id_juego
ON GR8_VOTO
FOR EACH ROW
EXECUTE PROCEDURE TRFN_GR8_JUEGO_JUGADO(); */
--Sentencia que activa la restricción:INSERT INTO GR8_RECOMENDACION VALUES(1,'example@org.com',1,1);
--Respuesta del DBMS:
--ERROR:  Para recomendar/votar un juego primero debe haberlo finalizado
/* Se activa la excepción porque existe un registro que coincide con los campos 
id_usuario e id_juego y que además el campo finalizado es falso, es decir que el juego no
fue terminado */

-- SERVICIOS
-- La primera vez que se inserta un comentario de un usuario para un juego se debe hacer el insert conjunto en ambas tablas, colocando la fecha del primer comentario y último comentario en en nulo.
CREATE OR REPLACE FUNCTION TRFN_GR8_INSERTAR_DOBLE() RETURNS Trigger AS $$
BEGIN
  IF(NOT EXISTS(
    SELECT 1
    FROM GR8_COMENTA
    WHERE id_juego = NEW.id_juego
  ))
  THEN
    INSERT INTO GR8_COMENTA VALUES (NEW.id_usuario,NEW.id_juego,NEW.fecha_comentario,NULL);
  END IF;
  RETURN NEW;
END $$
LANGUAGE 'plpgsql';

CREATE TRIGGER TR_GR8_INSERTAR_DOBLE
BEFORE INSERT OR UPDATE OF id_usuario,id_juego
ON GR8_COMENTARIO
FOR EACH ROW
EXECUTE PROCEDURE TRFN_GR8_INSERTAR_DOBLE();

-- Los posteriores comentarios para sólo deben modificar la fecha de último comentario e insertar en COMENTARIO
CREATE OR REPLACE FUNCTION TRFN_GR8_ACTUALIZAR_COMENTA() RETURNS Trigger AS $$
BEGIN
  IF(EXISTS(
    SELECT 1
    FROM GR8_COMENTA
    WHERE id_juego = NEW.id_juego
    ))
  THEN
    UPDATE GR8_COMENTA SET fecha_ultimo_com = NEW.fecha_comentario WHERE id_usuario = NEW.id_usuario AND id_juego = NEW.id_juego;
  END IF;
    RETURN NEW;
END $$
LANGUAGE 'plpgsql';

CREATE TRIGGER TR_GR8_ACTUALIZAR_COMENTA
BEFORE INSERT OR UPDATE OF id_usuario,id_juego
ON GR8_COMENTARIO
FOR EACH ROW
EXECUTE PROCEDURE TRFN_GR8_ACTUALIZAR_COMENTA();

--VISTAS
-- Listar Todos los comentarios realizados durante el último mes descartando aquellos juegos de la Categoría “Sin Categorías”.
CREATE VIEW GR8_COMENTARIOS_CON_CATEGORIA AS
SELECT *
FROM GR8_COMENTARIO
WHERE id_juego IN(
    SELECT id_juego
    FROM GR8_COMENTA
    WHERE id_juego IN(
        SELECT id_juego
        FROM GR8_JUEGO
        WHERE id_categoria IN(
            SELECT id_categoria
            FROM GR8_CATEGORIA
            WHERE descripcion <> 'Sin Categorías'
        )
    )
)AND (extract(year from age(now(),fecha_comentario)) * 12 +
extract(month from age(now(),fecha_comentario))) = 1;

--Identificar aquellos usuarios que han comentado todos los juegos durante el último año, teniendo en cuenta que sólo pueden comentar aquellos juegos que han jugado.
CREATE VIEW GR8_USUARIOS_COMENTAN_TODOS_LOS_JUEGOS AS
SELECT *
FROM GR8_USUARIO u
WHERE id_usuario IN(
    SELECT id_usuario
    FROM GR8_COMENTA
    WHERE
    (SELECT COUNT(DISTINCT id_juego)
    FROM GR8_COMENTARIO
    WHERE id_usuario = u.id_usuario AND
    extract(year from fecha_comentario) = (extract(year from now())-1)) =
    (SELECT COUNT(id_juego)
    FROM GR8_JUEGO)
);

--Realizar el ranking de los 20 juegos mejor puntuados por los Usuarios. El ranking debe ser generado considerando el promedio del valor puntuado por los usuarios y que el juego hubiera sido calificado más de 5 veces.
CREATE VIEW GR8_JUEGOS_RANKING_20 AS
SELECT *
FROM GR8_JUEGO j
WHERE id_juego IN(
    SELECT id_juego
    FROM GR8_JUEGA
    WHERE id_juego IN(
        SELECT id_juego
        FROM GR8_VOTO
        GROUP BY 1
        HAVING COUNT(id_juego) > 5
    )
)
ORDER BY (SELECT AVG(valor_voto)
        FROM GR8_VOTO
        WHERE id_juego = j.id_juego) DESC
LIMIT 20;