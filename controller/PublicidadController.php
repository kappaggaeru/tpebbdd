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
            $id_juegos = $this->model->getTopJuegos();
            $juegos= array();     
            for ($i = 0; $i < 10; $i++){
                $juegos[$i]=$this->model->getJuego($id_juegos[$i]["id_juego"]);
            }
            $this->view->home($juegos);
        }

        function mostrarCategoria(){
            $this->view->categoria();
        }
        function test(){
            print_r($this->model->test());
        }

        function mostrarUsuarios(){
            $criterio = $_POST["buscador"];
            $Usuarios = $this->model->getUsuariosPorBusqueda($criterio);
            for ($i = 0; $i < count($Usuarios); $i++){
               array_push($Usuarios[$i],$this->model->getVotosRealizados($Usuarios[$i]["id_usuario"]));
               array_push($Usuarios[$i],$this->model->getJuegosJugados($Usuarios[$i]["id_usuario"]));
            }
            $this->view->mostrarUsarios($Usuarios);
        }

        function mostrar10Usuarios(){
            $Usuarios = $this->model->getUsuarios();
            for ($i = 0; $i < count($Usuarios); $i++){
               array_push($Usuarios[$i],$this->model->getVotosRealizados($Usuarios[$i]["id_usuario"]));
               array_push($Usuarios[$i],$this->model->getJuegosJugados($Usuarios[$i]["id_usuario"]));
            }
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