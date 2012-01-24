<?php
require_once('OLS_class_lib/voxbExampleClient_class.php');

//config
define(VOXB_URL,"http://metode.dbc.dk/~mkr/OpenVoxb/trunk/");

$client=new voxbExampleClient("xml/request/");
echo $client->header();
$client->set_request_action(VOXB_URL);

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
	$xml=$client->createMyDataRequest(275,$_POST['ratingValue'],$tags,$_POST['objectContributors'], $_POST['objectIdentifierValue'], $_POST['objectIdentifierType'], $_POST['objectMaterialType'], $_POST['objectPublicationYear'], $_POST['objectTitle'], $_POST['reviewTitle'], $_POST['reviewData']);
	$obj=$client->xmlconvert->soap2obj($xml);
 	if($client->check_error($obj)) {
	echo $xml;
	} else {
		echo "Data was inserted...";
	}
}

echo $client->footer();

?>
