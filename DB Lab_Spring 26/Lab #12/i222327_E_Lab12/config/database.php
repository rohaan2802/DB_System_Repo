<?php
/**
 * Single place for SQL Server connection settings (sqlsrv).
 *
 * If you see "Could not connect" on every page except Home / Orders:
 * - Orders only checks the connection when you submit; fix the settings below.
 * - Try: 127.0.0.1, or .\SQLEXPRESS, or localhost\SQLEXPRESS (named instance).
 * - Optional: set env SUPERSTORE_DB_SERVER to override the server name.
 */

function superstore_db_config()
{
    $server = getenv('SUPERSTORE_DB_SERVER');
    if (!is_string($server) || $server === '') {
        // 127.0.0.1 often works when "localhost" fails (IPv6 / named pipes).
        $server = '127.0.0.1';
    }

    return array(
        'server' => $server,
        'database' => 'SuperStoreDB',
        'uid' => 'scott',
        'pwd' => 'tiger1234',
    );
}

/**
 * @return array{conn: resource|false, errors: array|null}
 */
function superstore_sqlsrv_connect()
{
    if (!function_exists('sqlsrv_connect')) {
        return array(
            'conn' => false,
            'errors' => array(
                array('SQLSTATE' => 'IMSSP', 'code' => -1, 'message' => 'PHP sqlsrv extension is not loaded. Enable it in php.ini for your web server (not only CLI).'),
            ),
        );
    }

    $c = superstore_db_config();
    $connectionInfo = array(
        'Database' => $c['database'],
        'Uid' => $c['uid'],
        'PWD' => $c['pwd'],
        'CharacterSet' => 'UTF-8',
        'LoginTimeout' => 15,
        // Helps with ODBC Driver 18+ when connecting to local SQL Server without a trusted cert chain.
        'TrustServerCertificate' => true,
    );

    $conn = sqlsrv_connect($c['server'], $connectionInfo);
    $errors = $conn ? null : sqlsrv_errors();

    return array('conn' => $conn, 'errors' => $errors);
}

function superstore_connect_error_message($errors)
{
    if (!is_array($errors) || !isset($errors[0]['message'])) {
        return 'Could not connect to the database.';
    }

    return 'Could not connect to the database. ' . $errors[0]['message'];
}
