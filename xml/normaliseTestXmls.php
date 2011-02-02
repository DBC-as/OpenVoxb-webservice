#!/usr/bin/php
<?php

require_once "../OLS_class_lib/inifile_class.php";

$config = new inifile("../voxb.ini");
$version = $config->get_value("version","setup");

$schemaLocation = "schemaLocation=\"";

$location = "http://oss.dbc.dk/ns/voxb https://voxb.addi.dk/$version/xml/voxb.xsd";

$dirs = array('request','response');

foreach($dirs as $dir) {
  echo "dir: $dir\n";
  if ( is_dir($dir)) {
    if ( $dh = opendir($dir)) {
      while (( $file = readdir($dh)) !== false ) {
	if ( ! is_dir($file) ) {
	  $info = pathinfo($file);
	  if ( $info['extension'] == 'xml' ) {
	    echo "\tfile:$file\n";
	    $file = $dir . "/" . $file;
	    $fp = fopen($file,"r");
	    $data = fread($fp,filesize($file));
	    fclose($fp);
	    //echo $data . "\n\n";
	    $data = str_replace("\r","",$data);
            $startpos = strpos($data,$schemaLocation);
	    $startpos = strpos($data,"\"",$startpos);
	    $endpos   = strpos($data,"\"",$startpos+1) + 2;
	    $data = substr($data,0,$startpos) . 
	      "\"$location\" " . 
	      substr($data,$endpos);
	    $fp = fopen($file,"w");
	    fwrite($fp,$data);
	    fclose($fp);
	  }
	}
      }
    }
  }	
}

?>
