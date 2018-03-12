<?php

class Request {
    private $method;
    private $url;
    private $body;
    private $headers;
    
    
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
}