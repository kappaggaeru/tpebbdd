<?php
class ConfigApp{
    public static $ACTION = 'action';
    public static $PARAMS = 'params';
    public static $ACTIONS = [
        '' => 'LoginController#login',
        'cargarCategoria'=>'PublicidadController#InsertCategoria',
        'verificarLogin'=>'LoginController#verificarLogin',
        'logout'=> 'LoginController#logout',
        'usuarios'=> 'PublicidadController#mostrarUsuarios',
        'home' => 'PublicidadController#home',
        'cargar' => 'PublicidadController#mostrarCategoria',
        'test' => 'PublicidadController#test'
    ];
}
?>