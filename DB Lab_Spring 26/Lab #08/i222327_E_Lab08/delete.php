<?php
$serverName = "localhost";

$connectionOptions = array(
    "Database" => "EmpDeptDB",
    "Uid" => "scott",
    "PWD" => "tiger1234"
);

$conn = sqlsrv_connect($serverName, $connectionOptions);

if (!$conn) {
    die("Connection failed");
}

// get empno from URL
if (isset($_GET['empno'])) {
    $empno = $_GET['empno'];

    $sql = "DELETE FROM dbo.EMP WHERE EMPNO = ?";
    $params = array($empno);

    $stmt = sqlsrv_query($conn, $sql, $params);

    if ($stmt) {
        header("Location: emp_list.php");
    } else {
        echo "Delete failed";
        print_r(sqlsrv_errors());
    }
}

sqlsrv_close($conn);
?>