<?php
$pageTitle = 'Customer lookup — SuperStore';
require_once __DIR__ . '/config/database.php';
$db = superstore_sqlsrv_connect();
$conn = $db['conn'];
$customer = null;
$dbError = '';

$customerID = isset($_GET['CustomerID']) ? (int) $_GET['CustomerID'] : 0;

if (!$conn) {
    $dbError = superstore_connect_error_message($db['errors']);
} elseif ($customerID > 0) {
    $sql = 'SELECT * FROM Customer WHERE Cid = ?';
    $stmt = sqlsrv_query($conn, $sql, array($customerID));
    if ($stmt === false) {
        $dbError = 'Query failed.';
    } else {
        $customer = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC);
        sqlsrv_free_stmt($stmt);
    }
}

require __DIR__ . '/partials/head.php';
?>

<div class="card">
    <h2 class="card-title">Customer details</h2>
    <p class="card-sub">Enter a customer ID to load name, city, address, and phone.</p>

    <?php if ($dbError !== '') { ?>
        <div class="alert alert-error" role="alert"><?php echo htmlspecialchars($dbError, ENT_QUOTES, 'UTF-8'); ?></div>
    <?php } ?>

    <form class="lookup-form" method="get" action="customer_master_form.php">
        <div class="form-group">
            <label class="form-label" for="CustomerID">Customer ID</label>
            <input type="number" id="CustomerID" name="CustomerID" required min="1" value="<?php echo $customerID > 0 ? (int) $customerID : ''; ?>" placeholder="e.g. 1">
        </div>
        <button type="submit" class="btn btn-primary">Load customer</button>
    </form>

    <?php if ($customerID > 0 && $customer) { ?>
        <h3 class="subsection-title">Result</h3>
        <dl class="detail-list">
            <div class="detail-pair"><dt>Customer ID</dt><dd><?php echo htmlspecialchars((string) $customer['Cid'], ENT_QUOTES, 'UTF-8'); ?></dd></div>
            <div class="detail-pair"><dt>Name</dt><dd><?php echo htmlspecialchars((string) $customer['CName'], ENT_QUOTES, 'UTF-8'); ?></dd></div>
            <div class="detail-pair"><dt>City</dt><dd><?php echo htmlspecialchars((string) $customer['City'], ENT_QUOTES, 'UTF-8'); ?></dd></div>
            <div class="detail-pair"><dt>Address</dt><dd><?php echo htmlspecialchars((string) $customer['Address'], ENT_QUOTES, 'UTF-8'); ?></dd></div>
            <div class="detail-pair"><dt>Telephone</dt><dd><?php echo htmlspecialchars((string) $customer['TelNo'], ENT_QUOTES, 'UTF-8'); ?></dd></div>
        </dl>
    <?php } elseif ($customerID > 0 && !$dbError) { ?>
        <p class="muted">No customer found for ID <?php echo (int) $customerID; ?>.</p>
    <?php } ?>
</div>

<?php require __DIR__ . '/partials/footer.php'; ?>
