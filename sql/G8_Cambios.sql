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
--Se devuelve el mensaje de la excepción ya que esta cumplió su condición de activación
--**************************

-- La fecha del primer comentario tiene que ser anterior a la fecha del último comentario si este no es nulo.


-- Cada usuario sólo puede comentar una vez al día cada juego.
-- Un usuario no puede recomendar un juego si no ha votado previamente dicho juego.
-- Un usuario no puede comentar un juego que no ha jugado.