<?php 

header("Content-Type: text/html; charset=UTF-8");

require_once('../config.php');
$con = mysql_connect(server, user, pass) or die(mysql_error());
mysql_select_db(myDatabase, $con) or die(mysql_error());
mysql_query('set names utf8',$con);

$lat = $_GET["lat"];
$lng = $_GET["lng"];
$rectSize = $_GET["rect-size"];

$half = $rectSize/2;

$containRect = "GeomFromText('Polygon((".(string)($lat-$half)." ".(string)($lng-$half).",".(string)($lat+$half)." ".(string)($lng-$half).",".(string)($lat+$half)." ".(string)($lng+$half).",".(string)($lat-$half)." ".(string)($lng+$half).",".(string)($lat-$half)." ".(string)($lng-$half)."))')";

// echo $containRect;
$query = "SELECT id, prefectures, AsText(posList) as posList, type, vigilanceDivision FROM MyBS_SEDIMENTS WHERE MBRContains(".$containRect.", posList)";

$result = mysql_query($query) or die(mysql_error());

$responseArray = array();

while ($row = mysql_fetch_assoc($result)) {

    $responseRowArray = array(

    	"id" => $row["id"],
        "prefectures" => $row["prefectures"],
        "posList" => $row["posList"],
        "type" => $row["type"],
        "vigilanceDivision" => $row["vigilanceDivision"]
    	);
    array_push($responseArray, $responseRowArray);
}

$responseJSON = json_encode($responseArray);
echo $responseJSON;

 ?>


