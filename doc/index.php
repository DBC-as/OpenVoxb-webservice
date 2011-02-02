<?php
        
require_once "../OLS_class_lib/inifile_class.php";

$config = new inifile("../voxb.ini");
$version = $config->get_value("version","setup");


echo "<h1>VoxB webservice documentation  \"$version\"</h1>\n";
echo "<br /><br /> \n";
echo "<ul> \n";
echo "<li> \n";
echo "<a href=voxb.html>VoxB.xsd documentation</a> \n";
echo "</li> \n";
echo "<li> \n";
echo "<a href=../xml/voxb.xsd>VoxB.xsd</a> \n";
echo "</li> \n";
echo "<li> \n";
echo "<a href=../xml/voxb.wsdl>VoxB.wsdl</a> \n";
echo "</li> \n";
echo "</ul> \n";

#if ( file_exists('UdviklingstrinForBSD.htm') ) {
  #echo "<ul> \n";
  #echo "<li> \n";
  #echo "<a href=\"UdviklingstrinForBSD.htm\">UdviklingstrinForBSD</a> \n";
  #echo "</li> \n";
  #echo "</ul> \n";
 #}

echo "<ul> \n";
echo "<li> \n";
echo "<a href=http://milne.dbc.dk/twiki/bin/view/BrugerSkabteData/WebHome>Product Backlog + Sprint Backlogs</a> \n";
echo "</li> \n";
echo "</ul> \n";



echo "<p> \n";
echo "<ul> \n";

$dirs = array('request','response');
foreach($dirs as $curdir) {
  $dir = "../xml/$curdir";
  $files = array();

  echo "<ul> \n";
  echo "<li>$curdir</li> \n";
  echo "<ul> \n";
  // Open a known directory, and proceed to read its contents
  if (is_dir($dir)) {
    if ($dh = opendir($dir)) {
      while (($file = readdir($dh)) !== false) {
          if ( ! is_dir($file) ) {
	    $info = pathinfo($file);
	    if ( $info['extension'] == 'xml' ) {
	      $files[] = $file;
            }
	  }
      }
    }
  }
  closedir($dh);
  asort($files);
  foreach ($files as $file) {
    echo "<li><a href=" . $dir . "/" . $file . ">$file</a/</li>\n";
  }
  
  echo "</ul>";
  echo "</ul>";
}
echo "</ul>";
//print_r($files);

?>
