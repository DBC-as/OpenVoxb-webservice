#!/usr/bin/php
<?php

$startdir = dirname(realpath($argv[0]));
$inclnk = $startdir . "/..";


require_once "$inclnk/OLS_class_lib/inifile_class.php";
//require_once "$inclnk/OLS_class_lib/oci_class.php";
//require_once "$inclnk/OLS_class_lib/pg_database_class.php";


// function usage($str="")
// {
//   global $argv, $inifile,$consumer,$maxprfile,$tempdir,$dataname,$outputfile;
//   if ( $str != "" ) {
//     echo "-------------------\n";
//     echo "\n$str \n";
//   }

//   echo "Usage: php $argv[0]\n";
//   echo "\t-p initfile (default:\"$inifile\") \n";
//   //  echo "\t-d dataname ('albums' el. 'tracks') (default:$dataname)\n";
//   echo "\t-f format ('albums','tracks','albums_tracks_all','albums_tracks_reduced') \n";
//   echo "\t-c consumer (danbib, brønden etc.) (default:$consumer) \n";
//   echo "\t-d data line ('b=danbib,d=121010.{TS}.{NO}.oupsdata,m=hhl@dbc.dk') \n";
//   echo "\t-t trans file (121010.{TS}.trans) \n";
//   echo "\t-m max records pr. file (default $maxprfile)\n";
//   echo "\t-M max number of records to extract\n";
//   echo "\t-T temp dir for generated files (default:$tempdir)\n";
//   echo "\t-I idno file (one idno each line)\n";
//   echo "\t-o outputfile - used together with -I (default:$outputfile)\n";
//   echo "\t-n nothing happens (der bliver ikke opdateret i oups)\n";
//   echo "\t-v verbose level\n";
//   echo "\t-h help (shows this message)\n";
//   exit;
// }

$inifile = $startdir . "/../" . "voxb.ini";
$sqlfil = $startdir . "/" . "create_tables.sql";

// $nothing = false;
// $format = "";
// $consumer = 'danbib';
// $transfile = "";
// $dataline = "";
// $maxprfile = 5000;
// $maxtotal = 0;
// $fileno =  1000;
// $tempdir = "/tmp";
// $outputfile = "data.xml";
// //$dataname = "albums";

// $options = getopt("?hs:v:p:nf:c:d:t:m:M:T:I:o:");
// if ( array_key_exists('h',$options) ) usage();

// $test = $options[v];
// if ( array_key_exists('p',$options) ) $inifile = $options[p];
// //if ( array_key_exists('d',$options) ) $dataname = $options[d];
// if ( array_key_exists('f',$options) ) $format = $options[f];
// if ( array_key_exists('c',$options) ) $consumer = $options[c]

$config = new inifile($inifile);
if ($config->error) die("config->error\n $inifile\n");

$ocilogon = $config->get_value("ocilogon","setup");

echo "ocilogon:$ocilogon\n";

$arr = explode("@",$ocilogon);

//print_r($arr);

if ( $arr[1] != "tora1" ) die("Dette er ikke en test oracle\nVi stopper\n");


$cmd = "sqlplus $ocilogon < $sqlfil\n";
echo $cmd;

system($cmd);

?>
