<?php

require_once('OLS_class_lib/oci_class.php');
require_once('OLS_class_lib/curl_class.php');
require_once('OLS_class_lib/xmlconvert_class.php');
require_once('OLS_class_lib/verbose_class.php');
require_once('OLS_class_lib/material_id_class.php');
require_once('OLS_class_lib/inifile_class.php');

// initialize config 
@$config = new inifile('voxb.ini');

verbose::open($config->get_value('logfile', 'setup'), $config->get_value('verbose', 'setup'));

$config->get_value('logfile', 'setup');
$config->get_value('verbose', 'setup');

if ($config->error) {
  die('Error: '.$config->error );
}

// service closed
if ($http_error = $config->get_value('service_http_error', 'setup')) {
  header($http_error);
  die($http_error);
}

$ucd_oci_login 	= $config->get_value("ucdlogon", "setup");
$voxb_oci_login = $config->get_value("ocilogon", "setup");
$voxb_ws_url		=	$config->get_value("openxid_url", "setup");

$bibdk_ws_url		= 'http://webservice.bibliotek.dk/soeg/?version=1.1&operation=searchRetrieve&query=rec.id+%3D+(BIBLIOGRAPHIC_ID)+and+bath.possessingInstitution+%3D+(RECORD_OWNER)&startRecord=1&maximumRecords=1&recordSchema=dc';

$oci = new oci($ucd_oci_login);
$oci->set_charset('UTF8');
$oci->connect();

$oci_voxb = new oci($voxb_oci_login);
$oci_voxb->set_charset('UTF8');
$oci_voxb->connect();

$curl = new curl(); 
$curl->set_timeout(10);                 
$res = $curl->get($voxb_ws_url);               
unset($curl);

$created=array();
$xmlconvert=new xmlconvert();

$stats['isbn_found']=0;
$stats['error_in_creating_user']=0;
$stats['duplicate_item']=0;
$stats['used_existing_users']=0;
$stats['isbn_not_found']=0;

function get_user_id($email) {
  global $oci_voxb;
	$oci_voxb->bind("email",$email);
  $q="select userid from voxb_users where useridentifiervalue=:email";
  $oci_voxb->set_query($q);
  $result=$oci_voxb->fetch_into_assoc();
  if(!$result['USERID']) {
    return FALSE;
  }
  return $result['USERID'];
}

function check_existing_item($id,$idtype, $userid) {
  global $oci_voxb;

    switch($idtype) {
          case "ISBN":
            $id=materialId::normalizeISBN($id);
          break;
          case "ISSN":
            $id=materialId::normalizeISSN($id);
          break;
          case "EAN":
            $id=materialId::normalizeEAN($id);
          break;
          case "FAUST":
            $id=materialId::normalizeFAUST($id);
          break;
        }

	$oci_voxb->bind("objectidentifiervalue",$id);
	$oci_voxb->bind("objectidentifiertype",$idtype);
	$oci_voxb->bind("userid",$userid);
  #echo $q="select reviewid from voxb_reviews where itemid=(select itemidentifiervalue from voxb_items where objectid=(select objectid from voxb_objects where objectidentifiervalue=:objectidentifiervalue AND objectidentifiertype=:objectidentifiertype))";
  $q="select itemidentifiervalue from voxb_items where objectid=(select distinct objectid from voxb_objects where objectidentifiervalue=:objectidentifiervalue AND objectidentifiertype=:objectidentifiertype) AND userid=:userid";
  $oci_voxb->set_query($q);
  $result=$oci_voxb->fetch_all_into_assoc();
  if(!$result[0]['ITEMIDENTIFIERVALUE']) {
    return FALSE;
  }
	return TRUE;
}


function bibdk_ws($id, $bibdk_ws_url) {
	#echo "\n--- BIBDK REQUEST: -----------------------------------------------\n";
	global $xmlconvert;
	$a=explode(":", $id);
	$record_owner=$a[0];
	$bibliographic_id=$a[1];

	$bibdk_ws_url=str_replace('BIBLIOGRAPHIC_ID', $bibliographic_id, $bibdk_ws_url);
	$bibdk_ws_url=str_replace('RECORD_OWNER', $record_owner, $bibdk_ws_url);

	$curl = new curl(); 
	$curl->set_timeout(10);
	$res=$curl->get($bibdk_ws_url);
	$status=$curl->get_status();
	//print_r($status);
	if(!empty($status['error'])) {
		echo "Found error asking bibdk ws, retrying...\n";
		sleep(1);
		$res=$curl->get($bibdk_ws_url);
		if(!empty($status['error'])) {
    echo "Still error asking bibdk ws, I give up.\n";
		}
	}
	#echo "\n--- BIBDK RESPONSE: -----------------------------------------------\n";
	#echo $res;
	#echo "--------------------------------------------------------------------------\n";

	$startmatch='<recordData>';
	$strlen = strlen($res);
	$start=strpos($res,$startmatch);
	$res=substr($res, $start+strlen($startmatch) , $strlen);

	$strlen = strlen($res);
	$endmatch='</recordData>';
	$end=strpos($res,$endmatch);
	$res=substr($res, 0 , $end);

	$xml=utf8_decode(trim($res));
	if(!empty($xml)) {
		return $obj=$xmlconvert->soap2obj($xml);
	} else {
		return FALSE;
	}
}


function create_user($email,$name) {
	$uniq="UNIQ:".md5($email.$name."Xccv847403870932AA");
	return $create_user_xml='<?xml version="1.0" encoding="UTF-8"?>
	<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:voxb="http://oss.dbc.dk/ns/voxb">
 	  <soapenv:Body>
 	     <voxb:createUserRequest>
 	        <voxb:userAlias>
 	           <voxb:aliasName>'.htmlspecialchars($name).'</voxb:aliasName>
 	           <voxb:profileLink>'.$uniq.'</voxb:profileLink>
 	        </voxb:userAlias>
 	        <voxb:authenticationFingerprint>
 	           <voxb:userIdentifierValue>'.$email.'</voxb:userIdentifierValue>
 	           <voxb:userIdentifierType>local</voxb:userIdentifierType>
 	           <voxb:identityProvider>bibliotek.dk</voxb:identityProvider>
 	           <!--Optional:-->
						<voxb:institutionId>1</voxb:institutionId>
 	        </voxb:authenticationFingerprint>
 	     </voxb:createUserRequest>
 	  </soapenv:Body>
	</soapenv:Envelope>';
}

function create_data($userid, $reviewdata='', $rating='', $title='', $contributor='', $type, $year='', $id, $idtype) {
	$create_data_xml='<?xml version="1.0" encoding="UTF-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:voxb="http://oss.dbc.dk/ns/voxb">
   <soapenv:Body>
      <voxb:createMyDataRequest>
         <voxb:userId>'.$userid.'</voxb:userId>
         <voxb:item>';

	if(!empty($rating)) { 
		$rating=$rating*20; 
		$create_data_xml.='
            <!--Optional:-->
            <voxb:rating>'.$rating.'</voxb:rating>';
		}

	if(!empty($reviewdata)) { 
		$create_data_xml.='
            <!--Optional:-->
            <voxb:review>
               <!--Optional:-->
               <voxb:reviewData>'.utf8_encode(htmlspecialchars($reviewdata)).'</voxb:reviewData>
               <voxb:reviewType>TXT</voxb:reviewType>
            </voxb:review>';
	}

	$create_data_xml.='
         </voxb:item>
         <voxb:object>';
						if(!empty($contributor)) {
            $create_data_xml.='<!--Optional:-->
																<voxb:objectContributors>'.utf8_encode(htmlspecialchars($contributor)).'</voxb:objectContributors>';
						}
            $create_data_xml.='<voxb:objectIdentifierValue>'.$id.'</voxb:objectIdentifierValue>
            <voxb:objectIdentifierType>'.$idtype.'</voxb:objectIdentifierType>
            <!--Optional:-->
            <voxb:objectMaterialType>'.utf8_encode($type).'</voxb:objectMaterialType>';
						if(!empty($year)) {
            $create_data_xml.='<!--Optional:-->
															<voxb:objectPublicationYear>'.$year.'</voxb:objectPublicationYear>';
						}
						$create_data_xml.='
            <!--Optional:-->
            <voxb:objectTitle>'.utf8_encode(htmlspecialchars($title)).'</voxb:objectTitle>
         </voxb:object>
      </voxb:createMyDataRequest>
   </soapenv:Body>
</soapenv:Envelope>';
	return $create_data_xml;
}


// COUNT UCD USERS
echo $q="select count(distinct userid) as COUNT from ucd_reviews where userid in (select username from userauth where ucd_concent='j')";
echo "\n";
$oci->set_query($q);
$result=$oci->fetch_all_into_assoc();
$stats['num_ucd_users']=$result[0]['COUNT'];


// EXTRACT USERS FROM USERAUTH AND UCD
echo $q="select distinct u.username,u.useralias from userauth u, ucd_reviews r where r.userid=u.username and u.ucd_concent='j'";
echo "\n";
$oci->set_query($q);
while($result=$oci->fetch_into_assoc()) {
	if(!empty($result['USERALIAS'])) {
		$email=utf8_decode($result['USERNAME']);
  	$data[$email]['name']=utf8_decode($result['USERALIAS']);
	}
}

// COUNT NUMBER OF REVIEWS
echo $q="select count(*) as COUNT from ucd_reviews where userid in (select username from userauth where ucd_concent='j')";
echo "\n";
$oci->set_query($q);
$result=$oci->fetch_all_into_assoc();
$stats['num_ucd_reviews']=$result[0]['COUNT'];


// EXTRACT REVIEWS
echo $q="select * from ucd_reviews where userid in (select username from userauth where ucd_concent='j')";
echo "\n";
$oci->set_query($q);
while($result=$oci->fetch_into_assoc()) {
	$id					=$result['RECORD_OWNER'].':'.$result['BIBLIOGRAPHIC_ID'];
	$email			=utf8_decode($result['USERID']);
	$reviewdata	=utf8_decode($result['REVIEW_DATA']);

	$data[$email]['ucd'][$id]['reviewdata']=utf8_decode($reviewdata);
}

// COUNT RATINGS
echo $q="select count(*) as COUNT from ucd_ratings where userid in (select username from userauth where ucd_concent='j')";
echo "\n";
$oci->set_query($q);
$result=$oci->fetch_all_into_assoc();
$stats['num_ucd_ratings']=$result[0]['COUNT'];

// EXTRACT RATINGS
echo $q="select * from ucd_ratings where userid in (select username from userauth where ucd_concent='j')";
echo "\n";
$oci->set_query($q);
while($result=$oci->fetch_into_assoc()) {
	$id			=$result['RECORD_OWNER'].':'.$result['BIBLIOGRAPHIC_ID'];
  $email	=utf8_decode($result['USERID']);
  $rating	=$result['RATING_VALUE'];

	$data[$email]['ucd'][$id]['rating']=$rating;
}

//print_r($data); exit();

// create XML output
foreach($data as $email=>$array) {
	if(isset($array['name'])) {
		$name=$array['name'];
		#echo "\n--- CREATE USER REQUEST ---------------------------------------------------\n";
		$userid=get_user_id($email);
		if(!$userid) {
			$xml=create_user($email,$name);
			$curl = new curl(); 
			$curl->set_timeout(10);
			$curl->set_post_xml($xml);  
			$res = $curl->get($voxb_ws_url);               
			unset($curl);
			$obj=$xmlconvert->soap2obj($res);
			if(isset($obj->Envelope->_value->Body->_value->createUserResponse->_value->userId->_value)) {
				$userid=$obj->Envelope->_value->Body->_value->createUserResponse->_value->userId->_value;
				$data[$email]['userid']=$userid;
				echo "Created user: ".utf8_decode($name)." ($userid)\n";
			} else {
				echo "Error in creating user $userid\n";
				$stats['error_in_creating_user']++;
				#echo $res;
			}
		} else {
			echo "Using existing user ($userid)\n";
				$stats['used_existing_users']++;
		}
	}

	if(isset($array['ucd']) && !empty($userid)) {
		foreach($array['ucd'] as $id=>$array2) {
			// $c++; if ($c>10) exit();

			$reviewdata="";
			$rating="";
			$contributor="";
			$year="";
			$title="";

			if(isset($array2['rating'])) $rating=$array2['rating'];
			if(isset($array2['reviewdata'])) $reviewdata=$array2['reviewdata'];

			$obj=bibdk_ws($id, $bibdk_ws_url);

			if($obj!= FALSE) {
				$title=utf8_decode($obj->dc->_value->title->_value);

				if(isset($obj->dc->_value->creator)) {
					if(is_array($obj->dc->_value->creator)) {
						$contributors=array();
						foreach($obj->dc->_value->creator as $k=>$v) {
							$contributors[]=utf8_decode($v->_value);
						}
						$contributor=implode(';',$contributors);
					}	 else {
						$contributor=$obj->dc->_value->creator->_value;
					}
				}

				$type=utf8_decode($obj->dc->_value->type->_value);
				$date=$obj->dc->_value->date->_value;
				$ym=preg_match("/[0-9]{4}/",$date,$target);
				foreach($target as $k=>$v) {
					$date=$v+0;
					if(strlen($date) == 4 && is_integer($date)) {
 							$year=$date;
							break;
					}
				}

				$identifier=&$obj->dc->_value->identifier;
				$m="ISBN:";
				$ml=strlen($m);
				$idtype='LOCAL';

				if(is_array($identifier)) {
					#echo "Found identifier as array.\n";
					foreach($identifier as $k=>$v) {
					 	// print_r($v);
    	   	 	$pos=strpos($v->_value,$m);
						if($pos!==FALSE) {
							$pos+=$ml;
						 	//echo "pos=$pos\n";
    	   	  	$id=substr($v->_value, $pos, 64);
						 	$idtype="ISBN";
							//echo "Found ISBN $id in array.\n";
							$stats['isbn_found']++;
						} else {
							//echo "ISBN not found in array.\n";
							$stats['isbn_not_found']++;
						}
					}
				} elseif(is_string($identifier)) {
					//echo "Identifier ($identifier) is string.\n";
     	  	$pos=strpos($identifier,$m);
     	  	if($pos!==FALSE) {
						$pos+=$ml;
						// echo "pos=$pos\n";
     	  	 	$id=substr($identifier, $pos, 64);
						$idtype="ISBN";
						//echo "Found ISBN $id in string.\n";
							$stats['isbn_found']++;
					} else {
						//echo "ISBN not found.\n";
							$stats['isbn_not_found']++;
					}
				}

				if(check_existing_item($id,$idtype,$userid)) {
					echo "Create mydata skipped. userid: $userid id: $id idtype: $idtype already exists...\n";
					$stats['duplicate_item']++;
					continue;
				}
				

				//echo "\n--- CREATE MYDATA REQUEST ---------------------------------------------\n";
				$xml=create_data($userid, $reviewdata, $rating, $title, $contributor, $type, $year, $id, $idtype);

				$curl = new curl(); 
				$curl->set_timeout(10);
				$curl->set_post_xml($xml);  
				$res = $curl->get($voxb_ws_url);
				if(!preg_match("/faultstring|error|Error/", $res)) {
					echo "Created item userid: $userid id: $id idtype: $idtype\n";
				} else {
					echo "Error in creating item userid: $userid id: $id idtype: $idtype\n";
					echo "\n---------------------------------------------------------------------\n";
					echo $xml;
					echo "\n---------------------------------------------------------------------\n";
					echo $res;
					echo "\n---------------------------------------------------------------------\n";
				}
			
				unset($curl);
				#echo "\n---------------------------------------------------------------------\n";
			} else {
				echo "bibliotek.dk webservice did not find anything with id: $id\n";
			}
		}
	}
}


$q="select count(*) as COUNT from voxb_users";
echo "\n";
$oci_voxb->set_query($q);
$result=$oci_voxb->fetch_all_into_assoc();
$stats['voxb_users']=$result[0]['COUNT'];

$q="select count(*) as COUNT from voxb_reviews";
echo "\n";
$oci_voxb->set_query($q);
$result=$oci_voxb->fetch_all_into_assoc();
$stats['voxb_reviews']=$result[0]['COUNT'];

$q="select count(*) as COUNT from voxb_items";
echo "\n";
$oci_voxb->set_query($q);
$result=$oci_voxb->fetch_all_into_assoc();
$stats['voxb_items']=$result[0]['COUNT'];

foreach($stats as $k => $v) {
	echo strtoupper(str_replace('_',' ',$k)).": $v\n";
}
$oci->disconnect();
?>
