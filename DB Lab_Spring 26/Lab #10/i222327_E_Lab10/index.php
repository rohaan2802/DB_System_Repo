<?php
include 'config.php';
include 'functions.php';
include 'classes/Employee.php';
include 'classes/Department.php';
include 'classes/Project.php';
include 'classes/ProjAssign.php';
include 'classes/Bonus.php';
include 'classes/Salgrade.php';
include 'classes/Dummy.php';


$message = "";

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    if (isset($_POST['insert_department'])) {
        $deptno = $_POST['deptno'];
        $dname = $_POST['dname'];
        $loc = $_POST['loc'];

        if (insertDepartment($conn, $deptno, $dname, $loc)) {
            $message = "Department inserted successfully!";
        } else {
            $message = "Failed to insert department.";
        }
    }

    if (isset($_POST['insert_employee'])) {
        $empno = $_POST['empno'];
        $ename = $_POST['ename'];
        $job = $_POST['job'];
        $mgr = !empty($_POST['mgr']) ? $_POST['mgr'] : null;
        $hiredate = $_POST['hiredate'];
        $sal = $_POST['sal'];
        $comm = ($_POST['comm'] === "") ? null : $_POST['comm'];
        $deptno = ($_POST['deptno_emp'] === "") ? null : $_POST['deptno_emp'];

        if (insertEmployee($conn, $empno, $ename, $job, $mgr, $hiredate, $sal, $comm, $deptno)) {
            $message = "Employee inserted successfully!";
        } else {
            $message = "Failed to insert employee.";
        }
    }

        if (isset($_POST['delete_employee'])) {
        $empno = $_POST['delete_empno'];

        if (deleteEmployee($conn, $empno)) {
            $message = "Employee deleted successfully!";
        } else {
            $message = "Failed to delete employee.";
        }
    }

    if (isset($_POST['delete_department'])) {
        $deptno = $_POST['delete_deptno'];

        if (deleteDepartment($conn, $deptno)) {
            $message = "Department deleted successfully!";
        } else {
            $message = "Failed to delete department.";
        }
    }

        if (isset($_POST['update_employee'])) {
        $empno = $_POST['update_empno'];
        $ename = $_POST['update_ename'];
        $job = $_POST['update_job'];
        $mgr = ($_POST['update_mgr'] === "") ? null : $_POST['update_mgr'];
        $hiredate = $_POST['update_hiredate'];
        $sal = $_POST['update_sal'];
        $comm = ($_POST['update_comm'] === "") ? null : $_POST['update_comm'];
        $deptno = ($_POST['update_deptno_emp'] === "") ? null : $_POST['update_deptno_emp'];

        if (updateEmployee($conn, $empno, $ename, $job, $mgr, $hiredate, $sal, $comm, $deptno)) {
            $message = "Employee updated successfully!";
        } else {
            $message = "Failed to update employee.";
        }
    }

    if (isset($_POST['update_department'])) {
        $deptno = $_POST['update_deptno'];
        $dname = $_POST['update_dname'];
        $loc = $_POST['update_loc'];

        if (updateDepartment($conn, $deptno, $dname, $loc)) {
            $message = "Department updated successfully!";
        } else {
            $message = "Failed to update department.";
        }
    }
}
?>



<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Employee-Department Management System</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

    <div class="container">
        <h1>Employee-Department Management System</h1>

        <!-- Table Viewer -->
        <section class="box">
            <h2>1. Table Viewer</h2>
            <form method="GET" action="index.php">
                <label for="table_name">Select Table:</label>
                <select name="table_name" id="table_name">
                    <option value="">-- Select a Table --</option>
                    <option value="DEPT">DEPT</option>
                    <option value="EMP">EMP</option>
                    <option value="BONUS">BONUS</option>
                    <option value="SALGRADE">SALGRADE</option>
                    <option value="DUMMY">DUMMY</option>
                    <option value="Project">Project</option>
                    <option value="ProjAssign">ProjAssign</option>
                </select>
                <button type="submit">View Table</button>
            </form>
        </section>

        <!-- Full Database View -->
        <section class="box">
            <h2>2. Full Database View with Joins</h2>
            <form method="GET" action="index.php">
                <button type="submit" name="view_full_db" value="1">View Full Database</button>
            </form>
        </section>

        <!-- Employee Search -->
        <section class="box">
            <h2>3. Search Employee by ID</h2>
            <form method="GET" action="index.php">
                <label for="emp_id">Enter Employee ID:</label>
                <input type="number" name="emp_id" id="emp_id" placeholder="e.g. 7369">
                <button type="submit">Search</button>
            </form>
        </section>

        <!-- CRUD Operations -->
        <section class="box">
    <h2>4. CRUD Operations - Insert</h2>

    <h3>Insert Department</h3>
    <form method="POST" action="index.php">
        <input type="number" name="deptno" placeholder="Department No" required>
        <input type="text" name="dname" placeholder="Department Name" required>
        <input type="text" name="loc" placeholder="Location" required>
        <button type="submit" name="insert_department">Insert Department</button>
    </form>

    <h3>Insert Employee</h3>
    <form method="POST" action="index.php">
        <input type="number" name="empno" placeholder="Employee No" required>
        <input type="text" name="ename" placeholder="Employee Name" required>
        <input type="text" name="job" placeholder="Job Title">
        <input type="number" name="mgr" placeholder="Manager No">
        <input type="text" name="hiredate" placeholder="YYYY-MM-DD HH:MM:SS" required>
        <input type="number" step="0.01" name="sal" placeholder="Salary" required>
        <input type="number" step="0.01" name="comm" placeholder="Commission">
        <input type="number" name="deptno_emp" placeholder="Department No">
        <button type="submit" name="insert_employee">Insert Employee</button>
    </form>

    <h3>Delete Employee</h3>
<form method="POST" action="index.php">
    <input type="number" name="delete_empno" placeholder="Employee No" required>
    <button type="submit" name="delete_employee">Delete Employee</button>
</form>

<h3>Delete Department</h3>
<form method="POST" action="index.php">
    <input type="number" name="delete_deptno" placeholder="Department No" required>
    <button type="submit" name="delete_department">Delete Department</button>
</form>

<h3>Update Employee</h3>
<form method="POST" action="index.php">
    <input type="number" name="update_empno" placeholder="Employee No" required>
    <input type="text" name="update_ename" placeholder="Employee Name" required>
    <input type="text" name="update_job" placeholder="Job Title (max 9 chars)">
    <input type="number" name="update_mgr" placeholder="Manager No">
    <input type="text" name="update_hiredate" placeholder="YYYY-MM-DD HH:MM:SS" required>
    <input type="number" step="0.01" name="update_sal" placeholder="Salary" required>
    <input type="number" step="0.01" name="update_comm" placeholder="Commission">
    <input type="number" name="update_deptno_emp" placeholder="Department No">
    <button type="submit" name="update_employee">Update Employee</button>
</form>

<h3>Update Department</h3>
<form method="POST" action="index.php">
    <input type="number" name="update_deptno" placeholder="Department No" required>
    <input type="text" name="update_dname" placeholder="Department Name" required>
    <input type="text" name="update_loc" placeholder="Location" required>
    <button type="submit" name="update_department">Update Department</button>
</form>

<h3>Search Records</h3>
<form method="GET" action="index.php">
    <select name="search_table" required>
        <option value="">-- Select Table --</option>
        <option value="DEPT">DEPT</option>
        <option value="EMP">EMP</option>
        <option value="BONUS">BONUS</option>
        <option value="SALGRADE">SALGRADE</option>
        <option value="DUMMY">DUMMY</option>
        <option value="Project">Project</option>
        <option value="ProjAssign">ProjAssign</option>
    </select>
    <input type="text" name="search_value" placeholder="Enter keyword" required>
    <button type="submit">Search Records</button>
</form>

    <?php
    if (!empty($message)) {
        echo "<p><strong>" . htmlspecialchars($message) . "</strong></p>";
    }
    ?>
</section>

        <!-- Output Area -->
        <section class="box">
    <h2>Output</h2>
    <div>
<?php
if (isset($_GET['view_full_db']) && $_GET['view_full_db'] == 1) {
    $data = fetchFullDatabaseView($conn);
    echo "<h3>Showing Full Database View</h3>";
    displayTable($data);

} elseif (isset($_GET['emp_id']) && !empty($_GET['emp_id'])) {
    $empId = $_GET['emp_id'];
    $data = searchEmployeeById($conn, $empId);

    echo "<h3>Search Result for Employee ID: " . htmlspecialchars($empId) . "</h3>";
    displayTable($data);

} elseif (isset($_GET['search_table']) && !empty($_GET['search_table']) && isset($_GET['search_value']) && $_GET['search_value'] !== "") {
    $searchTable = $_GET['search_table'];
    $searchValue = $_GET['search_value'];
    $data = searchRecords($conn, $searchTable, $searchValue);

    echo "<h3>Search Results in " . htmlspecialchars($searchTable) . " for: " . htmlspecialchars($searchValue) . "</h3>";
    displayTable($data);
} elseif (isset($_GET['table_name']) && !empty($_GET['table_name'])) {
    $tableName = $_GET['table_name'];
    $data = fetchTableData($conn, $tableName);

    echo "<h3>Showing records from table: " . htmlspecialchars($tableName) . "</h3>";
    displayTable($data);

} else {
    echo "<p>No action selected yet.</p>";
}
?>
    </div>
        </section>
    </div>

</body>
</html>