<?php
require'./classes/Autoload.php';
date_default_timezone_set('Europe/Madrid');

//durante el desarrollo
error_reporting(E_ALL);
ini_set('display_errors', 1);

//paso 1: obtener todos los datos de la petición (request)
$rest = new RestParameters();

//1º method
$method = $rest -> getMethod();

//2º urlParam
$urlParams ='';
if(isset($_GET['url'])) {
    $urlParams = $rest -> getRouteParam();
}

//3º body
$bodyJsonArray = $rest -> getJson();

//4º headers
$headers = $rest -> getHeader();
if(isset($headers['authorization'])) {
    $authorization = $headers['authorization'];
}
/*
    Paso 2: realizar la authorization
*/
require 'classes/vendor/autoload.php';
use \Firebase\JWT\JWT; //import de java
$key = 'dam';
$tiempoDeVida = 600;
$ok = false;
require_once 'connection.php';
$connection = mysqli_connect($db_hostname, $db_username, $db_password, $db_database);
$connection->set_charset('utf8');

if(isset($authorization)) {
    $authParts = explode(' ', $authorization); //nombre valor (nombre: Basic, Bearer, Digest, AWS)
    $auth = new Authorization($authParts);
    $dbMan = new DBManager($connection);
    if($auth -> lengthIsCorrect()) {
        if($auth -> isBasic()) {
            $auth -> credentialsBasicDecode();
            if($auth -> credLengthCorrect()) {
                $idMember = $dbMan -> getIdMember($auth -> getLogin(), $auth -> getPassword());
                if($idMember !== null) {
                    $hora = new DateTime();
                    $contenidoToken = array(
                        'hora'    => $hora->getTimestamp() + $tiempoDeVida,
                        'id' => $idMember
                    );
                    $tokenJwt = JWT::encode($contenidoToken, $key);
                    $ok = true;
                }
            }
        } else  if ($auth -> isBearer()) {
            try {
                $decodedToken = JWT::decode($auth -> getToken(), $key, array('HS256'));
                $hora = new DateTime();
                if($hora->getTimestamp() < $decodedToken->hora) {
                    $contenidoToken = array(
                        'hora'    => $hora->getTimestamp() + $tiempoDeVida,
                        'id' => $decodedToken->id
                    );
                    $tokenJwt = JWT::encode($contenidoToken, $key);
                    $ok = true;
                }
            } catch (Exception $e) {
            }
        }
    }
}

if($ok) {
    if($method === 'GET' && isset($urlParams[0])) {
        switch($urlParams[0]){
            case 'login':
                $respuesta = array('ok' => 1, 'token' => $tokenJwt, 'idmember' => $idMember);
                break;
            case 'products':
                if(isset($urlParams[1])){
                     $respuesta['product'] = $dbMan -> getProductById($urlParams[1]);
                } else {
                     $respuesta['products'] = $dbMan -> getAllProducts();
                }
                break;
            case 'tickets':
                $respuesta['tickets'] = $dbMan -> getAllTickets();
                break;
            case 'ticketsdetails':
                if(isset($urlParams[1])){
                    $respuesta['ticketsdetails'] = $dbMan -> getTicketDetailsById($urlParams[1]);
                } else {
                    $respuesta['ticketsdetails'] = $dbMan -> getAllTicketsDetails();   
                }
                break;
                
            case 'families':
                if(isset($urlParams[1])){
                    $respuesta['familie'] = $dbMan -> getFamilyById($urlParams[1]);
                } else {
                    $respuesta['families'] = $dbMan -> getAllFamilies();   
                }
                break;
            case 'members':
                $respuesta['members'] = $dbMan -> getAllMembers();   
                break;
                
            default:
                break;
        }
    }else if($method === 'POST' && isset($urlParams[0])) {
        switch($urlParams[0]){
            case 'tickets':
                $saved = $dbMan -> saveTicket($bodyJsonArray);
                $saved? $respuesta = array('ok' => 1, 'token' => $tokenJwt, 'idmember' => ""):
                        $respuesta = array('ok' => 0, 'token' => $tokenJwt, 'idmember' => "");
                break;
            case 'ticketdetails':
                $saved = $dbMan -> saveTicketDetails($bodyJsonArray);
                $saved? $respuesta = array('ok' => 1, 'token' => $tokenJwt, 'idmember' => ""):
                        $respuesta = array('ok' => 0, 'token' => $tokenJwt, 'idmember' => "");
                break;
            default:
                break;
        }
    }
} else {
    $respuesta = array('ok' => 0);
}
echo json_encode($respuesta);