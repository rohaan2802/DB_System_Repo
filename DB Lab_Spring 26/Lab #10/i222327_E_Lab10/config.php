<?php
$serverName = "localhost";

$connectionOptions = array(
    "Database" => "EmpDeptDB",
    "Uid" => "scott",
    "PWD" => "tiger1234",
    "CharacterSet" => "UTF-8"
);

// Create connection
$conn = sqlsrv_connect($serverName, $connectionOptions);

// Check connection
if ($conn === false) {
    die("<pre>Connection failed:\n" . print_r(sqlsrv_errors(), true) . "</pre>");
}
?>