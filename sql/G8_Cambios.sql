--La fecha del primer comentario tiene que ser anterior a la fecha del último comentario si este no es nulo.
ALTER TABLE GR8_COMENTA
ADD CONSTRAINT GR8_CHK_FECHAS_COMENTA
CHECK((fecha_primer_com < fecha_ultimo_com) OR (fecha_ultimo_com IS NULL));
--**************************
--Sentencia que activa la restricción:
--INSERT INTO GR8_COMENTARIO VALUES (1,1,5,'1970-04-09 04:05:06','wUENARDO');
--Respuesta del DBMS:
-- ERROR:new row for relation "gr8_comenta" violates check constraint "gr8_chk_fechas_comenta"
/* Se viola el constraint porque la fecha que se pretende insertar no cumple con las condiciones del check*/
--**************************

-- Cada usuario sólo puede comentar una vez al día cada juego.
CREATE OR REPLACE FUNCTION fn_COMENTARIO_X_DIA() RETURNS Trigger AS $$
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

CREATE TRIGGER tg_COMENTARIO_X_DIA
BEFORE INSERT OR UPDATE OF id_usuario,id_juego
ON GR8_COMENTARIO
FOR EACH ROW
EXECUTE PROCEDURE fn_COMENTARIO_X_DIA();
--**************************
--Sentencia que activa la restricción:
--insert into gr8_comentario values(1,1,3,'1999-01-15','gueNARDO');
--Respuesta del DBMS:
--ERROR: Ya existe un comentario para este juego en este día
/* Se activa la excepción ya que se encuentra un registro que coinciden los campos id_usuario
e id_juego dónde también coincide la fecha, es decir que este usuario ya realizó un
comentario a ese juego en ese dia */
--**************************

-- Un usuario no puede recomendar un juego si no ha votado previamente dicho juego.
CREATE OR REPLACE FUNCTION fn_JUEGO_VOTADO() RETURNS Trigger AS $$
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

CREATE TRIGGER tg_JUEGO_VOTADO
BEFORE INSERT OR UPDATE OF id_usuario,id_juego
ON GR8_RECOMENDACION
FOR EACH ROW
EXECUTE PROCEDURE fn_JUEGO_VOTADO();
--**************************
--Sentencia que activa la restricción:
--INSERT INTO GR8_RECOMENDACION VALUES(2,'example@org.com',1,2);
--Respuesta del DBMS:
--ERROR:  Debe haber votado el juego previamente antes de recomendarlo
-- Se activa la excepción ya que no existe un voto de este usuario para este juego
--**************************

-- Un usuario no puede comentar un juego que no ha jugado.
CREATE OR REPLACE FUNCTION fn_COMENTAR_JUEGO_JUGADO() RETURNS Trigger AS $$
BEGIN
  IF(NOT EXISTS(
    SELECT 1
    FROM GR8_JUEGA
    WHERE id_usuario = NEW.id_usuario AND id_juego = NEW.id_juego
  ))
  THEN RAISE EXCEPTION 'No puede comentar un juego que no ha jugado';
  END IF;
RETURN NEW;
END $$
LANGUAGE 'plpgsql';

CREATE TRIGGER tg_COMENTAR_JUEGO_JUGADO
BEFORE INSERT OR UPDATE OF id_usuario,id_juego
ON GR8_COMENTARIO
FOR EACH ROW
EXECUTE PROCEDURE fn_COMENTAR_JUEGO_JUGADO();
--**************************
--Sentencia que activa la restricción:
--INSERT INTO GR8_COMENTARIO VALUES (2,1,9,'1999-01-08 04:05:06','wUENARDO');
--Respuesta del DBMS:
--ERROR:No puede comentar un juego que no ha jugado
/* Se activa la excepción ya que no existe un registro en la tabla juega que coincida
con el id_usuario e id_juego */ 
--**************************

-- Solo los usuarios que han jugado tendrán la opción de votar y recomendar un juego en particular.
CREATE OR REPLACE FUNCTION fn_JUEGO_FINALIZADO() RETURNS Trigger AS $$
BEGIN
  IF(EXISTS(
    SELECT 1
    FROM GR8_JUEGA j
    WHERE (j.id_usuario = NEW.id_usuario AND j.id_juego = NEW.id_juego)
    AND finalizado = false
  ))
  THEN RAISE EXCEPTION 'Para recomendar/votar un juego primero debe haberlo finalizado';
  END IF;
  RETURN NEW;
END $$
LANGUAGE 'plpgsql';

CREATE TRIGGER tg_RECOMENDACION_VALIDA
BEFORE INSERT OR UPDATE OF id_usuario,id_juego
ON GR8_RECOMENDACION
FOR EACH ROW
EXECUTE PROCEDURE fn_JUEGO_FINALIZADO();

CREATE TRIGGER tg_VOTO_VALIDO
BEFORE INSERT OR UPDATE OF id_usuario,id_juego
ON GR8_VOTO
FOR EACH ROW
EXECUTE PROCEDURE fn_JUEGO_FINALIZADO();
--**************************
--Sentencia que activa la restricción:
--INSERT INTO GR8_RECOMENDACION VALUES(1,'example@org.com',1,1);
--Respuesta del DBMS:
--ERROR:  Para recomendar/votar un juego primero debe haberlo finalizado
/* Se activa la excepción porque existe un registro que coincide con los campos 
id_usuario e id_juego y que además el campo finalizado es falso, es decir que el juego no
fue terminado */
--**************************

-- SERVICIOS
-- La primera vez que se inserta un comentario de un usuario para un juego se debe hacer el insert conjunto en ambas tablas, colocando la fecha del primer comentario y último comentario en en nulo.
CREATE OR REPLACE FUNCTION fn_INSERTAR_DOBLE() RETURNS Trigger AS $$
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

CREATE TRIGGER tg_INSERTAR_DOBLE
BEFORE INSERT OR UPDATE OF id_usuario,id_juego
ON GR8_COMENTARIO
FOR EACH ROW
EXECUTE PROCEDURE fn_INSERTAR_DOBLE();

-- Los posteriores comentarios para sólo deben modificar la fecha de último comentario e insertar en COMENTARIO
CREATE OR REPLACE FUNCTION fn_ACTUALIZAR_COMENTA() RETURNS Trigger AS $$
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

CREATE TRIGGER tg_ACTUALIZAR_COMENTA
BEFORE INSERT OR UPDATE OF id_usuario,id_juego
ON GR8_COMENTARIO
FOR EACH ROW
EXECUTE PROCEDURE fn_ACTUALIZAR_COMENTA();