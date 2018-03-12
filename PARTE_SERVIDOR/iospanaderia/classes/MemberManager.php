<?php

class MemberManager {
    
    private $dbcon;
    
    function __construct($dbconnection) {
        $this->dbcon = $dbconnection;
    }
    
    
    public function getMember($id) {
        $sql = 'select * from member where id = :id';
        $params = array(
            'id' => $id,
        );
        $res = $this->db->execute($sql, $params);
        $statement = $this->db->getStatement();
        $member = new Member();
        if($res && $row = $statement->fetch()) {
            $member->set($row);
        } else {
            $res = null;
        }
        return $member;
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
    
    public function getAllMember() {
        $sql = 'select * from member';
        $res = $this->db->execute($sql);
        $members = array();
        if($res){
            $statement = $this->db->getStatement();
            while($row = $statement->fetch()) {
                $member = new Member();
                $member->set($row);
                $members[] = $member;
            }
        }
        return $members;
    }
}