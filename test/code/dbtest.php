
<p>TEST<p>

<?php
$tns = " 
(DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = TCP)(HOST = db)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVICE_NAME = XEPDB1)
    )
  )
       ";
$db_username = "YABBA";
$db_password = "DabbaDoo";

class TableRows extends RecursiveIteratorIterator {
    function __construct($it) {
      parent::__construct($it, self::LEAVES_ONLY);
    }
  
    function current() {
      return "<td style='width:150px;border:1px solid black;'>" . parent::current(). "</td>";
    }
  
    function beginChildren() {
      echo "<tr>";
    }
  
    function endChildren() {
      echo "</tr>" . "\n";
    }
  }

echo "<table style='border: solid 1px black;'>";
echo "<tr><th>Id</th><th>Name</th><th>Description</th></tr>";

try{
    $conn = new PDO("oci:dbname=".$tns,$db_username,$db_password);
    echo "<p>Connected successfully</p>";
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $stmt = $conn->prepare("SELECT ID, NAME, DESCRIPTION FROM DOMAIN");
    $stmt->execute();

    $result = $stmt->setFetchMode(PDO::FETCH_ASSOC);
    foreach(new TableRows(new RecursiveArrayIterator($stmt->fetchAll())) as $k=>$v) {
        echo $v;
    }

}catch(PDOException $e){
    echo "Connection failed: " . $e->getMessage();
}

$conn = null;
echo "</table>";

?>