<?php
require_once('View.php');
class PublicidadView extends View{
    function __construct(){
        parent::__construct();
    }
    function home(){
        $this->smarty->display('template/home.tpl');
    }
}
?>