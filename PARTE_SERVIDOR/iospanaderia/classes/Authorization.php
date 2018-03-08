<?php
class Authorization {
    private $authParts;   // Array con las partes de la autorización
    private $credentials; // Array username y password

    function __construct($parts = array()) {
        $this -> authParts = $parts;
        $this -> credentials = array();
    }

    function lengthIsCorrect(){
        return count($this -> authParts) === 2;
    }

    function isBasic(){
        return $this -> authParts[0] === 'Basic';
    }

    function isBearer(){
        return $this -> authParts[0] === 'Bearer';
    }

    function credentialsBasicDecode(){
        $cred = base64_decode($this -> authParts[1]);
        $cred = explode(':', $cred);
        if (count($cred) === 2){
            $this -> credentials = $cred;
        }
    }
    
    function credLengthCorrect(){
        return count($this -> credentials) == 2;
    }
    
    function getLogin(){
        return $this -> credentials[0];
    }
    
    function getPassword(){
        return $this -> credentials[1];
    }
    
    function getToken(){
        return $this -> authParts[1];
    }

}