<?php
$pageTitle = 'View order — SuperStore';
require_once __DIR__ . '/config/database.php';
$db = superstore_sqlsrv_connect();
$conn = $db['conn'];
$order = null;
$customer = null;
$dbError = '';
$details = array();

$orderID = isset($_GET['OrderID']) ? (int) $_GET['OrderID'] : 0;

if (!$conn) {
    $dbError = superstore_connect_error_message($db['errors']);
} elseif ($orderID > 0) {
    $sql = 'SELECT * FROM Invoice WHERE [Inv#] = ?';
    $stmt = sqlsrv_query($conn, $sql, array($orderID));
    if ($stmt === false) {
        $dbError = 'Query failed.';
    } else {
        $order = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC);
        sqlsrv_free_stmt($stmt);
    }

    if ($order && isset($order['Cid'])) {
        $sqlCustomer = 'SELECT * FROM Customer WHERE Cid = ?';
        $stmtC = sqlsrv_query($conn, $sqlCustomer, array($order['Cid']));
        if ($stmtC) {
            $customer = sqlsrv_fetch_array($stmtC, SQLSRV_FETCH_ASSOC);
            sqlsrv_free_stmt($stmtC);
        }
    }

    if ($order) {
        $sqlDetails = 'SELECT * FROM OrderDetail WHERE [Inv#] = ? ORDER BY Pid ASC';
        $stmtD = sqlsrv_query($conn, $sqlDetails, array($orderID));
        if ($stmtD) {
            while ($row = sqlsrv_fetch_array($stmtD, SQLSRV_FETCH_ASSOC)) {
                $details[] = $row;
            }
            sqlsrv_free_stmt($stmtD);
        }
    }
}

function format_sql_date($v)
{
    if ($v instanceof DateTimeInterface) {
        return $v->format('Y-m-d');
    }
    if (is_string($v)) {
        return $v;
    }
    return '';
}

require __DIR__ . '/partials/head.php';
?>

<div class="card card-wide">
    <h2 class="card-title">Invoice / order</h2>
    <p class="card-sub">Enter an invoice number (<code>Inv#</code>) to see the header, customer, and line items.</p>

    <?php if ($dbError !== '') { ?>
        <div class="alert alert-error" role="alert"><?php echo htmlspecialchars($dbError, ENT_QUOTES, 'UTF-8'); ?></div>
    <?php } ?>

    <form class="lookup-form" method="get" action="customer_order_output.php">
        <div class="form-group">
            <label class="form-label" for="OrderID">Invoice #</label>
            <input type="number" id="OrderID" name="OrderID" required min="1" value="<?php echo $orderID > 0 ? (int) $orderID : '1'; ?>">
        </div>
        <button type="submit" class="btn btn-primary">Load invoice</button>
    </form>

    <?php if ($orderID > 0 && $order) { ?>
        <h3 class="subsection-title">Invoice</h3>
        <dl class="detail-list">
            <div class="detail-pair"><dt>Invoice #</dt><dd><?php echo htmlspecialchars((string) $order['Inv#'], ENT_QUOTES, 'UTF-8'); ?></dd></div>
            <div class="detail-pair"><dt>Invoice date</dt><dd><?php echo htmlspecialchars(format_sql_date($order['InvDate']), ENT_QUOTES, 'UTF-8'); ?></dd></div>
            <div class="detail-pair"><dt>Total amount</dt><dd><?php echo htmlspecialchars((string) $order['TotalAmount'], ENT_QUOTES, 'UTF-8'); ?></dd></div>
        </dl>

        <h3 class="subsection-title">Customer</h3>
        <?php if ($customer) { ?>
            <dl class="detail-list">
                <div class="detail-pair"><dt>Name</dt><dd><?php echo htmlspecialchars((string) $customer['CName'], ENT_QUOTES, 'UTF-8'); ?></dd></div>
                <div class="detail-pair"><dt>Address</dt><dd><?php echo htmlspecialchars((string) $customer['Address'], ENT_QUOTES, 'UTF-8'); ?></dd></div>
                <div class="detail-pair"><dt>Phone</dt><dd><?php echo htmlspecialchars((string) $customer['TelNo'], ENT_QUOTES, 'UTF-8'); ?></dd></div>
            </dl>
        <?php } else { ?>
            <p class="muted">Customer row not found for this invoice.</p>
        <?php } ?>

        <h3 class="subsection-title">Line items</h3>
        <?php if (count($details) > 0) { ?>
            <div class="table-wrap">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Product ID</th>
                            <th>Product name</th>
                            <th>Qty</th>
                            <th>Unit price</th>
                            <th>Extended</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($details as $detail) {
                            $sqlProduct = 'SELECT * FROM Product WHERE Pid = ?';
                            $stmtP = sqlsrv_query($conn, $sqlProduct, array($detail['Pid']));
                            $product = $stmtP ? sqlsrv_fetch_array($stmtP, SQLSRV_FETCH_ASSOC) : null;
                            if ($stmtP) {
                                sqlsrv_free_stmt($stmtP);
                            }
                            $pname = $product ? $product['PName'] : '—';
                            ?>
                            <tr>
                                <td><?php echo htmlspecialchars((string) $detail['Pid'], ENT_QUOTES, 'UTF-8'); ?></td>
                                <td><?php echo htmlspecialchars((string) $pname, ENT_QUOTES, 'UTF-8'); ?></td>
                                <td><?php echo htmlspecialchars((string) $detail['Qty'], ENT_QUOTES, 'UTF-8'); ?></td>
                                <td><?php echo htmlspecialchars((string) $detail['SPrice'], ENT_QUOTES, 'UTF-8'); ?></td>
                                <td><?php echo htmlspecialchars((string) $detail['ExtendPrice'], ENT_QUOTES, 'UTF-8'); ?></td>
                            </tr>
                        <?php } ?>
                    </tbody>
                </table>
            </div>
        <?php } else { ?>
            <p class="muted">No line items for this invoice.</p>
        <?php } ?>
    <?php } elseif ($orderID > 0 && !$dbError) { ?>
        <p class="muted">No invoice found for #<?php echo (int) $orderID; ?>.</p>
    <?php } ?>
</div>

<?php
if ($conn) {
    sqlsrv_close($conn);
}
require __DIR__ . '/partials/footer.php';
?>
