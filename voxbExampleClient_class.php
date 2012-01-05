<?php
require_once('OLS_class_lib/webServiceClientUtils_class.php');

class voxbExampleClient extends webServiceClientUtils {


	public function createMyDataRequest($userId, $rating, $tags, $objectContributors, $objectIdentifierValue, $objectIdentifierType, $objectMaterialType, $objectPublicationYear, $objectTitle) {
		$rn="createMyDataRequest";
		$this->load_request($rn);
		$req_obj=&$this->get_request_object($rn);
		
		$this->change_tag_value($req_obj, "userId", $userId);
		$this->change_tag_value($req_obj, "rating", $rating);
		$this->change_tag_value($req_obj, "objectIdentifierValue", $objectIdentifierValue);
		$this->change_tag_value($req_obj, "objectIdentifierType", $objectIdentifierType);
		$this->change_tag_value($req_obj, "objectContributors", $objectContributors);
		$this->change_tag_value($req_obj, "objectMaterialType", $objectMaterialType);
		$this->change_tag_value($req_obj, "objectPublicationYear", $objectPublicationYear);
		$this->change_tag_value($req_obj, "objectTitle", $objectTitle);
		$this->delete_tag($req_obj, "local");
		$this->delete_tag($req_obj, "tag");

		if(is_array($tags)) {
			foreach($tags as $k=>$v) {
				$this->insert_tag($req_obj, "tags","tag", $v, "http://oss.dbc.dk/ns/voxb");
			}	
		}
		
		return $this->send_request($rn, $this->request_action);
	}

	function fetchDataRequest($objectIdentifierValue, $objectIdentifierType) {
		$rn="fetchDataRequest2";
		$this->load_request($rn);
		$req_obj=&$this->get_request_object($rn);

		$this->change_tag_value($req_obj, "objectIdentifierValue", $objectIdentifierValue);
    $this->change_tag_value($req_obj, "objectIdentifierType", $objectIdentifierType);

		return $this->send_request($rn, $this->request_action);
	}

	function extractData($obj, &$data, &$key="test") {
   foreach ($obj as $k=>$v) {
			if (is_string($k)) {
				if($k=="objectIdentifierValue" || $k=="objectIdentifierType") {
      	 	$data["objectInfo"][$k]=$v->_value;
				}
				if($k=="ratingSummary") {
					break;
				}
				if($k=="aliasName") {
					 $key=$v->_value;
				}
				if(($k=="averageRating" || $k=="rating" || $k=="reviewData" || $k=="reviewTitle" || $k=="timestamp")) {
 	      	$data["userItems"][$key][$k]=$v->_value;
 	     	}
				if(($k=="tag") && !empty($v->_value)) {
 	      	$data[$k][]=$v->_value;
 	     	}
			}

      if(is_object($v) || is_array($v)) {
        $this->extractData($v, $data, $key);
      }
    }
		return $data;
	}


	function displayData($obj) {
		echo "<pre>";
		$data=array();
		$data=$this->extractData($obj, $data);

		echo "<h3>";	
		echo $data["objectInfo"]["objectIdentifierType"].": ".$data["objectInfo"]["objectIdentifierValue"];
		echo "</h3>";	
		if(isset($data["tag"]))	{
			echo "tags: ".implode($data["tag"], ", ");
			echo "<P>";
		}
		foreach($data["userItems"] as $k=>$v) {
			if(count($v)>1) {
				echo "<b>".$k."</b>";
				echo "<br>";
				if(!empty($v["rating"])) {
					echo "rating: ";
					echo $v["rating"];
					echo "<br>";
				}
				if(!empty($v["reviewTitle"])) {
					echo "review titel: ";
					echo $v["reviewTitle"];
					echo "<br>";
				}
				if(!empty($v["reviewData"])) {
					echo "review: ";
					echo $v["reviewData"];
					echo "<br>";
				}
				echo "<hr>";
			}	
		}
	}

	function displayInputForm() {
		echo "<TABLE>";
		echo "<tr><td><h3>Insert data</h3></td></tr>";
		echo "<FORM METHOD='POST'>";
   	echo "<tr><td>objectIdentifierType:</td><td><SELECT NAME='objectIdentifierType'>\n";
    echo "<OPTION VALUE='ISBN'>ISBN</OPTION>\n";
    echo "<OPTION VALUE='FAUST'>FAUST</OPTION>\n";
    echo "</SELECT><td></tr>\n";
    echo "<tr><td>objectIdentifierValue:</td><td><INPUT TYPE='TEXT' NAME='objectIdentifierValue'><td></tr>\n";


   	echo "<tr><td>objectMaterialType:</td><td><SELECT NAME='objectIdentifierType'>\n";
    echo "<OPTION VALUE='Bog'>Bog</OPTION>\n";
    echo "</SELECT><td></tr>\n";

    echo "<tr><td>objectContributors (name1, name2, etc):</td><td><INPUT TYPE='TEXT' NAME='objectContributors'><td></tr>\n";
    echo "<tr><td>objectPublicationYear:</td><td><INPUT TYPE='TEXT' SIZE='4' MAXLENGTH='4' NAME='objectPublicationYear'><td></tr>\n";
    echo "<tr><td>objectTitle:</td><td><INPUT TYPE='TEXT' NAME='objectTitle'><td></tr>\n";
    echo "<tr><td>ratingValue (min 0 max 100):</td><td><INPUT TYPE='TEXT' SIZE='3' NAME='ratingValue'><td></tr>\n";
    echo "<tr><td valign='top'>reviewText:</td><td><TEXTAREA COLS=56 rows=20 NAME='reviewData'></TEXTAREA><td></tr>\n";
    echo "<tr><td>Tags (tag1,tag2,tag3,etc):</td><td><INPUT TYPE='TEXT' SIZE='50' NAME='tags'><td></tr>\n";
    echo "<tr><td><input type='SUBMIT' NAME='createDataRequest' value='createDataRequest'></td></tr>";

		echo "</FORM>";
		echo "</TABLE>";
		echo "<HR>";
		
	}
	
	function displayFetchForm() {
		echo "<h3>Fetch data</h3><FORM METHOD='POST'>";
		echo "objectIdentifierType: <SELECT NAME='objectIdentifierType'>\n";
		echo "<OPTION VALUE='ISBN'>ISBN</OPTION>\n";
		echo "<OPTION VALUE='FAUST'>FAUST</OPTION>\n";
		echo "</SELECT>\n";
		echo "objectIdentifierValue: <INPUT TYPE='TEXT' NAME='objectIdentifierValue'>\n";
		echo "<input type='SUBMIT' NAME='fetchDataRequest' value='fetchDataRequest'>";
		echo "</FORM><HR>";
	}

	function header() {
		header('Content-Type:text/html; charset=UTF-8');
		return "<HTML>\n<BODY>";
	}

	function footer() {
		return "</BODY>\n</HTML>";
	}

}

$client=new voxbExampleClient("xml/request/");
echo $client->header();
$client->set_request_action("http://metode.dbc.dk/~mkr/OpenVoxb/trunk/");
//$xml=$client->createMyDataRequest(275,100,array('A', 'B'),"Forfatter", 11111111111111, "ISBN", "Bog", 1900, "titel");
//echo $client->check_error($client->xmlconvert->soap2obj($xml));
//echo $client->fetchDataRequest("11111111111111", "ISBN", "DK-100450", 790900);

if(isset($_GET['displayInputForm'])) {
	echo "<a href='?displayFetchForm'>Fetch data</a><hr>";
	$client->displayInputForm();

} else {
	echo "<a href='?displayInputForm'>Insert data</a><hr>";
	$client->displayFetchForm();
}

if(isset($_POST["fetchDataRequest"])) {
	$xml=$client->fetchDataRequest($_POST["objectIdentifierValue"], $_POST["objectIdentifierType"]);
	$obj=$client->xmlconvert->soap2obj($xml);
 	if($client->check_error($obj)) {
		echo $xml;
	} else {
		$client->displayData($obj);
	}
}

if(isset($_POST["createDataRequest"])) {
	if(!empty($_POST['tags'])) {
		$tags=explode(',',$_POST['tags']);
	}
	$xml=$client->createMyDataRequest(275,$_POST['ratingValue'],$tags,$_POST['objectContributors'], $_POST['objectIdentifierValue'], $_POST['objectIdentifierType'], $_POST['objectMaterialType'], $_POST['objectPublicationYear'], $_POST['objectTitle']);
	$obj=$client->xmlconvert->soap2obj($xml);
 	if($client->check_error($obj)) {
	echo $xml;
	} else {
		echo "Data was inserted...";
	}
}

echo $client->footer();

?>
