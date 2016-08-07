<?php 

header("Content-Type: text/html; charset=UTF-8");

require_once('../config.php');
$con = mysql_connect(server, user, pass) or die(mysql_error());
mysql_select_db(myDatabase, $con) or die(mysql_error());
mysql_query('set names utf8',$con);

$lat = $_GET["lat"];
$lng = $_GET["lng"];
$point = "GeomFromText('Point(".$lat." ".$lng.")')";

// echo $containRect;
$query = "SELECT type FROM MyBS_SEDIMENTS WHERE MBRWithin(".$point.", posList)";

$result = mysql_query($query) or die(mysql_error());


$row = mysql_fetch_assoc($result);

$type;
if ($row["type"] != null) {
	$type = $row["type"];
}else {
	$type = "0";
}

$responseObject = array(
	"type" => $type
);

$responseJSON = json_encode($responseObject);
echo $responseJSON;

 ?>


