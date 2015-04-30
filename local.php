<?php
return array (
    'installed' =>
        array (
            'status' => 'finished',
            'action' => 'set-php-settings',
            'index' => 'mongo/rubedo',
            'contents' => 'mongo/rubedo',
        ),
    'datastream' =>
        array (
            'mongo' =>
                array (
                    'server' => 'mongo',
                    'replicaSetName' => '',
                    'port' => '27017',
                    'db' => 'rubedo',
                    'adminLogin' => '',
                    'adminPassword' => '',
                    'login' => '',
                    'password' => '',
                ),
        ),
    'elastic' =>
        array (
            'host' => 'elasticsearch',
            'port' => '9200',
            'contentIndex' => 'contents',
            'damIndex' => 'dam',
            'userIndex' => 'users',
        ),
    'view_manager' =>
        array (
            'display_exceptions' => '0',
        ),
    'zenddevelopertools' =>
        array (
            'toolbar' =>
                array (
                    'enabled' => '0',
                ),
        ),
    'logger' =>
        array (
            'errorLevel' => '400',
            'enableHandler' =>
                array (
                    'ChromePHPHandler' => '0',
                    'FirePHPHandler' => '0',
                    'MongoDBHandler' => '0',
                    'StreamHandler' => '0',
                ),
        ),
    'session' =>
        array (
            'name' => 'rubedo',
            'remember_me_seconds' => '172800',
        ),
    'rubedo_config' =>
        array (
            'minify' => '1',
            'cachePage' => '1',
            'apiCache' => '1',
            'extDebug' => '0',
            'addECommerce' => '1',
            'activateMagic' => '0',
            'defaultBackofficeHost' => 'localhost',
            'isBackofficeSSL' => '0',
            'enableEmailNotification' => '1',
            "fromEmailNotification" => "",
            'recaptcha' =>
                array (
                    'public_key' => '',
                    'private_key' => '',
                ),
        ),
);