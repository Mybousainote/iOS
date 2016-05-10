<?php 

header("Content-Type: text/html; charset=UTF-8");

require_once('config.php');
$con = mysql_connect(server, user, pass) or die(mysql_error());
mysql_select_db(myDatabase, $con) or die(mysql_error());
mysql_query('set names utf8',$con);

$prefecture = $_GET["prefecture"];
$query = "SELECT id, lat, lng, name, address, facilityType, seatingCapacity, facilityScale, earthquakeHazard, tsunamiHazard, 	windAndFloodDamage, volcanicHazard, other FROM ".Table_Shelter." WHERE address LIKE '".$prefecture."%'";

$result = mysql_query($query) or die(mysql_error());

$responseArray = array();

while ($row = mysql_fetch_assoc($result)) {

    $responseRowArray = array(
    	"id" => $row["id"],
    	"lat" => $row["lat"],
    	"lng" => $row["lng"],
    	"name" => $row["name"],
    	"address" => $row["address"],
    	"facilityType" => $row["facilityType"],
    	"seatingCapacity" => $row["seatingCapacity"],
    	"facilityScale" => $row["facilityScale"],
    	"earthquakeHazard" => $row["earthquakeHazard"],
    	"tsunamiHazard" => $row["tsunamiHazard"],
    	"windAndFloodDamage" => $row["windAndFloodDamage"],
    	"volcanicHazard" => $row["volcanicHazard"],
    	"other" => $row["other"]
    	);
    array_push($responseArray, $responseRowArray);
}

$responseJSON = json_encode($responseArray);
echo $responseJSON;

 ?>


