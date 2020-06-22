<?php
class ConfigApp{
    public static $ACTION = 'action';
    public static $PARAMS = 'params';
    public static $ACTIONS = [
        '' => 'PublicidadController#home',
        'test' => 'PublicidadController#test'
    ];
}
?>