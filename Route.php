<?php
define('HOME', 'Location: http://'.$_SERVER["SERVER_NAME"].":".$_SERVER['SERVER_PORT'].dirname($_SERVER["PHP_SELF"]). '/home');
define('ROOT', dirname($_SERVER["PHP_SELF"]));
define('LOGIN', 'Location: http://'.$_SERVER["SERVER_NAME"].":".$_SERVER['SERVER_PORT'].dirname($_SERVER["PHP_SELF"]).'/');


require_once('config/ConfigApp.php');
require_once('controller/PublicidadController.php');
require_once('controller/LoginController.php');
function parseURL($url){
    // explode() crea un string en un array, quita lo que haya en el parametro
    $urlExploded = explode('/',$url);
    $arrayReturn[ConfigApp::$ACTION] = $urlExploded[0];
    // parte el array en la posicion que le das por parametro
    $arrayReturn[ConfigApp::$PARAMS] = isset($urlExploded[1])?array_slice($urlExploded,1):null;
    return $arrayReturn;
}
if(isset($_GET['action'])){
    $urlData = parseURL($_GET['action']);
    $action = $urlData[ConfigApp::$ACTION];
    if(array_key_exists($action,ConfigApp::$ACTIONS)){
        $params = $urlData[ConfigApp::$PARAMS];
        $action = explode('#',ConfigApp::$ACTIONS[$action]);
        //Array[0] -> TareasController [1] -> BorrarTarea
        $controller =  new $action[0]();
        $metodo = $action[1];
        if(isset($params) &&  $params != null){
            echo $controller->$metodo($params);
        }else{
            echo $controller->$metodo();
        }
    }
}
?>