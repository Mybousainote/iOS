<?php 

header("Content-Type: text/html; charset=UTF-8");

// require_once('../config.php');
// $con = mysql_connect(server, user, pass) or die(mysql_error());
// mysql_select_db(myDatabase, $con) or die(mysql_error());
// mysql_query('set names utf8',$con);

for ($num=40; $num < 48; $num++) {

	$fileName;
	if ($num < 10) {
		$fileName = "A33-13_0".$num.".xml";
	}
	else {
		$fileName = "A33-13_".$num.".xml";
	}
	echo $fileName;
	// echo "<br>";

	$rss =  '../xml/sediments/'.$fileName;
	$xml = simplexml_load_file($rss);
	$data = get_object_vars($xml);


	for ($i=0; $i < count($data["SedimentRelatedDisasterWarningAreasPolygon"]); $i++) { 
		// echo "<br>";
		// echo "<br>";

		$curve = $data["Area"][$i]->Curve;

		//現象の種類
		$type = $data["SedimentRelatedDisasterWarningAreasPolygon"][$i]->cop;

		if ($type == 1) {
			// echo "急傾斜地の崩壊";
		}else if ($type == 2) {
			// echo "土石流";
		}else if ($type == 3) {
			// echo "地滑り";
		}else {
		}
		// echo "<br>";

		//区域区分
		$vigilanceDivision = $data["SedimentRelatedDisasterWarningAreasPolygon"][$i]->coz;
		if ($vigilanceDivision == 1) {
			// echo "土砂災害警戒区域(指定済)";
		}else if ($vigilanceDivision == 2) {
			// echo "	土砂災害特別警戒区域(指定済)";
		}else if ($vigilanceDivision == 3) {
			// echo "土砂災害警戒区域(指定前)";
		}else if ($vigilanceDivision == 4) {
			// echo "土砂災害特別警戒区域(指定前)";
		}else {
		}

		echo count($curve);
		// //それに付随するポリゴン（複数ある場合もあり）
		for ($j=0; $j < count($curve); $j++) {

			$posList = (string)($curve[$j]->segments->LineStringSegment->posList);
			// var_dump($posList);

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
			}

			if ($posList != null) {
				//queryを作成
				$query = "INSERT INTO MyBS_SEDIMENTS(
				prefectures,
				posList,
				type,
				vigilanceDivision
				) VALUES(
				".$num.",
				GeomFromText('POLYGON((".$posList."))'),
				".$type.",
				".$vigilanceDivision."
				)";

				// echo $query;
				// mysql_query($query) or die(mysql_error());	
			}
		}		
	}
	echo "完了！";
}


 ?>