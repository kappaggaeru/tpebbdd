<?php
    require_once('model/PublicidadModel.php');
    require_once('view/PublicidadView.php');
    class PublicidadController{
        private $model;
        private $view;
        function __construct(){
            $this->model = new PublicidadModel();
            $this->view = new PublicidadView();
        }
        function home(){
            $this->view->home();
        }
        function test(){
            print_r($this->model->test());
        }
    }
?>