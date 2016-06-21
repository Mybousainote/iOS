<?php 

header("Content-Type: text/html; charset=UTF-8");


require_once('../config.php');
$con = mysql_connect(server, user, pass) or die(mysql_error());
mysql_select_db(myDatabase, $con) or die(mysql_error());
mysql_query('set names utf8',$con);


for ($num=1; $num < 48; $num++) { 

	$fileName;
	if ($num < 10) {
		$fileName = "P20-12_0".$num.".xml";
	}
	else {
		$fileName = "P20-12_".$num.".xml";
	}
	echo $fileName;

	$rss =  '../xml/facilities/'.$fileName;
	$xml = simplexml_load_file($rss);
	$data = get_object_vars($xml);

	// for ($i=0; $i < count($data["Point"]); $i++) { 
	// 	echo "<br>";
	// 	echo "<br>";

	// 	$evacuationFacilities = $data["EvacuationFacilities"];
	// 	$point = $data["Point"];

	// 	// echo $evacuationFacilities[$i]->name;
	// 	// echo $evacuationFacilities[$i]->address;
	// 	// echo $point[$i]->pos;


	// 	$position = explode(" ", $point[$i]->pos);
	// 	$basic = $evacuationFacilities[$i];
	// 	$hazardClassification = $evacuationFacilities[$i]->hazardClassification->Classification;

	// 	$query = "INSERT INTO MyBS_FACILITIES(
	// 	position,
	// 	name,
	// 	address,
	// 	facilityType,
	// 	seatingCapacity,
	// 	facilityScale,
	// 	earthquakeHazard,
	// 	tsunamiHazard,
	// 	windAndFloodDamage,
	// 	volcanicHazard,
	// 	other
	// 	) VALUES(
	// 	GeomFromText('POINT(".$position[0]." ".$position[1].")'),
	// 	'".$basic->name."',
	// 	'".$basic->address."',
	// 	'".$basic->facilityType."',
	// 	".$basic->seatingCapacity.",
	// 	".$basic->facilityScale.",
	// 	'".$hazardClassification->earthquakeHazard."',
	// 	'".$hazardClassification->tsunamiHazard."',
	// 	'".$hazardClassification->windAndFloodDamage."',
	// 	'".$hazardClassification->volcanicHazard."',
	// 	'".$hazardClassification->other."'
	// 	)";

	// 	echo $query;
	// 	mysql_query($query) or die(mysql_error());
	// }

}














 ?>