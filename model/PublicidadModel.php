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
}
?>