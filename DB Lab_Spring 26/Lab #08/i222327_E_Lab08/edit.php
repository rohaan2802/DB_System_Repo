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

// GET employee data
if (isset($_GET['empno'])) {
    $empno = $_GET['empno'];

    $sql = "SELECT * FROM dbo.EMP WHERE EMPNO = ?";
    $params = array($empno);

    $stmt = sqlsrv_query($conn, $sql, $params);
    $row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC);
}

// UPDATE logic
if (isset($_POST['update'])) {
    $empno = $_POST['empno'];
    $ename = $_POST['ename'];
    $job = $_POST['job'];
    $sal = $_POST['sal'];

    $sql = "UPDATE dbo.EMP SET ENAME=?, JOB=?, SAL=? WHERE EMPNO=?";
    $params = array($ename, $job, $sal, $empno);

    $stmt = sqlsrv_query($conn, $sql, $params);

    if ($stmt) {
        header("Location: emp_list.php");
    } else {
        echo "Update failed";
        print_r(sqlsrv_errors());
    }
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Employee</title>
    <style>
        body {
            font-family: Arial;
            background: #eef2ff;
            padding: 40px;
        }

        .form-container {
            width: 400px;
            margin: auto;
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }

        h2 {
            text-align: center;
        }

        input {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
        }

        button {
            width: 100%;
            padding: 12px;
            background: #2563eb;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
        }

        button:hover {
            background: #1e40af;
        }
    </style>
</head>
<body>

<div class="form-container">
    <h2>Edit Employee</h2>

    <form method="POST">
        <input type="hidden" name="empno" value="<?php echo $row['EMPNO']; ?>">

        <label>Name:</label>
        <input type="text" name="ename" value="<?php echo $row['ENAME']; ?>" required>

        <label>Job:</label>
        <input type="text" name="job" value="<?php echo $row['JOB']; ?>" required>

        <label>Salary:</label>
        <input type="number" name="sal" value="<?php echo $row['SAL']; ?>" required>

        <button type="submit" name="update">Update</button>
    </form>
</div>

</body>
</html>

<?php sqlsrv_close($conn); ?>