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
		foreach($tags as $k=>$v) {
			$this->insert_tag($req_obj, "tags","tag", $v, "http://oss.dbc.dk/ns/voxb");
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

	function extractData($obj, &$data) {
   foreach ($obj as $k=>$v) {
			if(is_string($k) && ($k=="aliasName" || $k=="averageRating" || $k=="rating" || $k=="reviewData" || $k=="reviewTitle")) {
        $data[$k][]=$v->_value;
      }
      if(is_object($v) || is_array($v)) {
        $this->extractData($v, $data);
      }
    }
		return $data;
	}

	function makeDisplayData($data) {
		if(is_array($data["rating"]))
			array_shift($data["rating"]);
		foreach($data["aliasName"] as $k=>$v) {
			$displaydata[$k]["aliasName"]=$v;
			$displaydata[$k]["rating"]=$data["rating"][$k];
			$displaydata[$k]["reviewTitle"]=$data["reviewTitle"][$k];
			$displaydata[$k]["reviewData"]=$data["reviewData"][$k];
			if(
				empty($data["rating"][$k]) && empty($data["reviewTitle"][$k]) && empty($data["reviewData"][$k]) ) {
				unset($displaydata[$k]);
			} 
		}
		return($displaydata);
	}

	function displayData($obj) {
		echo "<pre>";
		$data=array();
		$data=$this->extractData($obj, $data);
		$displaydata=$this->makeDisplayData($data);
		
		foreach($displaydata as $k=>$v) {
			echo $v["aliasName"];
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
	
	function displayFetchForm() {
		echo "<FORM METHOD='POST'>";
		echo "objectIdentifierType: <SELECT NAME='objectIdentifierType'>\n";
		echo "<OPTION VALUE='ISBN'>ISBN</OPTION>\n";
		echo "<OPTION VALUE='FAUST'>FAUST</OPTION>\n";
		echo "</SELECT>\n";
		echo "<br>objectIdentifierValue: <INPUT TYPE='TEXT' NAME='objectIdentifierValue'>\n";
		echo "<input type='SUBMIT' NAME='fetchDataRequest' value='fetchDataRequest'>";
		echo "</FORM>";
	}

	function header() {
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
$client->displayFetchForm();

if(isset($_POST["fetchDataRequest"])) {
	$xml=$client->fetchDataRequest($_POST["objectIdentifierValue"], $_POST["objectIdentifierType"]);
	$obj=$client->xmlconvert->soap2obj($xml);
 	if($client->check_error($obj)) {
		echo "Could not find any items...";
	} else {
		$client->displayData($obj);
	}
}


//$obj->Envelope->_value->Body->_value->createMyDataRequest->_value->userId

echo $client->footer();

?>
