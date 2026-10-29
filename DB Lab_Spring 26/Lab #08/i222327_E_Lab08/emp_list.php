<?php
$serverName = "localhost";

$connectionOptions = array(
    "Database" => "EmpDeptDB",
    "Uid" => "scott",
    "PWD" => "tiger1234",
    "CharacterSet" => "UTF-8"
);

$conn = sqlsrv_connect($serverName, $connectionOptions);

if (!$conn) {
    die("Connection failed.<br>" . print_r(sqlsrv_errors(), true));
}

$sql = "SELECT EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO FROM dbo.EMP";
$stmt = sqlsrv_query($conn, $sql);

if ($stmt === false) {
    die("Query failed.<br>" . print_r(sqlsrv_errors(), true));
}

$rows = [];
$departments = [];

while ($row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)) {
    $rows[] = $row;
    $departments[] = $row['DEPTNO'];
}

$departments = array_unique($departments);
sort($departments);
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Employee List</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #dbeafe, #f0f9ff, #e0f2fe);
            min-height: 100vh;
            padding: 30px;
            transition: 0.3s;
        }

        body.dark {
            background: linear-gradient(135deg, #0f172a, #1e293b, #334155);
            color: white;
        }

        .container {
            width: 95%;
            max-width: 1300px;
            margin: auto;
            background: #ffffff;
            border-radius: 18px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.12);
            padding: 30px;
            transition: 0.3s;
        }

        body.dark .container {
            background: #1e293b;
            color: white;
        }

        .header {
            text-align: center;
            margin-bottom: 25px;
        }

        .header h1 {
            font-size: 34px;
            margin-bottom: 8px;
            color: #0f172a;
        }

        body.dark .header h1,
        body.dark .header p {
            color: white;
        }

        .header p {
            color: #475569;
        }

        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 20px;
        }

        .controls {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        input, select, button {
            padding: 11px 14px;
            border-radius: 10px;
            border: 1px solid #cbd5e1;
            font-size: 14px;
            outline: none;
        }

        input:focus, select:focus {
            border-color: #2563eb;
            box-shadow: 0 0 8px rgba(37, 99, 235, 0.2);
        }

        .badge {
            background: #2563eb;
            color: white;
            padding: 10px 16px;
            border-radius: 999px;
            font-size: 14px;
            font-weight: bold;
        }

        .dark-btn {
            background: #0f172a;
            color: white;
            border: none;
            cursor: pointer;
        }

        .dark-btn:hover {
            opacity: 0.9;
        }

        .table-wrapper {
            overflow-x: auto;
            border-radius: 14px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            border-radius: 14px;
            overflow: hidden;
        }

        thead {
            background: linear-gradient(90deg, #1d4ed8, #2563eb);
            color: white;
        }

        th, td {
            padding: 14px 16px;
            text-align: center;
        }

        tbody tr {
            border-bottom: 1px solid #e2e8f0;
            transition: 0.25s;
        }

        tbody tr:nth-child(even) {
            background-color: #f8fafc;
        }

        tbody tr:hover {
            background-color: #dbeafe;
        }

        body.dark tbody tr:nth-child(even) {
            background-color: #334155;
        }

        body.dark tbody tr:nth-child(odd) {
            background-color: #273549;
        }

        body.dark tbody tr:hover {
            background-color: #3b4d63;
        }

        body.dark td {
            color: white;
        }

        .salary {
            font-weight: bold;
            color: #16a34a;
        }

        .action-btn {
            padding: 8px 12px;
            border: none;
            border-radius: 8px;
            color: white;
            cursor: pointer;
            font-size: 13px;
            margin: 2px;
        }

        .edit-btn {
            background: #f59e0b;
        }

        .delete-btn {
            background: #dc2626;
        }

        .footer-note {
            margin-top: 18px;
            text-align: center;
            color: #64748b;
            font-size: 14px;
        }

        body.dark .footer-note {
            color: #cbd5e1;
        }

        @media (max-width: 768px) {
            .header h1 {
                font-size: 26px;
            }

            .top-bar {
                flex-direction: column;
                align-items: stretch;
            }

            .controls {
                flex-direction: column;
            }

            input, select, button {
                width: 100%;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <div class="header">
        <h1>Employee Management System</h1>
        <p>PHP + SQL Server + XAMPP + Internal CSS</p>
    </div>

    <div class="top-bar">
        <div class="controls">
            <input type="text" id="searchInput" placeholder="Search by name, job, emp no...">

            <select id="deptFilter">
                <option value="">All Departments</option>
                <?php foreach ($departments as $dept) { ?>
                    <option value="<?php echo $dept; ?>"><?php echo $dept; ?></option>
                <?php } ?>
            </select>

            <button class="dark-btn" onclick="toggleDarkMode()">Toggle Dark Mode</button>
        </div>

        <div class="badge">
            Total Employees: <?php echo count($rows); ?>
        </div>
    </div>

    <div class="table-wrapper">
        <table id="empTable">
            <thead>
                <tr>
                    <th>Emp No</th>
                    <th>Name</th>
                    <th>Job</th>
                    <th>Manager</th>
                    <th>Hire Date</th>
                    <th>Salary</th>
                    <th>Commission</th>
                    <th>Dept No</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($rows as $row) { ?>
                    <tr data-dept="<?php echo $row['DEPTNO']; ?>">
                        <td><?php echo $row['EMPNO']; ?></td>
                        <td><?php echo htmlspecialchars($row['ENAME']); ?></td>
                        <td><?php echo htmlspecialchars($row['JOB']); ?></td>
                        <td><?php echo $row['MGR']; ?></td>
                        <td>
                            <?php
                            echo ($row['HIREDATE'] instanceof DateTime)
                                ? $row['HIREDATE']->format('d-m-Y')
                                : $row['HIREDATE'];
                            ?>
                        </td>
                        <td class="salary"><?php echo $row['SAL']; ?></td>
                        <td><?php echo $row['COMM']; ?></td>
                        <td><?php echo $row['DEPTNO']; ?></td>
                        <td>
                            <a href="edit.php?empno=<?php echo $row['EMPNO']; ?>">
    <button class="action-btn edit-btn">Edit</button>
</a>
                            <a href="delete.php?empno=<?php echo $row['EMPNO']; ?>" 
   onclick="return confirm('Are you sure you want to delete this employee?')">
    <button class="action-btn delete-btn">Delete</button>
</a>
                        </td>
                    </tr>
                <?php } ?>
            </tbody>
        </table>
    </div>

    <div class="footer-note">
        Done By Mohammad Rohaan (22I-2327) Lab# 09 Sec-E
    </div>
</div>

<script>
    const searchInput = document.getElementById("searchInput");
    const deptFilter = document.getElementById("deptFilter");
    const tableRows = document.querySelectorAll("#empTable tbody tr");

    function filterTable() {
        const searchValue = searchInput.value.toLowerCase();
        const deptValue = deptFilter.value;

        tableRows.forEach(row => {
            const rowText = row.textContent.toLowerCase();
            const rowDept = row.getAttribute("data-dept");

            const matchSearch = rowText.includes(searchValue);
            const matchDept = deptValue === "" || rowDept === deptValue;

            row.style.display = (matchSearch && matchDept) ? "" : "none";
        });
    }

    searchInput.addEventListener("keyup", filterTable);
    deptFilter.addEventListener("change", filterTable);

    function toggleDarkMode() {
        document.body.classList.toggle("dark");
    }
</script>

</body>
</html>

<?php
sqlsrv_free_stmt($stmt);
sqlsrv_close($conn);
?>