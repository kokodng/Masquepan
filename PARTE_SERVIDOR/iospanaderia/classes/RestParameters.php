<?php

/**
 * Clase que devuelve los elementos significativos de una
 * petición Rest.
 * 
 * Ejemplo:
 * 
 * petición POST a la url:
 * 
 * https://ruta_api/ruta/accion?nombre=valor
 * 
 * cabeceras de la petición:
 * 
 * Accept: application/json
 * Content-Type: application/json
 * etc.
 * 
 * cuerpo de la peticion:
 * 
 * {"campo": "valor", "campo2": 2}
 * 
 * Los elementos de la petición son:
 * 
 * $peticion->getAction(): 'accion'
 * $peticion->getRoute(): 'ruta'
 * $peticion->getMethod(): 'POST'
 * $peticion->getHeader('Accept'): 'application/json'
 * $peticion->getHeader(): array asociativo completo
 * $peticion->getJson('campo2'): 2
 * $peticion->getJson(): array asociativo completo
 * $peticion->getQueryString('nombre'): 'valor'
 * $peticion->getQueryString(): array asociativo completo
 * $peticion->getRouteParam(1): 'accion'
 * $peticion->getRouteParam(): array completo
 */
class RestParameters {

    /**
     * Array de cabeceras (headers) de la petición.
     * Cabeceras destacadas:
     *  Accept: Formato que se espera obtener en la respuesta (json)
     *  Content-Type: Formato en el que viene el cuerpo de la petición (json)
     *
     * @var array
     */
    private $headers;

    /**
     * Array de parámetros que llegan en el cuerpo de la petición.
     * En esta clase sólo se aceptan en formato JSON.
     *
     * @var array
     */
    private $json;

    /**
     * Nombre del método de la petición: DELETE, GET, POST, PUT.
     *
     * @var string
     */
    private $method;

    /**
     * Array de parámetros que llegan en la URL.
     * Incluye además de los parámetros propios de
     * la petición, el parámetro 'url' cuyo valor
     * es el trozo de ruta propio de la API.
     * Es lo que se denomina el querystring.
     *
     * @var array
     */
    private $querystring;

    /**
     * Array de parámetros que se obtienen de la ruta de la URL.
     *
     * @var array
     */
    private $routeParameters;

    /**
     * Inicializa las propiedades del objeto.
     * Si los datos del cuerpo de la petición no están
     * en formato json, se ignoran.
     */
    function __construct() {
        $this->headers         = getallheaders();
        $this->json            = json_decode(file_get_contents('php://input'), true);
        $this->method          = $_SERVER['REQUEST_METHOD'];
        $this->querystring     = $_GET;
        $this->routeParameters = array();
        if($this->json === null) {
            $this->json = array();
        }
        if(isset($_GET['url'])) {
            $this->routeParameters = explode('/', $_GET['url']);
        }
    }

    /**
     * Método estático privado, que devuelve el elemento de un array
     * que puede ser asociativo o de índice numérico.
     *
     * @param array $array El array del que se quiere extraer el valor.
     * 
     * @param number | string $name El nombre del índice o el valor
     * numérico del índice. Si es null, se devuelve el array completo.
     * 
     * @return value | array El valor del elemento cuyo nombre o índice
     * se pasa como parámetro o el array completo. Null, si no existe
     * el índice que se ha pasado.
     */
    private static function _getParam(array $array, $name = null) {
        if($name === null) {
            return $array;
        }
        if(!isset($array[$name])) {
            return null;
        }
        return $array[$name];
    }

    /**
     * Devuelve la 'acción' que se extrae de la ruta de la api.
     * Normalmente el primer (0) parámetro de la ruta se denomina ruta,
     * y el segundo parámetro (1) se denomina acción.
     *
     * @return string El valor de la acción, si no existe null.
     */
    function getAction() {
        return $this->getRouteParam(1);
    }

    /**
     * Devuelve el valor de la cabecera cuyo nombre se pasa.
     * Si no se pasa nombre, se devuelven todas las cabeceras.
     *
     * @param string $name El nombre del índice. Si es null, se
     * devuelve el array completo.
     * 
     * @return string | array El valor del elemento cuyo nombre
     * se pasa como parámetro o el array completo. Null, si no existe
     * el nombre de parámetro que se ha pasado.
     */
    function getHeader($name = null) {
        return self::_getParam($this->headers, $name);
    }

    /**
     * Devuelve el valor del elemento del cuerpo de la petición
     * cuyo nombre se pasa.
     * Si no se pasa nombre, se devuelven todos los datos del
     * cuerpo de la petición.
     *
     * @param string $name El nombre del índice. Si es null, se
     * devuelve el array completo.
     * 
     * @return string | array El valor del elemento cuyo nombre
     * se pasa como parámetro o el array completo. Null, si no existe
     * el nombre de parámetro que se ha pasado.
     */
    function getJson($name = null) {
        return self::_getParam($this->json, $name);
    }

    /**
     * Devuelve el método de la petición.
     *
     * @return string El valor del método.
     */
    function getMethod() {
        return $this->method;
    }

    /**
     * Devuelve el valor del elemento de los parámetros de la URL
     * de la petición cuyo nombre se pasa.
     * Si no se pasa nombre, se devuelven todos los parámetros
     * de la URL (querystring).
     *
     * @param string $name El nombre del índice. Si es null, se
     * devuelve el array completo.
     * 
     * @return string | array El valor del elemento cuyo nombre
     * se pasa como parámetro o el array completo. Null, si no existe
     * el nombre de parámetro que se ha pasado.
     */
    function getQueryString($name = null) {
        return self::_getParam($this->querystring, $name);
    }

    /**
     * Devuelve la 'ruta' que se extrae de la ruta de la api.
     * Normalmente el primer (0) parámetro de la ruta se denomina ruta,
     * y el segundo parámetro (1) se denomina acción.
     *
     * @return string El valor de la ruta, si no existe null.
     */
    function getRoute() {
        return $this->getRouteParam(0);
    }

    /**
     * Devuelve el valor del elemento de los parámetros de la ruta
     * de la API de la petición cuyo número se pasa.
     * Si no se pasa número, se devuelven todos los parámetros de la
     * ruta.
     * 
     * @param number $number El valor del índice. Si es null, se
     * devuelve el array completo.
     * 
     * @return string | array El valor del elemento cuyo nombre
     * se pasa como parámetro o el array completo. Null, si no existe
     * el nombre de parámetro que se ha pasado.
     */
    function getRouteParam($number = null) {
        return self::_getParam($this->routeParameters, $number);
    }
}