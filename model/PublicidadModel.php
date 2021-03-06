<?php
require_once('model/Model.php');
class PublicidadModel extends Model{
    private $db;
    function __construct(){
        $this->db = $this->Connect();
    }
    function test(){
        $query = $this->db->prepare("SELECT * FROM unc_249423.test");
        $query->execute();
        return $query->fetchAll(PDO::FETCH_ASSOC);
    }
    // loguearse
    function login($email){
        $sentencia = $this->db->prepare( "SELECT * from GR8_USUARIO where email = ? limit 1");
        $sentencia->execute(array($email));
        return $sentencia->fetchAll(PDO::FETCH_ASSOC);
    }
  


    // registrarse
    // function signin($apellido,$nombre,$email,$tipo,$pass){
    //     $id = getLastId() + 1;//la verdad que no se si eso funciona
    //     $query = $this->db->prepare("INSERT INTO GR8_USUARIO VALUES(?,?,?,?,?,?)");
    //     $query->execute($id,array($apellido,$nombre,$email,$tipo,$pass));
    // }
    // funcion "privada" para obtener el ultimo id
    // function getLastUsuario(){
    //     $query = $this->db->prepare("SELECT id_usuario FROM GR8_USUARIO ORDER BY 1 DESC LIMIT 1");
    //     $query->execute();
    //     return $query->fetch(PDO::FETCH_ASSOC);
    // USUARIOS
    function getUsuarios(){
        $sentencia = $this->db->prepare( "SELECT * FROM GR8_USUARIO limit 10");
        $sentencia->execute();
        return $sentencia->fetchAll(PDO::FETCH_ASSOC);
   }
    function getTopJuegos(){
        $query = $this->db->prepare("select id_juego from gr8_voto group by 1 order by count(*) desc limit 10");
        $query->execute();
        return $query->fetchAll(PDO::FETCH_ASSOC);
    }

    function getUsuariosPorBusqueda($patron){
        $query = $this->db->prepare("SELECT * FROM gr8_usuario where nombre like ?");
        $query->execute(array($patron));
        return $query->fetchAll(PDO::FETCH_ASSOC);
    }
    function getJuegosJugados($user){
        $query = $this->db->prepare("SELECT COUNT(*) FROM GR8_JUEGA WHERE id_usuario = ? AND finalizado IS NOT NULL");
        $query->execute(array($user));
        return $query->fetch(PDO::FETCH_ASSOC);
    }
    function getVotosRealizados($user){
        $query = $this->db->prepare("SELECT COUNT(*) as votos FROM GR8_VOTO WHERE id_usuario = ?");
        $query->execute(array($user));
        return $query->fetch(PDO::FETCH_ASSOC);
    }

    function getJuego($id){
        $sentencia = $this->db->prepare( "SELECT * from gr8_juego where id_juego = ?");
        $sentencia->execute(array($id));
        return $sentencia->fetch(PDO::FETCH_ASSOC);
    }
    // categoria
    function getCategorias(){
        $query = $this->db->prepare("SELECT * FROM GR8_CATEGORIA");
        $query->execute();
        return $query->fetchAll(PDO::FETCH_ASSOC);
    }
    function deleteCategoria($id){
        $query = $this->db->prepare("DELETE FROM GR8_CATEGORIA WHERE id_categoria = ?");
        $query->execute($id);
    }
    function createCategoria($id,$desc,$nivel){
        $query = $this->db->prepare("INSERT INTO GR8_CATEGORIA VALUES(?,?,?)");
        $query->execute(array($id,$desc,$nivel));
    }

    function getLastCategoria(){
        $query = $this->db->prepare("SELECT id_categoria FROM GR8_CATEGORIA ORDER BY 1 DESC LIMIT 1");
        $query->execute();
        return $query->fetch(PDO::FETCH_ASSOC);
    }
    // comentario
    function createComentario($user,$juego,$fecha,$texto){
        $id = getLastComentario() + 1;
        $query = $this->db->prepare("INSERT INTO GR8_COMENTARIO VALUES(?,?,?,?,?)");
        $query->execute(array($user,$juego),$id,array($fecha,$texto));
    }
    function getLastComentario(){
        $query = $this->db->prepare("SELECT id_comentario FROM GR8_COMENTARIO ORDER BY 1 DESC LIMIT 1");
        $query->execute();
        return $query->fetch(PDO::FETCH_ASSOC);
    }
    function getComentarios($juego){
        $query = $this->db->prepare("SELECT * FROM GR8_COMENTARIO WHERE id_juego = ? ORDER BY fecha_comenta");
        $query->execute(array($juego));
        return $query->fetchAll(PDO::FETCH_ASSOC);
    }
    // voto
    function createVoto($valor,$user,$juego){
        $id = getLastVoto()+1;
        $query = $this->db->prepare("INSERT INTO GR8_VOTO VALUES (?,?,?,?)");
        $query->execute($id,array($valor,$user,$juego));
    }
    function getLastVoto(){
        $query = $this->db->prepare("SELECT id_voto FROM GR8_VOTO ORDER BY 1 DESC LIMIT 1");
        $query->execute();
        return $query->fetch(PDO::FETCH_ASSOC);      
    }
    function getVotos($juego){
        $query = $this->db->prepare("SELECT * FROM GR8_VOTO WHERE id_juego = ?");
        $query->execute(array($juego));
        return $query->fetchAll(PDO::FETCH_ASSOC);
    }



    // recomendacion
    function createRecomendacion($juego,$user,$email){
        $id = getLastRecomendacion()+1;
        $query = $this->db->prepare("INSERT INTO GR8_RECOMENDACION VALUES (?,?,?,?");
        $query->execute($id,array($email,$user,$juego));
    }
    function getLastRecomendacion(){
        $query = $this->db->prepare("SELECT id_recomendacion FROM GR8_RECOMENDACION ORDER BY 1 DESC LIMIT 1");
        $query->execute();
        return $query->fetch(PDO::FETCH_ASSOC);
    }
    function getRecomendaciones($user){
        $query = $this->db->prepare("SELECT * FROM GR8_RECOMENDACION WHERE id_usuario = ?");
        $query->execute(array($user));
        return $query->fetchAll(PDO::FETCH_ASSOC);      
    }
}
?>