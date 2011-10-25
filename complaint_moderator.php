<?php
require_once("voxb_moderator_class.php");
require_once('OLS_class_lib/oci_class.php');
require_once('OLS_class_lib/inifile_class.php');
$c=new voxb_complaints('voxb.ini');

	if($_GET['ign_comp']) {
		echo "Klagen blev ignoreret og sagen lukket.";
		$c->ignore_complaint($_GET['ign_comp'], $_GET['cid'], $_GET['c']);
	} else if($_GET['del_review']) {
		echo "Kommentaren blev slettet.";
		$c->delete_review($_GET['del_review'], $_GET['cid'], $_GET['c']);

	} else if($_GET['del_user']) {
		echo "Brugeren og alle brugerens kommentarer blev slettet.";
		$c->delete_offender($_GET['del_user'], $_GET['cid'], $_GET['c']);
}
/*
$config=new inifile('voxb.ini');
$oci = new oci($config->get_value('ocilogon'));
$oci->set_charset('UTF8');
$oci->commit_enable(TRUE);
$oci->connect();

$list=$oci->fetch_all_into_assoc('SELECT * from voxb_complaints order by status desc,creation_date asc');
foreach($list as $k=>$v) {
	foreach($v as $k2=>$v2) {
		echo "$k2=$v2<br>";
	}
	echo "<HR>";	
}
*/


?>
