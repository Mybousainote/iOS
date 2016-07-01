<?php 

header("Content-Type: text/html; charset=UTF-8");

require_once('../config.php');
$con = mysql_connect(server, user, pass) or die(mysql_error());
mysql_select_db(myDatabase, $con) or die(mysql_error());
mysql_query('set names utf8',$con);

for ($num=15; $num < 23; $num++) {

	$fileName;
	if ($num < 10) {
		$fileName = "A31-12_0".$num.".xml";
	}
	else {
		$fileName = "A31-12_".$num.".xml";
	}
	echo $fileName;
	echo "<br>";

	$rss =  '../xml/floods/'.$fileName;
	$xml = simplexml_load_file($rss);
	$data = get_object_vars($xml);


	for ($i=0; $i < count($data["ExpectedFloodArea"]); $i++) { 
		// echo "<br>";
		// echo "<br>";

		$curve = $data["Area"][$i]->Curve;

		//浸水深の値
		$waterDepth = $data["ExpectedFloodArea"][$i]->waterDepth;

		//それに付随するポリゴン（複数ある場合もあり）
		for ($j=0; $j < count($curve); $j++) {
			// echo "<br>";
			// echo "<br>";

			$posList = (string)($curve[$j]->segments->LineStringSegment->posList);

			if (strpos(substr($posList, -2), ',') !== false) {
				$posList = substr($posList, 0, -2);
			}
			else if (strpos(substr($posList, -3), ',') !== false) {
				$posList = substr($posList, 0, -3);
			}
			else if (strpos(substr($posList, -4), ',') !== false) {
				$posList = substr($posList, 0, -4);
			}	
			else {
				// echo "ぬあ";
			}

			if ($waterDepth != null && $posList != null) {
				//queryを作成
				$query = "INSERT INTO MyBS_FLOODS(
				prefectures,
				posList,
				waterDepth
				) VALUES(
				".$num.",
				GeomFromText('POLYGON((".$posList."))'),
				".$waterDepth."
				)";

				// echo $query;
				mysql_query($query) or die(mysql_error());	
			}
		}		
	}

}

echo "完了！";


 ?>