<?php
require_once('View.php');
class PublicidadView extends View{
    function __construct(){
        parent::__construct();
    }
    function home($Juegos){

        $smarty = new Smarty();
        $smarty->assign('Juegos',$Juegos);
        $this->smarty->display('templates/home.tpl');
    }

    function categoria(){
        $this->smarty->display('templates/formCargarCategoria.tpl');
    }

    function mostrarUsarios($Usuarios){
        $smarty = new Smarty();
        $smarty->assign('Usuarios',$Usuarios);
        //$smarty->debugging = true;
        $smarty->display('templates/MostrarUsuarios.tpl');
    }
}
?>