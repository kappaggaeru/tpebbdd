<?php
    require_once('model/PublicidadModel.php');
    require_once('view/PublicidadView.php');
    require_once('SecuredController.php');
   

    class PublicidadController extends SecuredController{
        private $model;
        private $view;
        function __construct(){
            $this->model = new PublicidadModel();
            $this->view = new PublicidadView();
        }
        function home(){
            $juegos = $this->model->getUsuarios();
            $this->view->home($juegos);
        }

        function mostrarCategoria(){
            $this->view->categoria();
        }
        function test(){
            print_r($this->model->test());
        }

        function mostrarUsuarios(){
            $Usuarios = $this->model->getUsuarios();
            $this->view->mostrarUsarios($Usuarios);
        }

        function InsertCategoria(){
            $desc = $_POST["descripcion"];
            $nivel = $_POST["nivel"];
            $id =  $this->model->getLastCategoria();
            $this->model->createCategoria($id["id_categoria"]+1,$desc,$nivel);
            header(HOME);
          }
    }
?>