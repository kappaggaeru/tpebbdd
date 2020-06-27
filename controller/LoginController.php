<?php

require_once  "view/LoginView.php";
require_once  "model/publicidadModel.php";
class LoginController 
{
  private $view;
  private $model;
  private $Titulo;

  function __construct()
  {
    $this->view = new LoginView();
    $this->model = new PublicidadModel();
    $this->Titulo = "Login";
  }

  function login(){
    $this->view->mostrarLogin();
  }

  function logout(){
    session_start();
    session_destroy();
    header(LOGIN);
  }

  function verificarLogin(){
    $email = $_POST["email"];
    $pass = $_POST["password"];
    echo($email);
    $dbUser = $this->model->login($email);
    if(isset($dbUser)){
          if ($pass == $dbUser[0]["password"]){
              session_start();
              $_SESSION["User"] = $dbUser[0]["id_usuario"];
              print_r($_SESSION);
          }else{
            $this->view->mostrarLogin("Contraseña incorrecta");
          }
      }else{
        //No existe el usario
        $this->view->mostrarLogin("No existe el usario");
      }

  }

}

 ?>
