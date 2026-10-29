<?php

function fetchTableData($conn, $tableName)
{
    $allowedTables = array("DEPT", "EMP", "BONUS", "SALGRADE", "DUMMY", "Project", "ProjAssign");

    if (!in_array($tableName, $allowedTables)) {
        return false;
    }

    $sql = "SELECT * FROM $tableName";
    $stmt = sqlsrv_query($conn, $sql);

    if ($stmt === false) {
        die("<pre>Query Error:\n" . print_r(sqlsrv_errors(), true) . "</pre>");
    }

    $rows = array();

    while ($row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)) {
        $rows[] = $row;
    }

    return $rows;
}

function displayTable($data)
{
    if (!$data || count($data) == 0) {
        echo "<p>No records found.</p>";
        return;
    }

    echo "<table border='1' cellpadding='10' cellspacing='0'>";
    echo "<tr>";

    foreach (array_keys($data[0]) as $column) {
        echo "<th>" . htmlspecialchars($column) . "</th>";
    }

    echo "</tr>";

    foreach ($data as $row) {
        echo "<tr>";
        foreach ($row as $value) {
            if ($value instanceof DateTime) {
                echo "<td>" . $value->format('Y-m-d H:i:s') . "</td>";
            } else {
                echo "<td>" . htmlspecialchars((string)($value ?? "NULL")) . "</td>";
            }
        }
        echo "</tr>";
    }

    echo "</table>";
}

function fetchFullDatabaseView($conn)
{
    $sql = "
        SELECT 
            E.EMPNO,
            E.ENAME,
            E.JOB,
            E.MGR,
            E.HIREDATE,
            E.SAL,
            E.COMM,
            D.DEPTNO,
            D.DNAME,
            D.LOC,
            P.Projno,
            P.ProjName,
            P.ProjType,
            P.StartDate,
            P.EndDate,
            P.HrsRate,
            PA.ProjPeriod,
            PA.NoOfHrs,
            S.GRADE,
            S.LOSAL,
            S.HISAL
        FROM EMP E
        LEFT JOIN DEPT D ON E.DEPTNO = D.DEPTNO
        LEFT JOIN ProjAssign PA ON E.EMPNO = PA.Empno
        LEFT JOIN Project P ON PA.Projno = P.Projno
        LEFT JOIN SALGRADE S ON E.SAL BETWEEN S.LOSAL AND S.HISAL
        ORDER BY E.EMPNO
    ";

    $stmt = sqlsrv_query($conn, $sql);

    if ($stmt === false) {
        die("<pre>Join Query Error:\n" . print_r(sqlsrv_errors(), true) . "</pre>");
    }

    $rows = array();

    while ($row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)) {
        $rows[] = $row;
    }

    return $rows;
}

function searchEmployeeById($conn, $empId)
{
    $sql = "
        SELECT 
            E.EMPNO,
            E.ENAME,
            E.JOB,
            E.MGR,
            E.HIREDATE,
            E.SAL,
            E.COMM,
            D.DEPTNO,
            D.DNAME,
            D.LOC,
            P.Projno,
            P.ProjName,
            P.ProjType,
            P.StartDate,
            P.EndDate,
            P.HrsRate,
            PA.ProjPeriod,
            PA.NoOfHrs,
            S.GRADE,
            S.LOSAL,
            S.HISAL
        FROM EMP E
        LEFT JOIN DEPT D ON E.DEPTNO = D.DEPTNO
        LEFT JOIN ProjAssign PA ON E.EMPNO = PA.Empno
        LEFT JOIN Project P ON PA.Projno = P.Projno
        LEFT JOIN SALGRADE S ON E.SAL BETWEEN S.LOSAL AND S.HISAL
        WHERE E.EMPNO = ?
    ";

    $params = array($empId);
    $stmt = sqlsrv_query($conn, $sql, $params);

    if ($stmt === false) {
        die("<pre>Search Query Error:\n" . print_r(sqlsrv_errors(), true) . "</pre>");
    }

    $rows = array();

    while ($row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)) {
        $rows[] = $row;
    }

    return $rows;
}

function insertDepartment($conn, $deptno, $dname, $loc)
{
    $sql = "INSERT INTO DEPT (DEPTNO, DNAME, LOC) VALUES (?, ?, ?)";
    $params = array($deptno, $dname, $loc);

    $stmt = sqlsrv_query($conn, $sql, $params);

    if ($stmt === false) {
        return false;
    }

    return true;
}

function insertEmployee($conn, $empno, $ename, $job, $mgr, $hiredate, $sal, $comm, $deptno)
{
    $sql = "INSERT INTO EMP (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

    $params = array($empno, $ename, $job, $mgr, $hiredate, $sal, $comm, $deptno);

    $stmt = sqlsrv_query($conn, $sql, $params);

    if ($stmt === false) {
        return false;
    }

    return true;
}


function deleteEmployee($conn, $empno)
{
    $sql = "DELETE FROM EMP WHERE EMPNO = ?";
    $params = array($empno);

    $stmt = sqlsrv_query($conn, $sql, $params);

    if ($stmt === false) {
        die("<pre>Delete Employee Error:\n" . print_r(sqlsrv_errors(), true) . "</pre>");
    }

    return true;
}

function deleteDepartment($conn, $deptno)
{
    $sql = "DELETE FROM DEPT WHERE DEPTNO = ?";
    $params = array($deptno);

    $stmt = sqlsrv_query($conn, $sql, $params);

    if ($stmt === false) {
        die("<pre>Delete Department Error:\n" . print_r(sqlsrv_errors(), true) . "</pre>");
    }

    return true;
}

function updateEmployee($conn, $empno, $ename, $job, $mgr, $hiredate, $sal, $comm, $deptno)
{
    $sql = "UPDATE EMP
            SET ENAME = ?, JOB = ?, MGR = ?, HIREDATE = ?, SAL = ?, COMM = ?, DEPTNO = ?
            WHERE EMPNO = ?";

    $params = array($ename, $job, $mgr, $hiredate, $sal, $comm, $deptno, $empno);

    $stmt = sqlsrv_query($conn, $sql, $params);

    if ($stmt === false) {
        die("<pre>Update Employee Error:\n" . print_r(sqlsrv_errors(), true) . "</pre>");
    }

    return true;
}

function updateDepartment($conn, $deptno, $dname, $loc)
{
    $sql = "UPDATE DEPT
            SET DNAME = ?, LOC = ?
            WHERE DEPTNO = ?";

    $params = array($dname, $loc, $deptno);

    $stmt = sqlsrv_query($conn, $sql, $params);

    if ($stmt === false) {
        die("<pre>Update Department Error:\n" . print_r(sqlsrv_errors(), true) . "</pre>");
    }

    return true;
}

function searchRecords($conn, $tableName, $searchValue)
{
    $allowedTables = array("DEPT", "EMP", "BONUS", "SALGRADE", "DUMMY", "Project", "ProjAssign");

    if (!in_array($tableName, $allowedTables)) {
        return array();
    }

    switch ($tableName) {
        case "DEPT":
            $sql = "SELECT * FROM DEPT WHERE CAST(DEPTNO AS VARCHAR) LIKE ? OR DNAME LIKE ? OR LOC LIKE ?";
            $params = array("%$searchValue%", "%$searchValue%", "%$searchValue%");
            break;

        case "EMP":
            $sql = "SELECT * FROM EMP WHERE CAST(EMPNO AS VARCHAR) LIKE ? OR ENAME LIKE ? OR JOB LIKE ?";
            $params = array("%$searchValue%", "%$searchValue%", "%$searchValue%");
            break;

        case "BONUS":
            $sql = "SELECT * FROM BONUS WHERE ENAME LIKE ? OR JOB LIKE ?";
            $params = array("%$searchValue%", "%$searchValue%");
            break;

        case "SALGRADE":
            $sql = "SELECT * FROM SALGRADE WHERE CAST(GRADE AS VARCHAR) LIKE ?";
            $params = array("%$searchValue%");
            break;

        case "DUMMY":
            $sql = "SELECT * FROM DUMMY WHERE CAST(DUMMY AS VARCHAR) LIKE ?";
            $params = array("%$searchValue%");
            break;

        case "Project":
            $sql = "SELECT * FROM Project WHERE Projno LIKE ? OR ProjName LIKE ? OR ProjType LIKE ?";
            $params = array("%$searchValue%", "%$searchValue%", "%$searchValue%");
            break;

        case "ProjAssign":
            $sql = "SELECT * FROM ProjAssign WHERE Projno LIKE ? OR CAST(Empno AS VARCHAR) LIKE ? OR ProjPeriod LIKE ?";
            $params = array("%$searchValue%", "%$searchValue%", "%$searchValue%");
            break;

        default:
            return array();
    }

    $stmt = sqlsrv_query($conn, $sql, $params);

    if ($stmt === false) {
        die("<pre>Search Records Error:\n" . print_r(sqlsrv_errors(), true) . "</pre>");
    }

    $rows = array();

    while ($row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)) {
        $rows[] = $row;
    }

    return $rows;
}

?>