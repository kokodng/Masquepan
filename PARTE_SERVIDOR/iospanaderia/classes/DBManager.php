<?php
class DBManager {
    
    private $dbcon;
    
    function __construct($dbconnection) {
        $this->dbcon = $dbconnection;
    }
    
    public function getAllProducts() {
        $sql = "select * from product";
        $products = array();
        $result_set = mysqli_query($this->dbcon, $sql);        
        if(mysqli_num_rows($result_set)>0){
            
            while($row = mysqli_fetch_array($result_set)){
                $products[] = array('id' => $row['id'], 'idfamily' => utf8_encode($row['idfamily']),
                'product' => utf8_encode($row['product']), 'price' => $row['price'],
                'description' => utf8_encode($row['description']));
            }          
        }
        return $products;
    }
    
    public function getProductById($id){
        $sql = "select * from product where id = $id";
        $product = array();
        $result_set = mysqli_query($this->dbcon, $sql);        
        if(mysqli_num_rows($result_set)>0){
            while($row = mysqli_fetch_array($result_set)){
                $product = array('id' => $row['id'], 'idfamily' => utf8_encode($row['idfamily']),
                'product' => utf8_encode($row['product']), 'price' => $row['price'],
                'description' => utf8_encode($row['description']));
            }          
        }
        return $product;
    }
    
    public function getIdMember($login, $password) {
        $sql = "select * from member where login = '".$login. "' and password = '".$password."'";
        $result_set = mysqli_query($this->dbcon, $sql);        
        if(mysqli_num_rows($result_set)>0){
            while($row = mysqli_fetch_array($result_set)){
                $idMember = $row['id'];
            }               
        } else {
            $idMember = null;
        }
        return $idMember;
    }
    
    public function getAllMembers() {
        $sql = "select * from member";
        $members = array();
        $result_set = mysqli_query($this->dbcon, $sql);        
        if(mysqli_num_rows($result_set)>0){
            while($row = mysqli_fetch_array($result_set)){
                $members[] = array('id' => $row['id'], 'login' => $row['login']);
            }               
        }
        return $members;
    }
    
    public function getAllTickets() {
        $sql = "select * from ticket";
        $tickets = array();
        $result_set = mysqli_query($this->dbcon, $sql);        
        if(mysqli_num_rows($result_set)>0){
            
            while($row = mysqli_fetch_array($result_set)){
                $tickets[] = array( 'id' => $row['id'],"idmember" => $row["idmember"],
                "date" => $row["date"]);
            }          
        }
        return $tickets;
    }
    
    public function getAllTicketsDetails() {
        $sql = "select * from ticketdetail";
        $ticketdetails = array();
        $result_set = mysqli_query($this->dbcon, $sql);        
        if(mysqli_num_rows($result_set)>0){
            while($row = mysqli_fetch_array($result_set)){
                $ticketdetails[] = array( 'id' => $row['id'],"idticket" => $row["idticket"],
                "idproduct" => $row["idproduct"],"quantity" => $row["quantity"],
                "price" => $row["price"]);
            }          
        }
        return $ticketdetails;
    }
    
    
    public function getTicketDetailsById($idticket) {
        $sql = "select * from ticketdetail where idticket = $idticket";
        $ticketdetails = array();
        $result_set = mysqli_query($this->dbcon, $sql);        
        if(mysqli_num_rows($result_set)>0){
            while($row = mysqli_fetch_array($result_set)){
                $ticketdetails[] = array( 'id' => $row['id'],"idticket" => $row["idticket"],
                "idproduct" => $row["idproduct"],"quantity" => $row["quantity"],
                "price" => $row["price"]);
            }          
        }
        return $ticketdetails;
    }
    
    public function getAllFamilies() {
        $sql = "select * from family order by id asc";
        $families = array();
        $result_set = mysqli_query($this->dbcon, $sql);        
        if(mysqli_num_rows($result_set)>0){
            while($row = mysqli_fetch_array($result_set)){
                $families[] = array( 'id' => $row['id'],"family" => $row["family"]);
            }          
        }
        return $families;
    }
    
    public function getFamilyById($id) {
        $sql = "select * from family where id = $id";
        $families = array();
        $result_set = mysqli_query($this->dbcon, $sql);
        if(mysqli_num_rows($result_set)>0){
            while($row = mysqli_fetch_array($result_set)){
                $families[] = array( 'id' => $row['id'],"family" => $row["family"]);
            }          
        }
        return $families;
    }
    
    public function saveTicket($ticket){
        $instTicket = "INSERT INTO `ticket`(`date`, `idmember`) VALUES ( NOW(), ".$ticket["idmember"]." )";
        $result_set = mysqli_query($this->dbcon, $instTicket);
        $result_set? $saved = true: $saved = false;
        return $saved;
    }
    
    public function saveTicketDetails($ticketdetails){
        $insertTicketDetails = "";
        foreach( $ticketdetails["ticketsdetails"] as $td ){
            $insertTicketDetails = $insertTicketDetails.
                                    "INSERT INTO `ticketdetail`( `idticket`, `idproduct`, `quantity`, `price`) ".
                                    "VALUES (".$td["idticket"].",".$td["idproduct"].","
                                    .$td["quantity"].",".$td["price"].");";
        }
        
        $result_set = mysqli_multi_query($this->dbcon, $insertTicketDetails);
        $result_set? $saved = true: $saved = false;
        return $saved;
    }
    
}