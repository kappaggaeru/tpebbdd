--Solo los usuarios que han jugado tendrán la opción de votar y recomendar un juego en particular.
--ambito general
create assertion chk_JUEGO_FINALIZADO
check not exists(
    select 1
    from GR8_RECOMENDACION r
    join GR8_JUEGA j on r.id_usuario = j.id_usuario
    join GR8_VOTO v on r.id_usuario = v.id_usuario
    where finalizado = false;
)

CREATE TRIGGER tg_JUEGO_FINALIZADO_RECOMENDACION
BEFORE INSERT OR UPDATE OF id_usuario,id_juego
ON GR8_RECOMENDACION
FOR EACH ROW
EXECUTE PROCEDURE fn_JUEGO_FINALIZADO();

CREATE TRIGGER tg_JUEGO_FINALIZADO_VOTO
BEFORE INSERT OR UPDATE OF id_usuario,id_juego
ON GR8_RECOMENDACION
FOR EACH ROW
EXECUTE PROCEDURE fn_JUEGO_FINALIZADO();

CREATE OR REPLACE FUNCTION fn_JUEGO_FINALIZADO() RETURNS Trigger AS $$
DECLARE cant integer;
BEGIN
    SELECT 1
    FROM GR8_JUEGA j
    JOIN GR8_VOTO v ON v.id_usuario,v.id_juego = j.id_usuario,j.id_juego
    JOIN GR8_RECOMENDACION r ON r.id_usuario,r.id_juego = j.id_usuario,j.id_juego
    IF (finalizado = false) THEN
      RAISE EXCEPTION 'Para votar/recomendar un juego debe haberlo finalizado', NEW.id_usuario,NEW.id_juego
    END IF;
    RETURN NEW;
END $$
LANGUAGE 'plpgsql'