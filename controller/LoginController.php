<?php

require_once  "view/LoginView.php";
require_once  "model/PublicidadModel.php";
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
    $dbUser = $this->model->login($email);
    if(isset($dbUser)){
      $password = password_hash($dbUser[0]["password"],PASSWORD_DEFAULT);
          if (password_verify($pass, $password)){
              session_start();
              $_SESSION["User"] = $dbUser[0]["id_usuario"];
              header(HOME);
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
