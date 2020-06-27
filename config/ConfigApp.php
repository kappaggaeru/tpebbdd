<?php
class ConfigApp{
    public static $ACTION = 'action';
    public static $PARAMS = 'params';
    public static $ACTIONS = [
        '' => 'LoginController#login',
        'verificarLogin'=>'LoginController#verificarLogin',
        'home' => 'PublicidadController#home',
        'test' => 'PublicidadController#test'
    ];
}
?>