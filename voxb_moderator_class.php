<?php

require_once('OLS_class_lib/oci_class.php');
require_once('OLS_class_lib/inifile_class.php');
require_once('OLS_class_lib/verbose_class.php');

require_once("voxb_constants.php");

class voxb_complaints {

	protected $config; // inifile object
	private $oci;
	private $oci2;
	protected $error_checksum="FATAL ERROR: Checksum mismatch.";

	function __construct($inifile) {
		// initialize config and verbose objects
    $this->config = new inifile($inifile);
		
    if ($this->config->error) {
        die('Error: '.$this->config->error );
    }

    $this->oci = new oci($this->config->get_value('ocilogon'));
    $this->oci->set_charset('UTF8');
		$this->oci->commit_enable(TRUE);
    try { $this->oci->connect(); }
    catch (ociException $e) {
      verbose::log(FATAL, get_class()." :: OCI connect error: " . $this->oci->get_error_string());
      unset($this->oci);
      return COULD_NOT_REACH_DATABASE;
    }
		
	 	$this->oci2 = new oci($this->config->get_value('ocilogon'));
    $this->oci2->set_charset('UTF8');
    $this->oci2->commit_enable(TRUE);
    try { $this->oci2->connect(); }
    catch (ociException $e) {
      verbose::log(FATAL, get_class()." :: OCI connect error: " . $this->oci->get_error_string());
      unset($this->oci2);
      return COULD_NOT_REACH_DATABASE;
    }
		

		$this->get_new_complaints();

    return null;
	}


	function get_new_complaints() {
   $this->oci->set_query("select * from voxb_complaints where status='".COMPLAINT_STATUS_NEW."'");
    while($data=$this->oci->fetch_into_assoc()) {
					$this->handle_new_complaint($data);
    }
	}

	function set_status($status, $complaintid) {
   	$this->oci2->set_query("update voxb_complaints set status='$status' where complaintid=$complaintid");
	}

	function make_checksum($string) {
		return md5($this->config->get_value('salt').$string);
	}

	function handle_new_complaint($complaint_data) {
		$offending_data=$this->oci2->fetch_into_assoc("select * from voxb_reviews where itemid=".$complaint_data['OFFENDING_ITEMID']."");
		$offending_tags=$this->oci2->fetch_all_into_assoc("select * from voxb_tags where itemid=".$complaint_data['OFFENDING_ITEMID']."");

		if(!empty($offending_tags)) {
			foreach($offending_tags as $k=>$v) {
  			$tags.=$v['TAG'].",";
			}
			$tags=substr($tags,0,strlen($tags)-1);
		} else {
			$tags="";
		}

		$offender_data=$this->oci2->fetch_into_assoc("select * from voxb_users where userid=".$complaint_data['OFFENDER_USERID']."");
		$complainant_data=$this->oci2->fetch_into_assoc("select * from voxb_users where userid=".$complaint_data['COMPLAINANT_USERID']."");
    $this->oci2->bind("offender_institutionid", $complaint_data['OFFENDER_INSTITUTIONID']);
    $institution_data=$this->oci2->fetch_into_assoc("select * from voxb_institutions where institutionid=:offender_institutionid");

		// prepare and send mail
		$to=$institution_data["MODERATOR_EMAIL"];

		$cid=$complaint_data['COMPLAINTID'];
		$c	=$this->make_checksum($offending_data["REVIEWID"].$cid."del_review");
		$c2	=$this->make_checksum($offending_data["REVIEWID"].$cid."ign_comp");
		$c3	=$this->make_checksum($complaint_data['OFFENDER_USERID'].$cid."del_user");

		$baseurl=$this->config->get_value('baseurl','complaint');
		$baseurl_del_review	=$baseurl."?del_review=".$offending_data["REVIEWID"]."&cid=$cid&c=$c";
		$baseurl_ign_comp		=$baseurl."?ign_comp=".$offending_data["REVIEWID"]."&cid=$cid&c=$c2";
		$baseurl_del_user		=$baseurl."?del_user=".$complaint_data['OFFENDER_USERID']."&cid=$cid&c=$c3";

		$title=$this->config->get_value('mail_title', 'complaint');
		$title=str_replace('<COMPLAINANT_ALIAS_NAME>', $complainant_data["ALIAS_NAME"], $title);
		$title=str_replace('<OFFENDER_ALIAS_NAME>', $offender_data["ALIAS_NAME"], $title);
		$title=str_replace('<NEWLINE>', "\n", $title);

		$body=$this->config->get_value('mail_body','complaint');
		$body=str_replace('<COMPLAINANT_ALIAS_NAME>', $complainant_data["ALIAS_NAME"], $body);
		$body=str_replace('<OFFENDER_ALIAS_NAME>', $offender_data["ALIAS_NAME"], $body);
		$body=str_replace('<OFFENDING_DATA_TITLE>',$offending_data["TITLE"],$body);	
		$body=str_replace('<OFFENDING_DATA_DATA>',$offending_data["DATA"],$body);	
		$body=str_replace('<OFFENDING_DATA_TAGS>',$tags,$body);	
		$body=str_replace('<NEWLINE>', "\n", $body);


		$body.="-----------------------------------------------------\n";
		$body.=$this->config->get_value('del_review','complaint').": $baseurl_del_review\n";
		$body.="-----------------------------------------------------\n";
		$body.=$this->config->get_value('ign_comp','complaint').": $baseurl_ign_comp\n";
		$body.="-----------------------------------------------------\n";
		$body.=$this->config->get_value('del_user','complaint').": $baseurl_del_user\n";

		$body.="-----------------------------------------------------\n";
		$headers .= 'From: Voxb complaint handler <noreply@voxbaddi.dk>' . "\r\n";
		mail($to,$title,$body, $headers);
		$this->set_status(COMPLAINT_STATUS_OPEN, $complaint_data['COMPLAINTID']);
	}

	function ignore_complaint($reviewid, $complaintid, $checksum) {
		if($checksum==$this->make_checksum($reviewid.$complaintid.'ign_comp')) {
			$this->close($complaintid, COMPLAINT_STATUS_IGNORED);
		} else {
			Die($this->error_checksum);
		}
	}

	function delete_review($reviewid, $complaintid, $checksum) { 
		if($checksum==$this->make_checksum($reviewid.$complaintid.'del_review')) {
			echo "<br>update voxb_items set disabled=1 where ITEMIDENTIFIERVALUE=(SELECT itemid from voxb_reviews where reviewid=$reviewid)<br>";
			#echo "update voxb_complaints set status='".COMPLAINT_STATUS_ITEM_DISABLED."' where offending_itemid=(SELECT itemid from voxb_reviews where reviewid=$reviewid)<hr>";

   		$this->oci2->set_query("update voxb_items set disabled=1 where ITEMIDENTIFIERVALUE=(SELECT itemid from voxb_reviews where reviewid=$reviewid)");
   		#$this->oci2->set_query("update voxb_complaints set status='".COMPLAINT_STATUS_ITEM_DISABLED."' where offending_itemid=(SELECT itemid from voxb_reviews where reviewid=$reviewid)");
			$this->close($complaintid, COMPLAINT_STATUS_ITEM_DISABLED);
		} else {
			Die($this->error_checksum);
		}
	}

	function delete_offender($userid, $complaintid, $checksum) { 
		$this->make_checksum($userid.'del_user');
		if($checksum==$this->make_checksum($userid.$complaintid.'del_user')) {
   		echo "<br>update voxb_users set disabled=1 where userid=$userid<br>";
			#echo "update voxb_complaints set status='".COMPLAINT_STATUS_USER_DISABLED."' where offender_userid=$userid and offending_itemid=(SELECT offending_itemid from voxb_complaints where complaintid=$complaintid)<br>";
			echo "update voxb_items set disabled=1 where userid=$userid<hr>";

   		$this->oci2->set_query("update voxb_users set disabled=1 where userid=$userid");
   		#$this->oci2->set_query("update voxb_complaints set status='".COMPLAINT_STATUS_USER_DISABLED."' where offender_userid=$userid and offending_itemid=(SELECT offending_itemid from voxb_complaints where complaintid=$complaintid)");
   		$this->oci2->set_query("update voxb_items set disabled=1 where userid=$userid");

			$this->close($complaintid, COMPLAINT_STATUS_USER_DISABLED);
		} else {
			Die($this->error_checksum);
		}
	}

	function close($complaintid, $complaint_status) {
		$this->set_status($complaint_status, $complaintid);
	}

	
}

?>
