<?php
require_once('View.php');
class PublicidadView extends View{
    function __construct(){
        parent::__construct();
    }
    function home($juegos){
        // $smarty = new Smarty();
        // $this->smarty->assign('posiciones',$posiciones);
        // $this->smarty->display('templates/posiciones.tpl');
        $this->smarty->assign('juegos',$juegos);
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