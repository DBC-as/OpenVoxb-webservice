<?php
require_once('OLS_class_lib/webServiceClientUtils_class.php');

class voxbExampleClient extends webServiceClientUtils {


	public function createMyDataRequest($userId, $rating, $objectContributors, $objectIdentifierValue, $objectIdentifierType, $objectMaterialType, $objectPublicationYear, $objectTitle) {
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

	function displayData() {
		echo $this->header();
		
		echo $this->footer();
	}
	
	function displayFetchForm() {
		echo $this->header();
		echo "<FORM METHOD='POST'>";
		echo "objectIdentifierType: <SELECT NAME='objectIdentifierType'>\n";
		echo "<OPTION VALUE='ISBN'>ISBN</OPTION>\n";
		echo "<OPTION VALUE='FAUST'>FAUST</OPTION>\n";
		echo "</SELECT>\n";
		echo "<br>objectIdentifierValue: <INPUT TYPE='TEXT' NAME='objectIdentifierValue'>\n";
		echo "<input type='SUBMIT' NAME='fetchDataRequest' value='fetchDataRequest'>";
		echo "</FORM>";
		echo $this->footer();
	}

	function header() {
		return "<HTML>\n<BODY>";
	}

	function footer() {
		return "</BODY>\n</HTML>";
	}

}


$vEC=new voxbExampleClient("xml/request/");
$vEC->set_request_action("http://metode.dbc.dk/~mkr/OpenVoxb/trunk/");
//$xml=$vEC->createMyDataRequest(275,100,"Forfatter", 11111111111111, "ISBN", "Bog", 1900, "titel");
//echo $vEC->check_error($vEC->xmlconvert->soap2obj($xml));
//echo $vEC->fetchDataRequest("11111111111111", "ISBN", "DK-100450", 790900);
$vEC->displayFetchForm();

if(isset($_POST["fetchDataRequest"])) {
	$xml=$vEC->fetchDataRequest($_POST["objectIdentifierValue"], $_POST["objectIdentifierType"]);
 	if($vEC->check_error($vEC->xmlconvert->soap2obj($xml))) {
		echo "Could not find any items...";
	} else {
		echo $xml;
	}
}


//$obj->Envelope->_value->Body->_value->createMyDataRequest->_value->userId


?>
